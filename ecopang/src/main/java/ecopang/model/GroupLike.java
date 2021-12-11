package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GroupLike {

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	
	

	
	
	public boolean userLikesGroup(String userID, int groupNum) { // 이 유저가 이 그룹을 좋아하나요? 
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean userLikesGroupRs = false; // userLikesGroup 메서드 결과 담아줄 변수 
		
		try {
			conn = getConnection();
			String sql = "SELECT *  FROM groupLikes WHERE userID = ? AND  group_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setInt(2, groupNum);
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
	
	public void groupLikeClick(String userId, int groupNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT *  FROM groupLikes WHERE userID=? AND  group_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setInt(2, groupNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {	//좋아요가  없으면
				sql = "insert into groupLikes values(?,?)"; //좋아요 눌러줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, groupNum);
				
				pstmt.executeUpdate();
			}else { // 좋아요 있으면
				sql = "delete from groupLikes where userId=? and group_num=?"; //좋아요있던거 삭제해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, groupNum);
				
				pstmt.executeUpdate();
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		} 
	}
	
	
	
	public int groupLikeCount(int groupNum) {
		int grouplikecount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT count(*) FROM groupLikes WHERE group_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, groupNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				grouplikecount = rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return grouplikecount;
	}

}
