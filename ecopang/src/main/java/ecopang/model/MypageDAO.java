package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MypageDAO {

	// 커넥션 메서드
		private Connection getConnection() throws Exception{
			Context ctx = new InitialContext();
			Context env = (Context)ctx.lookup("java:comp/env");
			DataSource ds = (DataSource)env.lookup("jdbc/orcl");
			return ds.getConnection();
		}
			
//참여중인 활동 카운트
		public int myActCount(String userID) {
			int count = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "select count(*) from (select C.*, rownum r from (select B.* from activityjoin A, activities B " + 
						"where (A.act_num = B.act_num) and A.userID like ? order by act_date desc)C " + 
						"where to_date(C.act_date,'YYYY-mm-dd') >= (sysdate-1))";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);//총 글의 개수를 담는다는것
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count;
		}	
		

//참여중인 활동 목록
		public List myAct(String userID, int startRow, int endRow) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			List list = null;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select * from (select C.*, rownum r from " + 
						"(select B.* from activityjoin A, activities B " + 
						"where (A.act_num = B.act_num) and A.userID like ? order by act_date desc)C " + 
						"where to_date(C.act_date,'YYYY-mm-dd') >= (sysdate-1)) where r >= ? and r <= ? ";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, endRow);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					
					list = new ArrayList();//list 객체생성해줌
					do {//확인용 rs.next()로 한칸 이미 내려간 상태 
						//	->바로 do~while문 사용
						ActDTO activity = new ActDTO(); //activites 에 얻은 값 셋팅 해주기
						//컬럼 9개 ㅅ세팅 
						activity.setAct_num(rs.getInt("act_num"));
						activity.setGroup_num(rs.getInt("group_num"));
						activity.setAct_title(rs.getString("act_title"));
						activity.setPlace(rs.getString("place"));
						activity.setAct_date(rs.getString("act_date"));
						activity.setAct_time(rs.getString("act_time"));
						activity.setMax_user(rs.getInt("max_user"));
						activity.setUser_nickname(rs.getString("user_nickname"));
						activity.setUserID(rs.getString("userID"));
						
						System.out.println("3번 소모임 활동 제목 확인용 출력 : " + rs.getString("act_title"));//확인용
						list.add(activity);//리턴 해줄 데이터
						
					}while(rs.next());
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return list;// 리턴 void -> List로 수정
		}		
			
//완료된 활동 카운트
		public int myEndActCount(String userID) {
			int count = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "select count(*) from (select C.*, rownum r from (select B.* from activityjoin A, activities B " + 
						"where (A.act_num = B.act_num) and A.userID like ? order by act_date desc)C " + 
						"where to_date(C.act_date,'YYYY-mm-dd') < (sysdate-1))";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);//총 글의 개수를 담는다는것
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count;
		}	
		
