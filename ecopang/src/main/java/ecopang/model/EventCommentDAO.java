package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class EventCommentDAO {


	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env=(Context)ctx.lookup("java:comp/env");
		DataSource ds=(DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	// 게시글 댓글 추가하기
	public void insertEventComment(EventCommentDTO dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into eventcomments values(eventcomments_seq.nextVal,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getEve_num());
			pstmt.setString(2, dto.getUserID());
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getEve_comment());
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	public int getEveCommentCount(int eve_num) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = getConnection();
			String sql = "select count(*) from eventComments where eve_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt(1); // count(*)은 결과를 숫자로 가져오며, 컬럼명대신 컬럼번호로 꺼내기.
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return count;
	}
	
	public List getEveComments(int eve_num, int start, int end) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List eveCommentList = null;
		
		try {
			conn = getConnection();
			String sql = "select eve_com_num, eve_num, userID, nickname, eve_comment, eve_reg, r from("
					+ "select eve_com_num, eve_num, userID, nickname, eve_comment, eve_reg, rownum r from ("
					+ "select eve_com_num, eve_num, userID, nickname, eve_comment, eve_reg from eventComments where eve_num = ? order by eve_com_num desc)) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, eve_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				eveCommentList = new ArrayList(); // 결과가 있으면 list 객체 생성해서 준비
				do { // if문에서 rs.next() 실행되서 커서가 내려가버렸으니 do-while로 먼저 데이터 꺼내게 하기
					EventCommentDTO dto = new EventCommentDTO();
					dto.setEve_com_num(rs.getInt(1));
					dto.setEve_num(rs.getInt(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setEve_comment(rs.getString(5));
					dto.setEve_reg(rs.getTimestamp(6));
					eveCommentList.add(dto); // 리스트에 추가
				} while(rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return eveCommentList;
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
	
	
}
