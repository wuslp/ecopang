package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ChatDAO {
	
	private Connection getConnection() throws Exception{
		Context ctx=new InitialContext();
		Context env=(Context)ctx.lookup("java:comp/env");
		DataSource ds=(DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	// 활동 번호가 act_num 이고 주어진 날짜 사이에 없는 채팅 기록을 검색 후 List에 담아 리턴
	public ArrayList<ChatDTO> getChatListByNum(int act_num, String last) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		ArrayList<ChatDTO> chatList = null;
		String last2 = last.substring(0,19);
		
		try {
			conn=getConnection();
			String sql="select * from chat " + 
					"where act_num = ? and (chat_reg not between to_date('1990-01-01 01:01:01','YYYY-MM-DD HH24:MI:SS') and to_date(?,'YYYY-MM-DD HH24:MI:SS')) order by chat_reg";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, act_num);
			pstmt.setString(2, last2);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				chatList = new ArrayList<ChatDTO>();
				do {
					ChatDTO dto = new ChatDTO();
					dto.setAct_num(act_num);
					dto.setFromID(rs.getString("fromID").replace(" ", "&nbsp;").replace("<", "&lt;").replace(">", "&gt;").replace("\n", "<br/>"));
					dto.setChat_content(rs.getString("chat_content").replace(" ", "&nbsp;").replace("<", "&lt;").replace(">", "&gt;").replace("\n", "<br/>"));
					dto.setChat_reg(rs.getTimestamp("chat_reg"));
					chatList.add(dto);
				} while(rs.next());
			}

		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs !=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt !=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn !=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return chatList;
	}
	
	// 사용자가 입력한 채팅 내용을 데이터베이스에 저장
	public int submit(int act_num, String fromID, String chat_content) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		int result = -1;
		try {
			conn=getConnection();
			String sql="insert into chat values(?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, act_num);
			pstmt.setString(2, fromID);
			pstmt.setString(3, chat_content);
			
			result = pstmt.executeUpdate();

		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs !=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt !=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn !=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return result;
	}
}