//완료된 활동 목록
		public List myEndAct(String userID, int start, int end) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			List endlist = null;
			ResultSet rs = null;
			
			try {//1~3개 까지
				conn = getConnection();
				String sql= "select * from (select C.*, rownum r from " +  
							"(select B.* from activityjoin A, activities B " +
							"where (A.act_num = B.act_num) and A.userID like ? order by act_date desc)C " +
							"where to_date(C.act_date,'YYYY-mm-dd') < (sysdate-1)) where r >= ? and r <= ?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setInt(2, start);//rownum정렬 1부터
				pstmt.setInt(3, end);//
			
				rs = pstmt.executeQuery();
				if(rs.next()) {
					//한칸 이미 내려간 상태 
					//	->바로 do~while문 사용
					endlist = new ArrayList();
					do {
						ActDTO activity = new ActDTO();
						//컬럼 9개 셋팅 해주기
						activity.setAct_num(rs.getInt("act_num"));
						activity.setGroup_num(rs.getInt("group_num"));
						activity.setAct_title(rs.getString("act_title"));
						activity.setPlace(rs.getString("place"));
						activity.setAct_date(rs.getString("act_date"));
						activity.setAct_time(rs.getString("act_time"));
						activity.setMax_user(rs.getInt("max_user"));
						activity.setUser_nickname(rs.getString("user_nickname"));
						activity.setUserID(rs.getString("userID"));
						
						endlist.add(activity);//리턴
						
					}while(rs.next());
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return endlist;
		}

		
	
//좋아요 누른 게시물 카운트
		public int myLikeContentCount(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			int count = 0;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select count(*) from (select l.*, rownum r from (select d1.cate cate, t1.tpc_num num, t1.tpc_title title, t1.tpc_content content, t1.tpc_reg reg from (select t.* from topics t, topiclikes tl where t.tpc_num = tl.tpc_num and tl.userid = ? )t1,(select 'topic'cate from dual)d1 union " + 
						"select d2.cate cate, g1.group_num num, g1.group_title title, g1.group_content content, g1.group_reg reg from (select g.* from groups g, grouplikes gl where g.group_num = gl.group_num and gl.userid = ? )g1, (select 'group' cate from dual)d2 union " + 
						"select d3.cate cate, r2.rev_num num, r2.group_title title, r2.rev_content content, r2.rev_reg reg from(select r1.rev_num, g2.group_title, r1.rev_content, r1.rev_reg from (select r.* from reviews r, reviewlikes rl where r.rev_num = rl.rev_num and rl.userid = ?)r1, (select group_num, group_title from groups)g2 where r1.group_num = g2.group_num)r2, (select 'review' cate from dual)d3)l)";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userID);
				pstmt.setString(3, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return count;// 리턴 void -> List로 수정
		}
//좋아요 누른 게시물 목록
		public List myLikeContent(String userID, int startRow, int endRow) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			List list = null;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select * from (select l.*, rownum r from (select d1.cate cate, t1.tpc_num num, t1.tpc_title title, t1.tpc_content content, t1.tpc_reg reg from (select t.* from topics t, topiclikes tl where t.tpc_num = tl.tpc_num and tl.userid = ?)t1,(select '게시글'cate from dual)d1 union " + 
						"select d2.cate cate, g1.group_num num, g1.group_title title, g1.group_content content, g1.group_reg reg from (select g.* from groups g, grouplikes gl where g.group_num = gl.group_num and gl.userid = ?)g1, (select '소모임' cate from dual)d2 union "+
						"select d3.cate cate, r2.group_num num, r2.group_title title, r2.rev_content content, r2.rev_reg reg from(select g2.group_num, g2.group_title, r1.rev_content, r1.rev_reg from (select r.* from reviews r, reviewlikes rl where r.rev_num = rl.rev_num and rl.userid = ?)r1, (select group_num, group_title from groups)g2 where r1.group_num = g2.group_num)r2, (select '후기' cate from dual)d3)l) where r >= ? and r <= ?";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userID);
				pstmt.setString(3, userID);
				pstmt.setInt(4, startRow);
				pstmt.setInt(5, endRow);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					
					list = new ArrayList();//list 객체생성해줌
					do {//확인용 rs.next()로 한칸 이미 내려간 상태 
						//	->바로 do~while문 사용
						String[] str = new String[5];
						str[0] = rs.getString("cate");
						str[1] = rs.getString("num");
						str[2] = rs.getString("title");
						str[3] = rs.getString("content");
						str[4] = rs.getString("reg");
						
						list.add(str);//리턴 해줄 데이터
						
					}while(rs.next());
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return list;// 리턴 void -> List로 수정
		}
		
		
//내가 작성한 글 카운트
		public int myContentCount(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			int count = 0;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select count(*) from(select l.*, rownum r from(select d.cate cate, t.tpc_num num, t.tpc_title title, t.tpc_content content, t.tpc_reg reg " + 
						"from(select * from topics where userid = ?)t,(select '게시글'cate from dual)d " + 
						"union " + 
						"select d.cate cate, r2.group_num num, r2.group_title title, r2.rev_content content, r2.rev_reg reg " + 
						"from (select r.group_num, g.group_title, r.rev_content, r.rev_reg from (select * from reviews where userId = ?)r, groups g where r.group_num = g.group_num)r2,(select '후기'cate from dual)d " + 
						"union " + 
						"select d.cate cate, g.group_num num, g.group_title title, g.group_content content, g.group_reg reg " + 
						"from (select * from groups where userid = ?)g, (select '소모임'cate from dual)d)l)";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userID);
				pstmt.setString(3, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return count;// 리턴 void -> List로 수정
		}
		
//내가 작성한 글 목록
		public List myContents(String userID, int startRow, int endRow) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			List list = null;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select * from(select l.*, rownum r from(select d.cate cate, t.tpc_num num, t.tpc_title title, t.tpc_content content, t.tpc_reg reg " + 
						"from(select * from topics where userid = ?)t,(select '게시글'cate from dual)d " + 
						"union " + 
						"select d.cate cate, r2.group_num num, r2.group_title title, r2.rev_content content, r2.rev_reg reg " + 
						"from (select r.group_num, g.group_title, r.rev_content, r.rev_reg from (select * from reviews where userId = ?)r, groups g where r.group_num = g.group_num)r2,(select '후기'cate from dual)d " + 
						"union " + 
						"select d.cate cate, g.group_num num, g.group_title title, g.group_content content, g.group_reg reg " + 
						"from (select * from groups where userid = ?)g, (select '소모임'cate from dual)d)l) where r >= ? and r <= ?";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userID);
				pstmt.setString(3, userID);
				pstmt.setInt(4, startRow);
				pstmt.setInt(5, endRow);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					
					list = new ArrayList();//list 객체생성해줌
					do {//확인용 rs.next()로 한칸 이미 내려간 상태 
						//	->바로 do~while문 사용
						String[] str = new String[5];
						str[0] = rs.getString("cate");
						str[1] = rs.getString("num");
						str[2] = rs.getString("title");
						str[3] = rs.getString("content");
						str[4] = rs.getString("reg");
						
						list.add(str);//리턴 해줄 데이터
						
					}while(rs.next());
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return list;// 리턴 void -> List로 수정
		}
				
			
//내가 작성한 댓글 카운트
		public int myCommentCount(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			int count = 0;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select count(*) from(select l.*, rownum r from(select cate, eve_num num, eve_title title,eve_comment content, eve_reg reg " + 
						"from(select * from (select e.eve_num, e.eve_title, ec.eve_comment, ec.eve_reg " + 
						"from eventComments ec, eventlist e where ec.userId = ? and e.eve_num = ec.eve_num),(select '이벤트'cate from dual)d) " + 
						"union " + 
						"select cate, tpc_num num, tpc_title title,tpc_com_content content, tpc_com_reg reg " + 
						"from(select * from (select t.tpc_num, t.tpc_title, tc.tpc_com_content, tc.tpc_com_reg " + 
						"from topicComments tc, topics t where tc.userId = ? and t.tpc_num = tc.tpc_num),(select '게시글'cate from dual)d))l)";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return count;// 리턴 void -> List로 수정
		}
		
	//내가 작성한 댓글목록
	public List myCommentList(String userID, int startRow, int endRow) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
		List list = null;//담을 리스트 변수 필요
		
		
		try {
			String sql = "select * from(select l.*, rownum r from(select cate, eve_num num, eve_title title,eve_comment content, eve_reg reg " + 
					"from(select * from (select e.eve_num, e.eve_title, ec.eve_comment, ec.eve_reg " + 
					"from eventComments ec, eventlist e where ec.userId = ? and e.eve_num = ec.eve_num),(select '이벤트'cate from dual)d) " + 
					"union " + 
					"select cate, tpc_num num, tpc_title title,tpc_com_content content, tpc_com_reg reg " + 
					"from(select * from (select t.tpc_num, t.tpc_title, tc.tpc_com_content, tc.tpc_com_reg " + 
					"from topicComments tc, topics t where tc.userId = ? and t.tpc_num = tc.tpc_num),(select '게시글'cate from dual)d))l) where r >= ? and r <= ?";
			conn = getConnection();
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, userID);
			pstmt.setInt(3, startRow);
			pstmt.setInt(4, endRow);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				list = new ArrayList();//list 객체생성해줌
				do {//확인용 rs.next()로 한칸 이미 내려간 상태 
					//	->바로 do~while문 사용
					String[] str = new String[5];
					str[0] = rs.getString("cate");
					str[1] = rs.getString("num");
					str[2] = rs.getString("title");
					str[3] = rs.getString("content");
					str[4] = rs.getString("reg");
					
					list.add(str);//리턴 해줄 데이터
					
				}while(rs.next());
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return list;// 리턴 void -> List로 수정
	}
}
