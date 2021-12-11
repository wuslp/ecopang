package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ActDAO {	
	//커넥션
	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}	
	public int insertAct(ActDTO dto) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		int res = 0;
		try {
			conn = getConnection();
			String sql = "insert into activities values(act_seq.nextVal,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getGroup_num());
			pstmt.setString(2, dto.getAct_title());
			pstmt.setString(3, dto.getPlace());
			pstmt.setString(4, dto.getAct_time());
			pstmt.setInt(5, dto.getMax_user());
			pstmt.setString(6, dto.getUser_nickname());	
			pstmt.setString(7, dto.getAct_date());
			pstmt.setString(8, dto.getUserID());
			res = pstmt.executeUpdate();
			
		}catch(Exception e) {
			
			e.printStackTrace();
			
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		return res;
	}
	// 수정메서드
	
	public int updateActivity(ActDTO activity) {
		System.out.println(activity.getUserID());
		activity.setUserID("USER01");
		Connection conn = null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int res = 0;
		try {
			conn=getConnection();
			// 작성자 정보가 맞아야함.........로그인 정보...
			String sql="select userId from activities where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, activity.getUserID());
			rs=pstmt.executeQuery();
			if(rs.next()) {
				String dbuserId =rs.getString("userId");
				if(dbuserId.equals(activity.getUserID())){
					sql = "update activities set act_title=?, place=?, act_date=?, act_time=?, max_user=? where act_num=? and userId=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, activity.getAct_title());
					pstmt.setString(2, activity.getPlace());
					pstmt.setString(3, activity.getAct_date());
					pstmt.setString(4, activity.getAct_time());
					pstmt.setInt(5, activity.getMax_user());
					pstmt.setInt(6, activity.getAct_num());	
					pstmt.setString(7, activity.getUserID());	
					res = pstmt.executeUpdate();
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		return res;
	}
	
	// 삭제
	
	
	// 활동 리스트를 열어봅시다
	//총 활동 개수
		public int getActCount(int group_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn = getConnection();
				String sql = "select count(*) from Activities where sysdate-1 <= to_date(act_date, 'yyyy-mm-dd') and group_num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					count = rs.getInt(1); //1번 칼럼에 있는 거 가져오기	
				}
				
			}catch(Exception e){
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			return count;
		}
		
			public int getEndActCount(int group_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn = getConnection();
				String sql = "select count(*) from Activities where sysdate > to_date(act_date, 'yyyy-mm-dd') and group_num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					count = rs.getInt(1); //1번 칼럼에 있는 거 가져오기	
				}
				
			}catch(Exception e){
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			return count;
		}
		
		//활동 목록 불러오는 메서드!
		public List getActivities (int start, int end, int group_num) { 
			List actList = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "select act_num, group_num, act_title, place, act_time, max_user, user_nickname, act_date, userID, r from " + 
						"(select act_num, group_num, act_title, place, act_time, max_user, user_nickname, act_date, userID, rownum r from " +
						"(select * from activities where sysdate-1 <= to_date(act_date, 'yyyy-mm-dd') and group_num = ? order by to_date(act_date, 'yyyy-mm-dd') asc))" + 
						"where r >= ? and r <= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
				
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					actList = new ArrayList();
					do {
						ActDTO dto = new ActDTO();
						dto.setAct_num(rs.getInt(1));
						dto.setGroup_num(rs.getInt(2));
						dto.setAct_title(rs.getString(3));
						dto.setPlace(rs.getString(4));
						dto.setAct_time(rs.getString(5));
						dto.setMax_user(rs.getInt(6));
						dto.setUser_nickname(rs.getString(7));
						dto.setAct_date(rs.getString(8));
						dto.setUserID(rs.getString(9));
						actList.add(dto);
					}while(rs.next());
				}
			}catch(Exception e){
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			
			return actList;
		}
		
	
		public List getEndActivities (int start, int end, int group_num) { 
			List actList = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "select act_num, group_num, act_title, place, act_time, max_user, user_nickname, act_date, userID, r from " + 
						"(select act_num, group_num, act_title, place, act_time, max_user, user_nickname, act_date, userID, rownum r from " +
						"(select * from activities where sysdate > to_date(act_date, 'yyyy-mm-dd') and group_num = ? order by to_date(act_date, 'yyyy-mm-dd') asc))" + 
						"where r >= ? and r <= ?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
				
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					actList = new ArrayList();
					do {
						ActDTO dto = new ActDTO();
						dto.setAct_num(rs.getInt(1));
						dto.setGroup_num(rs.getInt(2));
						dto.setAct_title(rs.getString(3));
						dto.setPlace(rs.getString(4));
						dto.setAct_time(rs.getString(5));
						dto.setMax_user(rs.getInt(6));
						dto.setUser_nickname(rs.getString(7));
						dto.setAct_date(rs.getString(8));
						dto.setUserID(rs.getString(9));
						actList.add(dto);
					}while(rs.next());
				}
			}catch(Exception e){
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			
			return actList;
		}
	
	
	
	
//	//활동 고유번호 받기
	public ActDTO getActivityNum(int act_num) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		ActDTO activity=null;
		try {
			conn=getConnection();
			String sql="Select * from activities where act_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, 1);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				activity = new ActDTO();
				activity.setAct_num(act_num);
				activity.setGroup_num(rs.getInt("Group_num"));
				activity.setAct_title(rs.getString("title"));
				activity.setPlace(rs.getString("Place"));
				activity.setAct_date(rs.getString("date"));
				activity.setAct_time(rs.getString("time"));
				activity.setMax_user(rs.getInt("count"));
				activity.setUser_nickname(rs.getString("user_nickname"));	
				activity.setUserID(rs.getString("userId"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		return activity;
	}
	
	// 삭제
	public int deleteActivity(int act_num) {
		Connection conn = null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int result = 0;
		try {
			conn=getConnection();
			String sql = "delete from activities where act_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, act_num);
			result = pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		return result;
	}
	
	public String getActMaster(int act_num) {
		Connection conn = null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		String result = null;
		try {
			conn=getConnection();
			String sql="select userID from activities where act_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, act_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		
		return result;
	}
	
	
	public int getSearchActCount(String sel, String search, int group_num) {
		Connection conn = null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		int result = 0;
		try {
			conn=getConnection();
			String sql="select count(*) from activities where " + sel + " like '%" + search + "%' and group_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace(); }
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		
		return result;
	}
	
	public List getSearchActivities (int start, int end,String sel, String search, int group_num) { 
		List actList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select * from (select A.*, rownum r from (select * from activities " + 
					"where group_num = ? order by to_date(act_date,'yyyy-mm-dd') desc)A where " + sel + " like '%" + search + "%' order by r) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				actList = new ArrayList();
				do {
					ActDTO dto = new ActDTO();
					dto.setAct_num(rs.getInt(1));
					dto.setGroup_num(rs.getInt(2));
					dto.setAct_title(rs.getString(3));
					dto.setPlace(rs.getString(4));
					dto.setAct_time(rs.getString(5));
					dto.setMax_user(rs.getInt(6));
					dto.setUser_nickname(rs.getString(7));
					dto.setAct_date(rs.getString(8));
					dto.setUserID(rs.getString(9));
					actList.add(dto);
				}while(rs.next());
			}
		}catch(Exception e){
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		
		return actList;
	}
}
