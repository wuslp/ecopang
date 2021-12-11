package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReviewLikesDAO {

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	

	public boolean userLikesReview(String userID, int revNum) { // 이 유저가 이 리뷰를 좋아하나요? 
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean userLikesReviewRs = false; // userLikesGroup 메서드 결과 담아줄 변수 
		
		try {
			conn = getConnection();
			String sql = "SELECT *  FROM reviewLikes WHERE userID = ? AND  rev_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setInt(2, revNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {
				userLikesReviewRs = false;
			}else {
				userLikesReviewRs = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		
		return userLikesReviewRs;
	}
	
	public void reviewLikeClick(String userId, int revNum) { // 리뷰 좋아요 클릭하면 실행되는 메서드
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT *  FROM reviewLikes WHERE userID=? AND  rev_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setInt(2, revNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {	//좋아요가  없으면
				sql = "insert into reviewLikes values(?,?)"; //좋아요로 저장해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, revNum);
				
				pstmt.executeUpdate();
				
				sql = "update reviews set likescount = likescount +1 where rev_num = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, revNum);
				pstmt.executeUpdate();
				
			}else { // 좋아요 있으면
				sql = "delete from reviewlikes where userId=? and rev_num=?"; //좋아요있던거 삭제해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, revNum);
				
				pstmt.executeUpdate();
				
				sql = "update reviews set likescount = likescount -1 where rev_num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, revNum);
				
				pstmt.executeUpdate();
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		} 
	}
	
	
	
	public int reviewLikeCount(int revNum) {
		int reviewlikecount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT count(*) FROM reviewLikes WHERE rev_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, revNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				reviewlikecount = rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return reviewlikecount;
	}
	
}
