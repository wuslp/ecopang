package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UploadDAO {
	private Connection getConnection() throws Exception{
		Context ctx=new InitialContext();
		Context env=(Context)ctx.lookup("java:comp/env");
		DataSource ds=(DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	// 업로드 파일 정보 저장
	public void uploadImg(String img) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		
		try {
			conn=getConnection();
			String sql="insert into groups values(?,?)";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, img);
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
		}
	}	
		
		// 이미지 가져오기 
		public List getImg(String userID) {
			Connection conn=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			List imgs=null;
			
			try {
				conn=getConnection();
				String sql="select img from groups where userID=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				
				rs=pstmt.executeQuery();
				if(rs.next()) {
					imgs=new ArrayList();
					do {
						// 컬럼명으로 결과에서 데이터 꺼내기
						imgs.add(rs.getString("img"));
					}while(rs.next());
					
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			}
			return imgs;
		}
	
	
	
	
	
}
