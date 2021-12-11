package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class UsersDAO {
	
	// 커넥션 메서드
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	//---------------------------------------------------------주홍님
	// 회원가입 메서드
	public void insertUser(UsersDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into users(userID, pw, name, nickname, user_img, birth, user_city1, user_district1, user_city2, user_district2, user_city3, user_district3) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserID());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getNickname());
			pstmt.setString(5, dto.getUser_img());
			pstmt.setString(6, dto.getBirth());
			pstmt.setString(7, dto.getUser_city1());
			pstmt.setString(8, dto.getUser_district1());
			pstmt.setString(9, dto.getUser_city2());
			pstmt.setString(10, dto.getUser_district2());
			pstmt.setString(11, dto.getUser_city3());
			pstmt.setString(12, dto.getUser_district3());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 아이디 중복 여부 확인 메서드
		public boolean confirmUserID(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean result = false;
			try {
				conn = getConnection();
				String sql = "select userID from users where userID = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) { e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) { e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) { e.printStackTrace();}
			}
			return result;
		}
		// 별명 중복 여부 확인 메서드
		public boolean confirmNickname(String nickname) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean result = false;
			try {
				conn = getConnection();
				String sql = "select nickname from users where nickname = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nickname);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) { e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) { e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) { e.printStackTrace();}
			}
			return result;
		}
		
		// 로그인 메서드 : id, pw 일치 확인
		public boolean idPwCheck(String userID, String pw) {
			boolean result = false;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select * from users where userID=? and pw=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, pw);
				rs = pstmt.executeQuery();
		         if(rs.next()) {
		            result = true;
		         }
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) { e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) { e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) { e.printStackTrace();}
			}
			return result;
		}
		
		// 활동 상태에 따른 로그인여부 : 활동(로그인가능), 탈퇴/강퇴(로그인불가능)
		// ==> user_state 꺼내오기!!
		public String getUser_state(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String user_state = null;
			try {
				conn=getConnection();
				String sql ="select user_state from users where userID = ? ";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					user_state = rs.getString("user_state");
				}
			} catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return user_state;
		}
		
		
		// id에 맞는 user_img 가져오는 메서드
		public String getUser_img(String memId) {
			String photo = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select user_img from users where userID=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, memId);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					photo = rs.getString("user_img");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return photo;
		}
		
		// 회원정보 수정 메서드
		public int updateUser(UsersDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int result = 0;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select pw from users where userID=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getUserID());
				rs=pstmt.executeQuery();
				if(rs.next()) {
					String dbpw = rs.getString("pw");
					if(dbpw.equals(dto.getPw())) {
						sql = "update users set nickname=?, user_img=?, birth=?, user_city1=?, user_district1=?, user_city2=?, user_district2=?, user_city3=?, user_district3=? where userID=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, dto.getNickname());
						pstmt.setString(2, dto.getUser_img());
						pstmt.setString(3, dto.getBirth());
						pstmt.setString(4, dto.getUser_city1());
						pstmt.setString(5, dto.getUser_district1());
						pstmt.setString(6, dto.getUser_city2());
						pstmt.setString(7, dto.getUser_district2());
						pstmt.setString(8, dto.getUser_city3());
						pstmt.setString(9, dto.getUser_district3());
						pstmt.setString(10, dto.getUserID());
						
						result = pstmt.executeUpdate();
						
						sql = "update topicComments set nickname=? where userID=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, dto.getNickname());	
						pstmt.setString(2, dto.getUserID());
						pstmt.executeUpdate();
						
						sql = "update activities set user_nickname=? where userID=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, dto.getNickname());	
						pstmt.setString(2, dto.getUserID());
						pstmt.executeUpdate();
						
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return result;
		}
		
		// 비밀번호 변경 메서드
		public int pwChange(String userID, String pw, String newPw) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int res = 0;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select pw from users where userID=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					String dbpw = rs.getString("pw");
					if(dbpw.equals(pw)) {
						sql = "update users set pw=? where userID=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, newPw);
						pstmt.setString(2, userID);
						res = pstmt.executeUpdate();
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return res;
		}
		
		// 회원탈퇴 : 탈퇴사유, 불만사항기입, 활동상태 변경 메서드
		public int deleteUser(String userID, String del_reason, String complaints, String pwch) {
			int res= 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn=getConnection();
				String sql = "select pw from users where userID=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					String dbpw = rs.getString("pw");
					if(dbpw.equals(pwch)) {
						sql="update users set del_reason=?, complaints=?, user_state='탈퇴' where userID=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, del_reason);
						pstmt.setString(2, complaints);
						pstmt.setString(3, userID);
						res = pstmt.executeUpdate();
						
						sql = "insert into reports (rep_seq.nextVal, '자진탈퇴', 0, ?,?,?,  );";
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return res;
		}


		// 관리자용 유저 전체 수 가져오기
		public int getUsersCount(String sel, String search) {
			int count = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select count(*) from users where " + sel + " like '%" + search + "%'" ;
				// select count(*) from board where writer like '%abc%';
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					// count(*) 은 결과를 숫자로 가져오며, 컬럼명 대신 컬럼번호로 꺼내기.
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
		
		
		
		
		//-------------------------------------
		//669완료활동 가져오기 r
		
		//세션 에서 얻은 id로 값 가져오기
		public UsersDTO getUser(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			UsersDTO userid =null;
			
			try{
				conn=getConnection();
				String sql ="select * from users where userID = ? ";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);//세션에서 얻은 id 값
				rs = pstmt.executeQuery();//모든정보 select 가져오기
				System.out.println("9번 rs 출력 : " + rs);
				//--------------------------------------------------------------------------------------------------
				if(rs.next()) {
					userid = new UsersDTO(); //DTO에 담기
					//18개
					//모든컬럼 셋팅해주기
					userid.setUserID(rs.getString("userID"));
					userid.setPw(rs.getString("pw"));
					userid.setName(rs.getString("name"));
					userid.setNickname(rs.getString("nickname"));
					userid.setUser_img(rs.getString("user_img"));
					userid.setBirth(rs.getString("birth"));
					userid.setUser_city1(rs.getString("user_city1"));
					userid.setUser_district1(rs.getString("user_district1"));
					userid.setUser_city2(rs.getString("user_city2"));
					userid.setUser_district2(rs.getString("user_district2"));
					userid.setUser_city3(rs.getString("user_city3"));
					userid.setUser_district3(rs.getString("user_district3"));
					userid.setUser_level(rs.getInt("user_level"));
					userid.setReportCount(rs.getInt("reportCount"));
					userid.setWarning(rs.getInt("warning"));
					userid.setDel_reason(rs.getString("del_reason"));
					userid.setComplaints(rs.getString("complaints"));
					userid.setUser_state(rs.getString("user_state"));
					
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return userid;//리턴해주기
		}
		
		
		
		//로그인된 id로 활동 참가 내용들 가져오기
		//		-> 세션에서 로그인 id ,userID 가져옴
		//			->Activityjoin 에서 userID에 해당하는 act_num가져오기
		//				->act_num 으로 activities에서 act_num에 해당하는 활동 뿌려주기
		public List getAct(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;//sql문 실행 결과를 받아올 ResultSet타입의 rs변수 미리선언
			List list = null;//담을 리스트 변수 필요
			
			
			try {
				String sql = "select B.* from activityjoin A, activities B where (A.act_num = B.act_num) and A.userID=?";
				conn = getConnection();
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
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
		
		
		//로그인된 id로 참가한 활동 중 몇명이 참여 중인지 count
		//	-> 로그인된 id로 참가한 활동 고유번호 XXX
		//	-> 해당 활동의 고유번호를 바로 매개변수로 넣어줘서 해당 활동 참여중인 모든 nicknamecount
		
		public int getActCount(int act_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int actCount = 0;
			
			 try {
				 conn =getConnection();
				 String sql ="select count(*) from activities where act_num = ? ";
				 pstmt = conn.prepareStatement(sql);
				 pstmt.setInt(1, act_num);
				 rs=pstmt.executeQuery();
				 
				 if(rs.next()) {
					 actCount = rs.getInt(1);//값 저장시키기
				 }
				 
				 
			 }catch(Exception e){
				 e.printStackTrace();
			 }finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			 }
			return actCount;
		}
		
		
			//로그인 된 id로 내 후기글 가져오기
			//		->작성후기 개수 가져오기
			//
			public int getRevCount(String userID) {
				int count3 = 0;
				Connection conn = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				
				try {
					conn= getConnection();
					String sql = "SELECT count(*) FROM reviews WHERE userID=? ";
					pstmt= conn.prepareStatement(sql);
					pstmt.setString(1, userID);
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						count3 = rs.getInt(1);//개수
					}
					
				}catch(Exception e ) {
					e.printStackTrace();
				}finally {
					if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
					if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
					if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
				}
				return count3;
			}	
		
		
		
		//로그인 된 id로 내 후기 작성글 불러오기
		 //		->세션에서 userID 
		 //			-> 사용할 테이블 - 후기 테이블 reviews 
		 //				-> userID reviews에 존재
		  //				-> DTO에 셋팅, 불러오기
		 
		public List getRevlist(String userID,int startRow4, int endRow4) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs =null;
			List revlist = null; //List껍데기 만듬
	
			try {
				conn=getConnection();
				String sql="select * from (select A.* ,rownum r from (select * from reviews where userID= ?)A) "
							+"where r >=? and r <=?";
				//userID가 지금 접속중인 아이디 정보와 같은글만 가져오기
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);//세션 아이디 userID
				pstmt.setInt(2, startRow4);
				pstmt.setInt(3, endRow4);
				rs = pstmt.executeQuery();
				
				revlist = new ArrayList();//배열 객체 생성
				
				if(rs.next()) {
						ReviewDTO revdto = new ReviewDTO();
					do {//바로 do~while 문 돌리기
						revdto.setRev_num(rs.getInt("rev_num"));//컬럼 6개 셋팅 해주기
						revdto.setGroup_num(rs.getInt("group_num"));
						revdto.setUserID(rs.getString("userID"));
						revdto.setRev_content(rs.getString("rev_content"));
						revdto.setRev_img(rs.getString("rev_img"));
						revdto.setRev_reg(rs.getTimestamp("rev_reg"));
						revdto.setLikesCount(rs.getInt("likesCount"));
						System.out.println("5번 리뷰 내용 확인용 출력 : " + rs.getString("rev_content"));//확인용
						revlist.add(revdto);//리턴용 추가
						
					}while(rs.next());
				}
				
				
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return revlist;//리턴
		}
		
		
		/*
				
				// 1.그 댓글단 댓글의 원글 불러오기 
				//			-> userID 가 단 댓글(topicComments) 의 게시글 고유번호 (tpc_num)
				//				-> 게시글 고유번호 (tpc_num) 를 이용하여
				//					-> 게시판 테이블(topics) 과 조인 (join) 
				//						-> where 조건 2가지와 일치하는 데이터 select *
				//							->where A.tpc_num = B.tpc_num and B.userID = ?  
				//								->userID는 로그인된아이디 이어야하고 게시글 고유번호 일치하는 원글 가져오기 
				public List getComTopic(String userID) {
					Connection conn = null;
					PreparedStatement pstmt= null;
					ResultSet rs = null;
					List comTopic = null;//값받아서 리턴할 List 선언.
					
					try {
						conn=getConnection();
						// select A.* from topics A, topicComments B ->topics 테이블 데이터 모두가져오기
						// where A.tpc_num = B.tpc_num and B.userID = ? ->조인조건 게시글 고유번호 같고 userID 로그인중인아이디
						String sql = "select A.* from topics A, topicComments B where A.tpc_num = B.tpc_num and B.userID = ? ";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, userID);
						rs = pstmt.executeQuery();
						
							comTopic = new ArrayList(); //배열 리스트 객체 생성
						if(rs.next()){
							TopicDTO comTopicdto = new TopicDTO();//게시판 DTO 에 담아줄 객체생성
							do {
								//
								comTopicdto.setTpc_num(rs.getInt("tpc_num"));
								comTopicdto.setCategory(rs.getInt("category"));
								comTopicdto.setUserID(rs.getString("userID"));
								comTopicdto.setTpc_title(rs.getString("tpc_title"));
								comTopicdto.setTpc_content(rs.getString("tpc_content"));
								comTopicdto.setTpc_imgs(rs.getString("tpc_imgs"));
								comTopicdto.setTpc_hit(rs.getString("tpc_hit"));
								comTopicdto.setTpc_reg(rs.getTimestamp("tpc_reg"));
								
								comTopic.add(comTopicdto);
								
								System.out.println("10번 타이틀 확인용 : "+ rs.getString("tpc_title"));
							}while(rs.next());
							
						}
						
						
					}catch(Exception e) {
						e.printStackTrace();
					}finally{
						if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
						if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
					return comTopic;
				}
							
	*/			
	/*			
				//1-2. 댓글단 원글 불러오기-생각중....................
				//		->입력한 id로 topic까지 불러오려했으나
				//			->mypage 에서 게시글-댓글 반복문 ...
				//				->topic에서 tpc_num으로 해당 게시글 전체 불러와서 저장 .제목만필요.
				//					=>매개변수로 tpc_num 으로
				public String getComTopic(int tpc_num) {
					Connection conn = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					String topTitle = null;
					try {
						conn=getConnection();
						String sql="select tpc_title from topics where tpc_num = ?";
						pstmt=conn.prepareStatement(sql);
						pstmt.setInt(1, tpc_num);
						rs=pstmt.executeQuery();
						
						
						if(rs.next()) {
							topTitle = rs.getString("tpc_title");
								System.out.println("10번 타이틀 확인용 : "+ rs.getString("tpc_title"));
						}
						
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
						if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
					return topTitle;
				}
*/				
				
		//로그인 된 id로 내 좋아요한글 개수 가져오기
		//
		public int getGlikeCount(String userID) {
			int count5 = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "SELECT count(*) FROM grouplikes WHERE userID=? ";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count5 = rs.getInt(1);//개수
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count5;
		}	
	
			
		//로그인 된 id가 좋아요 한 소모임 불러오기
		//->groupLikes 소모임 좋아요 테이블 
		//		->userID 로 그룹 고유번호 얻어올 수있음
		//			->소모임 목록 groups 에서 고유번호로 꺼내오기
		//				-> 공통 컬럼 그룹 고유번호 group_num
		//					->where group_num = group_num , userID =로그인중인 아이디
		public List getGroupLikes(String userID, int startRow5, int endRow5) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List likelist = null;
			
			try {
				conn=getConnection();
				//where 조건문
				String sql="select *, r from (select A.*,rownum r from groups A, groupLikes B "
							+"where (A.group_num = B.group_num) and B.userID =?) "
							+"r>=? and r<=?";//ORA-00923: FROM 키워드가 필요한 위치에 없습니다.
				sql="select C.*, r from (select A.*, rownum r from groups A, grouplikes B where (A.group_num = B.group_num) and B.userID =?)C where r >=? and r< =?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1,userID);
				pstmt.setInt(2, startRow5);
				pstmt.setInt(3, endRow5);
				
				rs=pstmt.executeQuery();
				
					likelist = new ArrayList();
				if(rs.next()) {
					do {
						GroupDTO groupsdto = new GroupDTO();
						groupsdto.setGroup_num(rs.getInt("group_num"));
						groupsdto.setUserID(rs.getString("userID"));
						groupsdto.setGroup_title(rs.getString("group_title"));
						groupsdto.setCity(rs.getString("city"));
						groupsdto.setLocation(rs.getString("location"));
						groupsdto.setGroup_content(rs.getString("group_content"));
						groupsdto.setGroup_img(rs.getString("group_img"));
						groupsdto.setGroup_reg(rs.getTimestamp("group_reg"));
						
						likelist.add(groupsdto);
						
					}while(rs.next());
				}

			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return likelist;
			
		}
	
//-----------------			
				
		//+완료활동 글 가져오기
		//게시글 전체 가져오는 메서드
		public int getActCount(String userID) {
			int count = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "SELECT count(*) FROM activities A, users B WHERE A.user_nickname = B.nickname and B.userID=? ";
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
		
		
		//+수정
		//로그인된 id로 활동 완료된 내용들 가져오기
		//			->조건 필요 , 완료된 것 
		//				->날짜로 판단 가능 .
		
		public List getActend(String userID, int start, int end) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			List endlist = null;
			ResultSet rs = null;
			
			try {//1~3개 까지
				conn = getConnection();
				String sql="select B.*, r from (SELECT A.*, rownum r FROM activities A, users B "
							+"WHERE (A.user_nickname = B.nickname and B.userID=?) "
							+"and A.act_date < sysdate)B where r >= ? and r <= ?";//test
				
				sql="select D.*, r from (select C.* , rownum r from (select B.* from activityjoin A, activities B where (A.act_num = B.act_num) and A.userID=? and B.act_date < sysdate)C)D where r>=? and r<=?";
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

				
		//로그인 된 id 로 작성한 작성글 게시판 topic 개수 불러오기
		
		public int getTopCount(String userID) {
			int count2 = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "SELECT count(*) FROM topics WHERE userID=? ";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count2 = rs.getInt(1);//총 글의 개수를 담는다는것
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count2;
		}	
		
				
		//***다시 보기 
		//로그인 된 id 로 적음 커뮤니티 글 갯수만큼 가져오기
		//로그중인 내 id 로 커뮤니티에쓴 게시글 불러오기
		//	->커뮤니티 게시판 (topics) 에서 게시글 가져와야함
		//		->topics 테이블에서 우리가 아는 userID 로 가져올 수있음
		//			->게시글 하나가 아닐 수 있음
		 //				->List로 가져오기
		public List getTop(String userID, int start2, int end2) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs =null;
			List toplist = null; //List 변수 생성
			System.out.println(start2 + " " + end2);
			
			try {
				conn=getConnection();
				String sql = "select * from (select A.* ,rownum r from "
						+"(select * from topics where userID= ?)A) "
						+"where r >=? and r <=?";//userID가 지금 접속중인 아이디 정보와 같은글만 가져오기
				//rownum r선언과 동시에 r조건문 적용시 오류
				//rownum r 선언후
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setInt(2, start2);
				pstmt.setInt(3, end2);
				rs = pstmt.executeQuery();
				
				TopicDTO topdto = null; //- 위치 확인 !!!!!!!!
				toplist = new ArrayList();//생성한 변수 객체 생성 ->담을것 - 위치 확인!!!!!!!!
				
				if(rs.next()) {
					do {
						topdto = new TopicDTO(); //담는것 - 위치 확인 !!!!!!!!
						//topic DTO에 셋팅해주기위해 객체 생성.do안에 반복해야 topdto 에 각기 다른 주소 셋팅
						//start2 부터 end2 까지 반복
						//컬럼 7개 값 셋팅
						topdto.setTpc_num(rs.getInt("tpc_num"));
						topdto.setCategory(rs.getString("category"));
						topdto.setUserID(rs.getString("userID"));
						topdto.setTpc_title(rs.getString("tpc_title"));
						topdto.setTpc_content(rs.getString("tpc_content"));
						topdto.setTpc_hit(rs.getInt("tpc_hit"));
						topdto.setTpc_reg(rs.getTimestamp("tpc_reg"));
						
						System.out.println("20번 게시글 내용 확인용 출력 :" + rs.getString("tpc_title"));//확인용
						toplist.add(topdto);// 값 한번 반복후 list 에 추가 .do 만큼 반복해서 값은 그 만큼 셋팅됨
						
					}while(rs.next());
				}
				
				
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return toplist;
		} 
		
		
		//작성댓글 불러오기
		//	->작성댓글 개수 가져오기
		//
		public int getComCount(String userID) {
			int count3 = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "SELECT count(*) FROM topicComments WHERE userID=? ";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count3 = rs.getInt(1);//갯수
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count3;
		}	
		
		
		//코멘트 불러오기
		public List getComm(String userID, int start3, int end3) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs =null;
			List comlist = null; //List 변수 생성
			
			try {
				conn=getConnection();
				String sql="select A.* ,rownum r from (select * from topics where userID=? )A where rownum >=? and rownum <=?";//test
				sql = "select * from (select A.* ,rownum r from (select * from topicComments where userID= ?)A) "
						+"where r >=? and r <=?";//userID가 지금 접속중인 아이디 정보와 같은글만 가져오기

				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setInt(2, start3);
				pstmt.setInt(3, end3);
				rs = pstmt.executeQuery();
				
				TopicCommentDTO topdto = null; //- 위치 확인 !!!!!!!!
				comlist = new ArrayList();//생성한 변수 객체 생성 ->담을것 - 위치 확인!!!!!!!!
				
				if(rs.next()) {
					do {
						topdto = new TopicCommentDTO(); //담는것 - 위치 확인 !!!!!!!!

						topdto.setTpc_com_num(rs.getInt("tpc_com_num"));
						topdto.setTpc_num(rs.getInt("tpc_num"));
						topdto.setUserID(rs.getString("userID"));
						topdto.setNickname(rs.getString("nickname"));
						topdto.setTpc_com_content(rs.getString("tpc_com_content"));
						topdto.setTpc_com_reg(rs.getTimestamp("tpc_com_reg"));
						
						System.out.println("27번 게시글 내용 확인용 출력 :" + rs.getString("tpc_com_content"));//확인용
						comlist.add(topdto);// 값 한번 반복후 list 에 추가 .do 만큼 반복해서 값은 그 만큼 셋팅됨
						
					}while(rs.next());
				}
				
				
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return comlist;
		} 
		
		//
		//댓글단 원글 불러오기-생각중....................
		//		->입력한 id로 topic까지 불러오려했으나
		//			->mypage 에서 게시글-댓글 반복문 ...
		//				->topic에서 tpc_num으로 해당 게시글 전체 불러와서 저장 .제목.
		//					=>매개변수로 tpc_num 으로
		public String getComTopic(int tpc_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String topTitle = null;
			try {
				conn=getConnection();
				String sql="select tpc_title from topics where tpc_num = ?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, tpc_num);
				rs=pstmt.executeQuery();
				
				
				if(rs.next()) {
					topTitle = rs.getString("tpc_title");
						System.out.println("10번 타이틀 확인용 : "+ rs.getString("tpc_title"));
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return topTitle;
		}
		
		
		//내가 쓴 후기의 소모임 제목 가져오기
		public String getReTitle(int group_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String reTitle = null;
			
			try {
				conn=getConnection();
				String sql="select group_title from groups where group_num = ?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				rs=pstmt.executeQuery();
				
				
				if(rs.next()) {
					reTitle = rs.getString("group_title");
						System.out.println("17번 group타이틀 확인용 : "+ rs.getString("group_title"));
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}			
			return reTitle;
		}
		
		
		//-------------관리자 페이지 작성 추가
		//전체 유저수
		public int getAdminCount() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn=getConnection();
				String sql="select count(*) from users";
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
				
				if(rs.next()) {
					count = rs.getInt(1);
						System.out.println("60번 관리자 회원수 확인용 : "+ rs.getInt(1));
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}			
			
			return count;
		}
		
		//전체 회원정보	리스트로 가져오기
		public List getUserinfo(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			UsersDTO userinfo= null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select users.*, rownum r from users)A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						userinfo = new UsersDTO(); //DTO 생성
						//18개
						//모든컬럼 셋팅해주기
						userinfo.setUserID(rs.getString("userID"));
						userinfo.setPw(rs.getString("pw"));
						userinfo.setName(rs.getString("name"));
						userinfo.setNickname(rs.getString("nickname"));
						userinfo.setUser_img(rs.getString("user_img"));//5
						userinfo.setBirth(rs.getString("birth"));
						userinfo.setUser_city1(rs.getString("user_city1"));
						userinfo.setUser_district1(rs.getString("user_district1"));
						userinfo.setUser_city2(rs.getString("user_city2"));
						userinfo.setUser_district2(rs.getString("user_district2"));//10
						userinfo.setUser_city3(rs.getString("user_city3"));
						userinfo.setUser_district3(rs.getString("user_district3"));
						userinfo.setUser_level(rs.getInt("user_level"));
						userinfo.setReportCount(rs.getInt("reportCount"));
						userinfo.setWarning(rs.getInt("warning"));//15
						userinfo.setDel_reason(rs.getString("del_reason"));
						userinfo.setComplaints(rs.getString("complaints"));
						userinfo.setUser_state(rs.getString("user_state"));
						
						usersList.add(userinfo);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;//리턴해주기
		}
		
		
		
		
		//2-1검색시 회원 정보 가져오기
		//+검색에따라 수정 필요

		public int getSearchCount(String sel, String search) {
			int seCount = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "select count(*) from users where "+sel +" like '%" + search + "%'";
				//select count (*) from users where userID like '%abc%';
				pstmt= conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				System.out.println("63번 확인용 출력 sel + search :"+ sel + search);
				
				if(rs.next()) {
					seCount = rs.getInt(1); 	
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return seCount;
		}
		
		//2-2 총 회원 리스트자체를 가져오기
		//list 검색 가져오기 메서드
		public List getSearchUsers(int startRow, int endRow, String sel, String search) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List seList = null;
			
			try {
				conn = getConnection();
				String sql = "select A.* , r from (select users.*, rownum r from users where "+sel+" like '%"+search+"%')A where r>=? and r<=?";
				//select * from users where userID like '%test%';
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				UsersDTO usersinfo = null;
				if(rs.next()) {
					seList = new ArrayList();
					do{
						usersinfo = new UsersDTO(); //DTO 생성
						//18개
						usersinfo.setUserID(rs.getString("userID"));
						usersinfo.setPw(rs.getString("pw"));
						usersinfo.setName(rs.getString("name"));
						usersinfo.setNickname(rs.getString("nickname"));
						usersinfo.setUser_img(rs.getString("user_img"));//5
						usersinfo.setBirth(rs.getString("birth"));
						usersinfo.setUser_city1(rs.getString("user_city1"));
						usersinfo.setUser_district1(rs.getString("user_district1"));
						usersinfo.setUser_city2(rs.getString("user_city2"));
						usersinfo.setUser_district2(rs.getString("user_district2"));//10
						usersinfo.setUser_city3(rs.getString("user_city3"));
						usersinfo.setUser_district3(rs.getString("user_district3"));
						usersinfo.setUser_level(rs.getInt("user_level"));
						usersinfo.setReportCount(rs.getInt("reportCount"));
						usersinfo.setWarning(rs.getInt("warning"));//15
						usersinfo.setDel_reason(rs.getString("del_reason"));
						usersinfo.setComplaints(rs.getString("complaints"));
						usersinfo.setUser_state(rs.getString("user_state"));
						
						seList.add(usersinfo);
					}while(rs.next());
			
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return seList;
		}
		
		//adminDeleteUser
		//탈퇴한 회원 총 갯수 가져오기
	      public int getDelCount(String sel) {
	          Connection conn = null;
	          PreparedStatement pstmt = null;
	          ResultSet rs = null;
	          int count = 0;
	          
	          try {
	             conn=getConnection();
	             String sql="";
	             if(sel.equals("강제탈퇴") || sel.equals("탈퇴")) {
	                 sql="select count(*) from users where user_state = ?";
	                 pstmt=conn.prepareStatement(sql);
	                 pstmt.setString(1, sel);
	             }else {
	                sql="select count(*) from users where user_state != '활동'";
	                pstmt=conn.prepareStatement(sql);
	             }
	             rs=pstmt.executeQuery();
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
	          return count;
	       }
	          
	       //탈퇴한 회원 총 목록 가져오기
	       public List getDeleteinfo(String sel, int startRow, int endRow) {
	          
	          Connection conn = null;
	          PreparedStatement pstmt = null;
	          ResultSet rs = null; 
	          List usersList = null;
	          UsersDTO userinfo= null;
	          
	          try{
	             conn=getConnection();
	             String sql ="";
	             if(sel.equals("강제탈퇴") || sel.equals("탈퇴")) {
	                sql="select A.*, r from (select users.*, rownum r from users where user_state = ?)A where r>=? and r<=?";
	                pstmt=conn.prepareStatement(sql);
	                pstmt.setString(1, sel);
	                pstmt.setInt(2, startRow);
	                pstmt.setInt(3, endRow);
	             }else {
	                sql="select A.*, r from (select users.*, rownum r from users where user_state != '활동')A where r>=? and r<=?";
	                pstmt=conn.prepareStatement(sql);
	                pstmt.setInt(1, startRow);
	                pstmt.setInt(2, endRow);
	             }
	             
	             rs = pstmt.executeQuery();//모든정보
	             
	             if(rs.next()) {
	                usersList = new ArrayList();//있으면 객체
	                do{
	                   userinfo = new UsersDTO(); //DTO 생성
	                   //18개
	                   //모든컬럼 셋팅해주기
	                   userinfo.setUserID(rs.getString("userID"));
	                   userinfo.setPw(rs.getString("pw"));
	                   userinfo.setName(rs.getString("name"));
	                   userinfo.setNickname(rs.getString("nickname"));
	                   userinfo.setUser_img(rs.getString("user_img"));//5
	                   userinfo.setBirth(rs.getString("birth"));
	                   userinfo.setUser_city1(rs.getString("user_city1"));
	                   userinfo.setUser_district1(rs.getString("user_district1"));
	                   userinfo.setUser_city2(rs.getString("user_city2"));
	                   userinfo.setUser_district2(rs.getString("user_district2"));//10
	                   userinfo.setUser_city3(rs.getString("user_city3"));
	                   userinfo.setUser_district3(rs.getString("user_district3"));
	                   userinfo.setUser_level(rs.getInt("user_level"));
	                   userinfo.setReportCount(rs.getInt("reportCount"));
	                   userinfo.setWarning(rs.getInt("warning"));//15
	                   userinfo.setDel_reason(rs.getString("del_reason"));
	                   userinfo.setComplaints(rs.getString("complaints"));
	                   userinfo.setUser_state(rs.getString("user_state"));
	                   
	                   usersList.add(userinfo);
	                }while(rs.next());
	          
	             }
	          }catch(Exception e) {
	             e.printStackTrace();
	          }finally {
	             if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	             if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	             if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	          }
	          return usersList;//리턴해주기
	       }
		/*
		//강제탈퇴 회원 불러오기
		public List getAdminDelete(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			UsersDTO userinfo= null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select users.*, rownum r from users where user_state = '강제탈퇴')A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						userinfo = new UsersDTO(); //DTO 생성
						//18개
						//모든컬럼 셋팅해주기
						userinfo.setUserID(rs.getString("userID"));
						userinfo.setPw(rs.getString("pw"));
						userinfo.setName(rs.getString("name"));
						userinfo.setNickname(rs.getString("nickname"));
						userinfo.setUser_img(rs.getString("user_img"));//5
						userinfo.setBirth(rs.getString("birth"));
						userinfo.setUser_city1(rs.getString("user_city1"));
						userinfo.setUser_district1(rs.getString("user_district1"));
						userinfo.setUser_city2(rs.getString("user_city2"));
						userinfo.setUser_district2(rs.getString("user_district2"));//10
						userinfo.setUser_city3(rs.getString("user_city3"));
						userinfo.setUser_district3(rs.getString("user_district3"));
						userinfo.setUser_level(rs.getInt("user_level"));
						userinfo.setReportCount(rs.getInt("reportCount"));
						userinfo.setWarning(rs.getInt("warning"));//15
						userinfo.setDel_reason(rs.getString("del_reason"));
						userinfo.setComplaints(rs.getString("complaints"));
						userinfo.setUser_state(rs.getString("user_state"));
						
						usersList.add(userinfo);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;
		}		
		

		//자진 탈퇴 회원 불러오기
		public List getAdminDelete(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			UsersDTO userinfo= null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select users.*, rownum r from users where user_state = '강제탈퇴')A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						userinfo = new UsersDTO(); //DTO 생성
						//18개
						//모든컬럼 셋팅해주기
						userinfo.setUserID(rs.getString("userID"));
						userinfo.setPw(rs.getString("pw"));
						userinfo.setName(rs.getString("name"));
						userinfo.setNickname(rs.getString("nickname"));
						userinfo.setUser_img(rs.getString("user_img"));//5
						userinfo.setBirth(rs.getString("birth"));
						userinfo.setUser_city1(rs.getString("user_city1"));
						userinfo.setUser_district1(rs.getString("user_district1"));
						userinfo.setUser_city2(rs.getString("user_city2"));
						userinfo.setUser_district2(rs.getString("user_district2"));//10
						userinfo.setUser_city3(rs.getString("user_city3"));
						userinfo.setUser_district3(rs.getString("user_district3"));
						userinfo.setUser_level(rs.getInt("user_level"));
						userinfo.setReportCount(rs.getInt("reportCount"));
						userinfo.setWarning(rs.getInt("warning"));//15
						userinfo.setDel_reason(rs.getString("del_reason"));
						userinfo.setComplaints(rs.getString("complaints"));
						userinfo.setUser_state(rs.getString("user_state"));
						
						usersList.add(userinfo);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;
		}		
		
		
		
*/
		
		//서치한 회원 총 갯수 가져오기
	      public int getSelCount(String sel, String search) {
	          Connection conn = null;
	          PreparedStatement pstmt = null;
	          ResultSet rs = null;
	          int count = 0;
	          
	          try {
	             conn=getConnection();
	             String sql="";
	             if(sel.equals("강제탈퇴") || sel.equals("탈퇴")) {
	                 sql="select count(*) from users where userid like '%" +search+ "%' and user_state = ?";
	                 pstmt=conn.prepareStatement(sql);
	                 pstmt.setString(1, sel);
	                 
	             }else {
	                sql="select count(*) from users where userid like '%" +search+ "%' and user_state != '활동'";
	                pstmt=conn.prepareStatement(sql);
	                
	             }
	             rs=pstmt.executeQuery();
	             
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
	          return count;
	       }
	          
	       //탈퇴한 회원 총 목록 가져오기
	       public List getSelInfo(String sel,String search,int startRow,int endRow) {
	          
	          Connection conn = null;
	          PreparedStatement pstmt = null;
	          ResultSet rs = null; 
	          List usersList = null;
	          UsersDTO userinfo= null;
	          
	          try{
	             conn=getConnection();
	             String sql ="";
	             if(sel.equals("강제탈퇴") || sel.equals("탈퇴")) {
	                sql="select A.*, r from (select users.*, rownum r from users where userid like '%" +search+ "%' and user_state = ?)A where r>=? and r<=?";
	                pstmt=conn.prepareStatement(sql);
	                pstmt.setString(1, sel);
	                pstmt.setInt(2, startRow);
	                pstmt.setInt(3, endRow);
	             }else {
	                sql="select A.*, r from (select users.*, rownum r from users where  userid like '%" +search+ "%' and user_state != '활동')A where r>=? and r<=?";
	                pstmt=conn.prepareStatement(sql);
	                pstmt.setInt(1, startRow);
	                pstmt.setInt(2, endRow);
	             }
	             rs = pstmt.executeQuery();//모든정보
	             
	             if(rs.next()) {
	                usersList = new ArrayList();//있으면 객체
	                do{
	                   userinfo = new UsersDTO(); //DTO 생성
	                   userinfo.setUserID(rs.getString("userID"));
	                   userinfo.setPw(rs.getString("pw"));
	                   userinfo.setName(rs.getString("name"));
	                   userinfo.setNickname(rs.getString("nickname"));
	                   userinfo.setUser_img(rs.getString("user_img"));//5
	                   userinfo.setBirth(rs.getString("birth"));
	                   userinfo.setUser_city1(rs.getString("user_city1"));
	                   userinfo.setUser_district1(rs.getString("user_district1"));
	                   userinfo.setUser_city2(rs.getString("user_city2"));
	                   userinfo.setUser_district2(rs.getString("user_district2"));//10
	                   userinfo.setUser_city3(rs.getString("user_city3"));
	                   userinfo.setUser_district3(rs.getString("user_district3"));
	                   userinfo.setUser_level(rs.getInt("user_level"));
	                   userinfo.setReportCount(rs.getInt("reportCount"));
	                   userinfo.setWarning(rs.getInt("warning"));//15
	                   userinfo.setDel_reason(rs.getString("del_reason"));
	                   userinfo.setComplaints(rs.getString("complaints"));
	                   userinfo.setUser_state(rs.getString("user_state"));
	                   
	                   usersList.add(userinfo);
	                }while(rs.next());
	          
	             }
	          }catch(Exception e) {
	             e.printStackTrace();
	          }finally {
	             if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	             if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	             if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	          }
	          return usersList;//리턴해주기
	       }
		
		
		
		
		
/*		
		//3-1탈퇴한 회원 서치 개수

		public int getDelSeCount(String search, String sel) {
			int deCount = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "select count(*) from reports where "+sel +" like '%" + search + "%'";
				//select count (*) from users where userID like '%abc%';
				pstmt= conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				System.out.println("63번 확인용 출력 sel + search :"+ search);
				
				if(rs.next()) {
					deCount = rs.getInt(1); 	
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return deCount;
		}		
		
		
		
		//3-2탈퇴한 회원 서치 목록 가져오기
		//검색 list 가져오기
		public List getDelSeUsers(int startRow, int endRow, String search) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List deList = null;
			
			try {
				conn = getConnection();
				String sql = "select A.* , r from (select users.*, rownum r from users where "sel" userID like '%"+search+"%')A where r>=? and r<=?";
				//select * from users where userID like '%test%';
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				UsersDTO usersinfo = null;
				if(rs.next()) {
					deList = new ArrayList();
					do{
						usersinfo = new UsersDTO(); //DTO 생성
						//18개
						usersinfo.setUserID(rs.getString("userID"));
						usersinfo.setPw(rs.getString("pw"));
						usersinfo.setName(rs.getString("name"));
						usersinfo.setNickname(rs.getString("nickname"));
						usersinfo.setUser_img(rs.getString("user_img"));//5
						usersinfo.setBirth(rs.getString("birth"));
						usersinfo.setUser_city1(rs.getString("user_city1"));
						usersinfo.setUser_district1(rs.getString("user_district1"));
						usersinfo.setUser_city2(rs.getString("user_city2"));
						usersinfo.setUser_district2(rs.getString("user_district2"));//10
						usersinfo.setUser_city3(rs.getString("user_city3"));
						usersinfo.setUser_district3(rs.getString("user_district3"));
						usersinfo.setUser_level(rs.getInt("user_level"));
						usersinfo.setReportCount(rs.getInt("reportCount"));
						usersinfo.setWarning(rs.getInt("warning"));//15
						usersinfo.setDel_reason(rs.getString("del_reason"));
						usersinfo.setComplaints(rs.getString("complaints"));
						usersinfo.setUser_state(rs.getString("user_state"));
						
						deList.add(usersinfo);
					}while(rs.next());
			
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return deList;
		}
		
*/		
		//adminReportsList
		//신고당한 회원 총 개수 가져오기
		public int getRepCount() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn=getConnection();
				String sql="select count(*) from reports";
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);
						System.out.println("68번 관리자 신고당한 회원수 확인용 : "+ rs.getInt(1));
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}			
			
			return count;
		}
		
		//신고당한 회원 총 리스트 가져오기
		public List getRepinfo(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			ReportsDTO rdao = null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select reports.*, rownum r from reports order by rep_reg desc)A where r>=? and r<=?";
				sql ="select * from (select A.*, rownum r from(select reports.* from reports order by rep_reg desc)A) where r >= ? and r <= ?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						rdao = new ReportsDTO(); //DTO 생성
						//10개
						//모든컬럼 셋팅해주기
						rdao.setRep_num(rs.getInt("rep_num"));
						rdao.setCategory(rs.getString("category"));
						rdao.setNum(rs.getInt("num"));
						rdao.setUserID(rs.getString("userID"));
						rdao.setReporterID(rs.getString("reporterID"));//5
						rdao.setRep_reg(rs.getTimestamp("rep_reg"));
						rdao.setRep_reason(rs.getString("rep_reason"));
						rdao.setRep_content(rs.getString("rep_content"));
						rdao.setProcessing(rs.getString("processing"));
						rdao.setResult(rs.getString("result"));//10
						
						usersList.add(rdao);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			System.out.println("유저리스트 확인용 출력" + usersList );
			return usersList;//리턴해주기
		}
		
		//4-1신고회원 서치 했을때
		//총개수
		public int getSeRepCount(String sel, String search) {
			int seCount = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn= getConnection();
				String sql = "select count(*) from reports where "+sel +" like '%" + search + "%'";
				//select count (*) from reports where userID like '%abc%';
				pstmt= conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				System.out.println("70번 확인용 출력 sel + search :"+ sel + search);
				
				if(rs.next()) {
					seCount = rs.getInt(1); 	
				}
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return seCount;
		}
	
	
		//4-2총 회원 리스트
		//검색 list 가져오기
		public List getSeRepinfo(int startRow, int endRow, String sel, String search) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List usersList = null;

			
			try {
				conn = getConnection();
				String sql = "select A.* , r from (select reports.*, rownum r from reports where "+sel+" like '%"+search+"%' order by rep_reg desc)A where r>=? and r<=?";
				//select * from users where userID like '%test%';
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				ReportsDTO rdao = null;
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						rdao = new ReportsDTO(); //DTO 생성
						//10개
						rdao.setRep_num(rs.getInt("rep_num"));
						rdao.setCategory(rs.getString("category"));
						rdao.setNum(rs.getInt("num"));
						rdao.setUserID(rs.getString("userID"));
						rdao.setReporterID(rs.getString("reporterID"));//5
						rdao.setRep_reg(rs.getTimestamp("rep_reg"));
						rdao.setRep_reason(rs.getString("rep_reason"));
						rdao.setRep_content(rs.getString("rep_content"));
						rdao.setProcessing(rs.getString("processing"));
						rdao.setResult(rs.getString("result"));//10
						
						usersList.add(rdao);
					}while(rs.next());
			
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return usersList;
		}
		
		//adminDeletePro
		//회원 강탈시키는 메서드
		public void getDropUser(String userID, int rep_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count1 =0;
			int count2 =0;
			try {
				conn = getConnection();
				String sql = "update users set user_state ='강제탈퇴' where userID=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);
				count1 = pstmt.executeUpdate();

				sql = "update reports set processing ='true', result ='강제탈퇴' where rep_num=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, rep_num);
				count2 = pstmt.executeUpdate();
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
		}
		
		
		//회원 경고주는 메서드
		public void getWarnUser(String userID, int rep_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count1 =0;
			int count2 =0;
			try {
				conn = getConnection();
				String sql = "update users set warning = warning +1 where userID=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, userID);

				count1 = pstmt.executeUpdate();

				sql = "update reports set result ='경고' where rep_num=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, rep_num);

				pstmt.executeUpdate();
				
				sql = "update reports set processing ='true' where rep_num=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, rep_num);
				pstmt.executeUpdate();
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			
		}
		
		//신고처리 넘어가기 메서드
		public void getPassUser(int rep_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			//int count1 =0;
			int count2 =0;
			try {
				conn = getConnection();
				String sql = "update reports set processing ='true', result ='넘어가기' where rep_num= ?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, rep_num);

				count2 = pstmt.executeUpdate();
				
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			
		}
		
		//--------------------------------
		//관리자 이벤트 리스트 불러오기
		public int getEvenCount(){
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn = getConnection();
				String sql = "select count(*) from eventList";
				pstmt= conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1); 
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count;
		}
		
		
		//관리자 이벤트 페이지 리스트 모두 가져오기
		//--------------------------------------------------------------
		public List getEventAll(int startRow, int endRow) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List list = null;
			
			try {
				conn = getConnection();
				String sql = "select A.*, r from (select eventList.*, rownum r from eventList)A where r>=? and r<=?";
				 sql = "select * from (select A.*, rownum r from(select eventList.* from eventList order by eve_num desc)A) where r >= ? and r <= ?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				EventDTO edto = null;
				if(rs.next()) {
					list = new ArrayList();
					do{
						edto = new EventDTO(); //DTO 생성
						//7개
						edto.setEve_num(rs.getInt("eve_num"));
						edto.setEve_title(rs.getString("eve_title"));
						edto.setEve_startdate(rs.getString("eve_startdate"));
						edto.setEve_enddate(rs.getString("eve_enddate"));
						edto.setEve_content(rs.getString("eve_content"));//5
						edto.setEve_img(rs.getString("eve_img"));
						edto.setEve_hit(rs.getInt("eve_hit"));//추가
						
						list.add(edto);
					}while(rs.next());
			
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return list;//이벤트  글 리스트 리턴
		}
		
		
		
		//관리자 이벤트 삭제
		public void getDelEvent(int eve_num) {//eve_num 매개변수로 넘어옴
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "delete from eventList where eve_num=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, eve_num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					System.out.println( "이벤트 리스트 삭제 완료");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		//관리자페이지 공지사항 모두 가져오기
		//불러올 공지사항 있는지 총 개수 
		public int getInfoCount(){
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn = getConnection();
				String sql = "select count(*) from information";
				pstmt= conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt(1);
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return count;//공지사항 몇개있나?
		}
		
		//공지사항 리스트 가져오기
		public List getInfoAll(int startRow, int endRow) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List infolist = null;
			
			try {
				conn = getConnection();
				String sql = "select * from (select A.*, rownum r from(select information.* from information order by info_num desc)A) where r >= ? and r <= ?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				InfoDTO idto = null;
				if(rs.next()) {
					infolist = new ArrayList();
					do{
						idto = new InfoDTO(); //DTO 생성
						//4개
						idto.setInfo_num(rs.getInt("info_num"));
						idto.setInfo_title(rs.getString("info_title"));
						idto.setInfo_content(rs.getString("info_content"));
						idto.setInfo_reg(rs.getTimestamp("info_reg"));
						
						infolist.add(idto);
					}while(rs.next());
			
				}
			}catch(Exception e ) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
			}
			return infolist;//이벤트  글 리스트 리턴
		}
		
		
		//관리자 공지사항 권한 삭제
		public void getDelInfo(int info_num) {//eve_num 매개변수로 넘어옴
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "delete from information where info_num=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, info_num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					System.out.println("공지사항 삭제 완료");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		
		
		
		
		
		//------------adminReportList
		//누르면 파라미터 필터링
		//미처리 신고 필터링
		//미처리 개수 가져오기
		public int getWarn1Count() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn=getConnection();
				String sql="select count(*) from reports where processing='false'";
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
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
			
			return count;
		}
		
		
		
		//미처리 모두 가져오기
		public List getWarn1(int startRow, int endRow) {//procession=false
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			ReportsDTO rdao = null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select reports.*, rownum r from reports where processing ='false')A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						rdao = new ReportsDTO(); //DTO 생성
						//10개
						//모든컬럼 셋팅해주기
						rdao.setRep_num(rs.getInt("rep_num"));
						rdao.setCategory(rs.getString("category"));
						rdao.setNum(rs.getInt("num"));
						rdao.setUserID(rs.getString("userID"));
						rdao.setReporterID(rs.getString("reporterID"));//5
						rdao.setRep_reg(rs.getTimestamp("rep_reg"));
						rdao.setRep_reason(rs.getString("rep_reason"));
						rdao.setRep_content(rs.getString("rep_content"));
						rdao.setProcessing(rs.getString("processing"));
						rdao.setResult(rs.getString("result"));//10
						
						usersList.add(rdao);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;//리턴해주기
		}
		
		
		
		//경고처리 개수 가져오기
		public int getWarn2Count() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn=getConnection();
				String sql="select count(*) from reports where result='경고'";
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
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
			
			return count;
		}		
		
		
		
		
		//경고 처리 필터링
		public List getWarn2(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			ReportsDTO rdao = null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select reports.*, rownum r from reports where result ='경고')A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();//모든정보
				
				if(rs.next()) {
					usersList = new ArrayList();//있으면 객체
					do{
						rdao = new ReportsDTO(); //DTO 생성
						//10개
						//모든컬럼 셋팅해주기
						rdao.setRep_num(rs.getInt("rep_num"));
						rdao.setCategory(rs.getString("category"));
						rdao.setNum(rs.getInt("num"));
						rdao.setUserID(rs.getString("userID"));
						rdao.setReporterID(rs.getString("reporterID"));//5
						rdao.setRep_reg(rs.getTimestamp("rep_reg"));
						rdao.setRep_reason(rs.getString("rep_reason"));
						rdao.setRep_content(rs.getString("rep_content"));
						rdao.setProcessing(rs.getString("processing"));
						rdao.setResult(rs.getString("result"));//10
						
						usersList.add(rdao);
					}while(rs.next());
			
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;//리턴해주기
		}
				
		
		//넘어가기 필터링
		//넘어가기한 개수 가져오기
		public int getWarn3Count() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			
			try {
				conn=getConnection();
				String sql="select count(*) from reports where result='넘어가기'";
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
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
			
			return count;
		}				
		
		
		
		
		
		
		//->넘어가기 눌러서 처리된것
		public List getWarn3(int startRow, int endRow) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; 
			List usersList = null;
			ReportsDTO rdao = null;
			
			try{
				conn=getConnection();
				String sql ="select A.*, r from (select reports.*, rownum r from reports where result ='넘어가기')A where r>=? and r<=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					usersList = new ArrayList();
					do{
						rdao = new ReportsDTO();
						//10개
						rdao.setRep_num(rs.getInt("rep_num"));
						rdao.setCategory(rs.getString("category"));
						rdao.setNum(rs.getInt("num"));
						rdao.setUserID(rs.getString("userID"));
						rdao.setReporterID(rs.getString("reporterID"));//5
						rdao.setRep_reg(rs.getTimestamp("rep_reg"));
						rdao.setRep_reason(rs.getString("rep_reason"));
						rdao.setRep_content(rs.getString("rep_content"));
						rdao.setProcessing(rs.getString("processing"));
						rdao.setResult(rs.getString("result"));//10
						
						usersList.add(rdao);
					}while(rs.next());
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return usersList;//리턴해주기
		}
		
		
		
		
}
