package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class InfoDAO {

	// 커넥션
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	// 공지사항 저장
	public void insertInfo(InfoDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into information(info_num, info_title, info_content, info_reg) "
					+ "values(information_seq.NEXTVAL,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getInfo_title());
			pstmt.setString(2, dto.getInfo_content());
			pstmt.setTimestamp(3, dto.getInfo_reg());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 게시글 전체 개수
	public int getInfoCount() {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select count(*) from information";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!= null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!= null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!= null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return count;
	}
	
	// 게시글 범위만큼 가져오는 메서드 
	public List getInfos(int start, int end) {
		Connection conn = null; 
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		List infoList = null; 
		try {
			conn = getConnection();
			String sql = "select info_num, info_title, info_content, info_reg, r from " 
					+"(select info_num, info_title, info_content, info_reg, rownum r from "
					+"(select * from information order by info_num desc)) "
					+"where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			if(rs.next()) {
				infoList = new ArrayList(); 
				do { 
					InfoDTO info = new InfoDTO();
					info.setInfo_num(rs.getInt("info_num"));
					info.setInfo_title(rs.getString("info_title"));
					info.setInfo_content(rs.getString("info_content"));
					info.setInfo_reg(rs.getTimestamp("info_reg"));
					infoList.add(info); // 리스트에 추가 
				}while(rs.next());
			}// if
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close(); } catch(Exception e) { e.printStackTrace();}
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) { e.printStackTrace();}
			if(conn != null) try { conn.close(); } catch(Exception e) { e.printStackTrace();}
		}
		return infoList;
	}
	
	// 글 고유번호받아 해당 글 한개 가져오는 메서드
	public InfoDTO getinfo(int info_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		InfoDTO info = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select * from information where info_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, info_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				info = new InfoDTO();
				info.setInfo_num(info_num);
				info.setInfo_title(rs.getString("info_title"));
				info.setInfo_content(rs.getString("info_content"));
				info.setInfo_reg(rs.getTimestamp("info_reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!= null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!= null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!= null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return info;
	}
	
	// 게시글 수정 처리
	public void updateInfo(InfoDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update information set info_title=?, info_content=? where info_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getInfo_title());
			pstmt.setString(2, dto.getInfo_content());
			pstmt.setInt(3, dto.getInfo_num());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 공지사항 삭제
	public void deleteInfo(int info_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
		try {
			conn = getConnection();
			String sql = "delete from information where info_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, info_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
}
