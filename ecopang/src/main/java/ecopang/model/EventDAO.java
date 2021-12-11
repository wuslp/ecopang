package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class EventDAO {

	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env=(Context)ctx.lookup("java:comp/env");
		DataSource ds=(DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	//이벤트 추가
	public void insertEvent(EventDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "insert into eventList values(eventList_seq.nextVal,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getEve_title());
			pstmt.setString(2, dto.getEve_startdate());
			pstmt.setString(3, dto.getEve_enddate());
			pstmt.setString(4, dto.getEve_content());
			pstmt.setString(5, dto.getEve_img());
			pstmt.setInt(6, dto.getEve_hit());
			
			pstmt.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
		}
	}
	
	
	//이벤트 개수 가져오는 메서드
	public int getEventCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from eventList";
			pstmt = conn.prepareStatement(sql);
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
	
	
	//이벤트 리스트 불러오는 메서드!
	public List getEvents(int start, int end) { 
		List eventList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select eve_num, eve_title, eve_startdate, eve_enddate, eve_content, eve_img, eve_hit, r from " + 
					"(select  eve_num, eve_title, eve_startdate, eve_enddate, eve_content,eve_img, eve_hit, rownum r from " +
					"(select * from eventList order by eve_enddate desc))" + 
					"where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				eventList = new ArrayList();
				do {
					EventDTO dto = new EventDTO();
					dto.setEve_num(rs.getInt(1));
					dto.setEve_title(rs.getString(2));
					dto.setEve_startdate(rs.getString(3));
					dto.setEve_enddate(rs.getString(4));
					dto.setEve_content(rs.getString(5));
					dto.setEve_img(rs.getString(6));
					dto.setEve_hit(rs.getInt(7));
					eventList.add(dto);
				}while(rs.next());
			}
		}catch(Exception e){
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		
		return eventList;
	}
	
	//이벤트 상세페이지 하나 가져 오는 메서드
	public EventDTO getEventContent(int eve_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		EventDTO dto = null;
		
		try {
			conn = getConnection();
			
			String sql = "update eventList set eve_hit = eve_hit+1 where eve_hit = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_num);
			
			pstmt.executeUpdate();
			
			sql = "select * from eventList where eve_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_num);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new EventDTO();
				dto.setEve_num(rs.getInt(1));
				dto.setEve_title(rs.getString(2));
				dto.setEve_startdate(rs.getString(3));
				dto.setEve_enddate(rs.getString(4));
				dto.setEve_content(rs.getString(5));
				dto.setEve_img(rs.getString(6));
				dto.setEve_hit(rs.getInt(7));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return dto;
	}
	
	public void updateEvent(EventDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			

			String sql = "update eventList set eve_title = ?, eve_startdate = ?, eve_enddate = ?, eve_content = ?, eve_img = ?, eve_hit = ? where eve_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getEve_title());
			pstmt.setString(2, dto.getEve_startdate());
			pstmt.setString(3, dto.getEve_enddate());
			pstmt.setString(4, dto.getEve_content());
			pstmt.setString(5, dto.getEve_img());
			pstmt.setInt(6, dto.getEve_hit());
			pstmt.setInt(7, dto.getEve_num());
		
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	public void deleteEvent(int eve_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "delete from eventList where eve_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_num);
			pstmt.executeUpdate();
			
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	
	public void deleteTopicComment(int eve_com_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from eventComments where eve_com_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_com_num);

			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	//이벤트 리스트 불러오는 메서드!
		public List getMainEvents() { 
			List eventList = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "select eve_num, eve_title, eve_startdate, eve_enddate, eve_content, eve_img, eve_hit, r " + 
						"from (select eve_num, eve_title, eve_startdate, eve_enddate, eve_content,eve_img, eve_hit, rownum r " + 
						"from (select * from eventList where sysdate between to_date(eve_startdate,'YYYY-MM-DD') and to_date(eve_enddate,'YYYY-MM-DD') order by eve_num desc))";
				pstmt = conn.prepareStatement(sql);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					eventList = new ArrayList();
					do {
						EventDTO dto = new EventDTO();
						dto.setEve_num(rs.getInt(1));
						dto.setEve_title(rs.getString(2));
						dto.setEve_startdate(rs.getString(3));
						dto.setEve_enddate(rs.getString(4));
						dto.setEve_content(rs.getString(5));
						dto.setEve_img(rs.getString(6));
						dto.setEve_hit(rs.getInt(7));
						eventList.add(dto);
					}while(rs.next());
				}
			}catch(Exception e){
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			
			return eventList;
		}
}
