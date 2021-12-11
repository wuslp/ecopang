package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReportsDAO {
	
	// 커넥션 메서드
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	// 신고하기 메서드
	public void insertReport(ReportsDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into reports(rep_num, category, num, userID, reporterID, rep_reg, rep_reason, rep_content) "
					+ "values(rep_num_seq.NEXTVAL,?,?,?,?,sysdate,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getCategory());
			pstmt.setInt(2, dto.getNum());
			pstmt.setString(3, dto.getUserID());
			pstmt.setString(4, dto.getReporterID());
			/* pstmt.setTimestamp(5, dto.getRep_reg()); */
			pstmt.setString(5, dto.getRep_reason());
			pstmt.setString(6, dto.getRep_content());
			pstmt.executeUpdate();
			
			// 유저테이블 신고당한횟수+1
			sql = "update users set reportCount=reportCount+1 where userID=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserID());
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	
}
