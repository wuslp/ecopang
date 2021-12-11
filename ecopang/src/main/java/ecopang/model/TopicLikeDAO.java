package ecopang.model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TopicLikeDAO {

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	

	public boolean userLikesTpc(String userID, int tpc_num) { // 이 유저가 이 그룹을 좋아하나요? 
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean userLikesGroupRs = false; // userLikesTpc메서드 결과 담아줄 변수 
		
		try {
			conn = getConnection();
			String sql = "SELECT *  FROM topicLikes WHERE userID = ? AND  tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setInt(2, tpc_num);
			rs = pstmt.executeQuery();
			if(!rs.next()) {
				userLikesGroupRs = false;
			}else {
				userLikesGroupRs = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		
		return userLikesGroupRs;
	}
	
	public void tpcLikeClick(String userId, int tpcNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT *  FROM topicLikes WHERE userID=? AND  tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setInt(2, tpcNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {	//좋아요가  없으면
				sql = "insert into topicLikes values(?,?)"; //좋아요 눌러줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, tpcNum);
				
				pstmt.executeUpdate();
			}else { // 좋아요 있으면
				sql = "delete from topicLikes where userId=? and tpc_num=?"; //좋아요있던거 삭제해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, tpcNum);
				
				pstmt.executeUpdate();
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		} 
	}
	
	
	
	public int tpcLikeCount(int tpcNum) {
		int tpclikecount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT count(*) FROM topicLikes WHERE tpc_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpcNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				tpclikecount = rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return tpclikecount;
	}

	
}
