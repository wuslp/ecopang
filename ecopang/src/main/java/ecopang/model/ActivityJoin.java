package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ActivityJoin {

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	
	public boolean userJoinsAct(String userID, int actNum) { // 이 유저가 이 활동에 참여중인가요?
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean userJoinsActRs = false; // userjoinAct 메서드 결과 담아줄 변수 
		
		try {
			conn = getConnection();
			String sql = "SELECT *  FROM activityJoin WHERE userID = ? AND  act_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setInt(2, actNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {
				userJoinsActRs = false;
			}else {
				userJoinsActRs = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		
		return userJoinsActRs;
	}
	
	public void actJoinClick(String userId, int actNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT *  FROM activityJoin WHERE userID=? AND  act_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setInt(2, actNum);
			rs = pstmt.executeQuery();
			if(!rs.next()) {	//활동중이 아니면
				sql = "insert into activityJoin values(?,?)"; //활동리스트레 넣어줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, actNum);
				
				pstmt.executeUpdate();
			}else { // 활동중이면
				sql = "delete from activityJoin where userId=? and act_num=?"; //활동중인거 취소해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, actNum);
				
				pstmt.executeUpdate();
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		} 
	}
	
	
	
	public int actJoinCount(int actNum) { //현재 활동 참여중인사람 수 세주는 메서드
		int actjoincount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT count(*) FROM activityJoin WHERE act_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, actNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				actjoincount = rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return actjoincount;
	}
	
	public List<String> getActMembers(int act_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<String> memberList = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT * FROM activityJoin WHERE act_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, act_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				memberList = new ArrayList<String>();
				String member = null;
				do {
					member = rs.getString(1);
					memberList.add(member);
				} while(rs.next());
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return memberList;
	}

}
