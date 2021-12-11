package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ActivityJoinDAO {
	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	// 해당 유저가 참여중인지 아닌 처리하는 메서드 
	public boolean userAct(String userID, int actNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean userAct = false; // userAct 메서드 결과 담아줄 변수s
		
		try {
			conn=getConnection();
			String sql="select * from activityJoin where userID=? AND act_num=?";
			
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,userID);
			pstmt.setInt(2, actNum);
			
			rs=pstmt.executeQuery();
			if(!rs.next()) {
				userAct=false;
			}else {
				userAct=true;
			}	
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try{ pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try{ rs.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try{ conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return userAct;
		}
		
		// 활동 참가 클릭할때 마다 db에 업데이트 해주는 메서드
		public void actJoinClick(String userID, int actNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT *  FROM activityJoin WHERE userID=? AND  act_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setInt(2, actNum);
			rs = pstmt.executeQuery();
			
			if(!rs.next()) {	//활동중이 아니면
				sql = "insert into activityJoin values(?,?)"; //활동리스트에 넣어줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setInt(2, actNum);
				
				pstmt.executeUpdate();
			}else { // 활동중이면
				sql = "delete from activityJoin where userID=? and act_num=?"; //활동중인거 취소해줘라
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
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
		// 해당 활동에 참여중인 멤버 수 보여주는 메서드 
		public int actJoinCount(int actNum) { 
			int actjoincount = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "select count(*) from activityJoin WHERE act_num=?";
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

	}
	
	
	
	
	

