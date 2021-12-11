package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TopicDAO {

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	
	// 커뮤니티 게시글 추가
	public void insertTopic(TopicDTO dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into topics values(topics_seq.nextVal,?,?,?,?,?,0,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getCategory());
			pstmt.setString(2, dto.getUserID()); 
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getTpc_title());
			pstmt.setString(5, dto.getTpc_content());
			
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 카테고리, 검색어로 게시글 찾기
	public int searchTopicCount(String sel, String search, String category) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int res = 0;
		try {
			String sql;
			conn = getConnection();
			sql = "select count(*) from topics where category like '%" + category + "%' and " + sel + " like '%" + search + "%'";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				res = rs.getInt(1);
			}			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return res;
	}
	
	// 카테고리, 검색어로 찾은 게시글 목록 리스트 저장
	public List getSearchTopics(int start, int end, String sel, String search, String category, String orderBy) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List topicList = null;
		
		try {
			conn = getConnection();
			String sql = "";
			
			if(orderBy.equals("likes")) {
				sql = "select * from (select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, c, rownum r from (select * " + 
						"from (select t.tpc_num, t.category, t.userid, t.nickname, t.tpc_title, t.tpc_content, t.tpc_hit, t.tpc_reg, tl.c from topics t, (select tpc_num, count(tpc_num) c from topiclikes group by tpc_num) tl " + 
						"where ((t.tpc_num = tl.tpc_num) and (t.category like '%" + category + "%')) and " + sel + " like '%" + search + "%' " +
						"union " + 
						"select * " + 
						"from (select * from topics t where t.tpc_num not in (select tpc_num from topiclikes group by tpc_num)), (select 0 as c from dual)) where category like '%" + category + "%' and " + sel + " like '%" + search + "%' " +
						"order by c desc, tpc_num desc)) where r >= ? and r <= ?";
			} else {
				sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
						"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
						"(select * from topics where category like '%" + category + "%' and " + sel + " like '%" + search + "%' order by "+ orderBy + ")) " + 
						"where r >= ? and r <= ?";
			} 
		
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				topicList = new ArrayList(); // 결과가 있으면 list 객체 생성해서 준비
				do { // if문에서 rs.next() 실행되서 커서가 내려가버렸으니 do-while로 먼저 데이터 꺼내게 하기
					TopicDTO dto = new TopicDTO();
					dto.setTpc_num(rs.getInt(1));
					dto.setCategory(rs.getString(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setTpc_title(rs.getString(5));
					dto.setTpc_content(rs.getString(6));
					dto.setTpc_hit(rs.getInt(7));
					dto.setTpc_reg(rs.getTimestamp(8));
					topicList.add(dto); // 리스트에 추가
				} while(rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return topicList;
	}
	
	// 게시글 총 개수 가져오기
	public int getTopicCount(String category) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sql;
			System.out.println(category);
			if(category == null || category.equals("전체")) {
				sql = "select count(*) from topics";
			} else {
				sql = "select count(*) from topics where category like '" + category + "'";
			}
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
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
	
	// 전체 게시글 가져오기
	public List getTopics(int start, int end, String category, String orderBy) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List topicList = null;
		System.out.println("getTopics");
		
		
		try {
			conn = getConnection();
			String sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
					"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
					"(select * from topics order by tpc_num desc))" + 
					"where r >= ? and r <= ?";
			
			
			if(category == null || category.equals("전체")) {
					if(orderBy == null) {
						sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
								"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
								"(select * from topics order by tpc_num desc)) " + 
								"where r >= ? and r <= ?";	
					} else if(orderBy.equals("인기순")) {
						sql = "select * from (select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, c, rownum r from (select * " + 
								"from (select t.tpc_num, t.category, t.userid, t.nickname, t.tpc_title, t.tpc_content, t.tpc_hit, t.tpc_reg, tl.c from topics t, (select tpc_num, count(tpc_num) c from topiclikes group by tpc_num) tl " + 
								"where t.tpc_num = tl.tpc_num " + 
								"union " + 
								"select * " + 
								"from (select * from topics t where t.tpc_num not in (select tpc_num from topiclikes group by tpc_num)), (select 0 as c from dual)) " + 
								"order by c desc, tpc_num desc)) where r >= ? and r <= ?";
					} else if(orderBy.equals("조회순")) {
						String odr = "tpc_hit desc";
						sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
								"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
								"(select * from topics order by "+ odr + "))" + 
								"where r >= ? and r <= ?";
					} else if(orderBy.equals("최신순")) {
						String odr = "tpc_reg desc";
						sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
								"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
								"(select * from topics order by "+ odr + "))" + 
								"where r >= ? and r <= ?";
					} else {
						sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
								"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
								"(select * from topics order by tpc_num desc))" + 
								"where r >= ? and r <= ?";
					}
			} else {
				if(orderBy == null) {
					sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
							"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
							"(select * from topics where category like '" + category + "' order by tpc_num desc))" + 
							"where r >= ? and r <= ?";	
				}
				else if(orderBy.equals("인기순")) {
					sql = "select * from (select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, c, rownum r from (select * " + 
							"from (select t.tpc_num, t.category, t.userid, t.nickname, t.tpc_title, t.tpc_content, t.tpc_hit, t.tpc_reg, tl.c from topics t, (select tpc_num, count(tpc_num) c from topiclikes group by tpc_num) tl " + 
							"where t.tpc_num = tl.tpc_num and t.category like '" + category + "'" +
							"union " + 
							"select * " + 
							"from (select * from topics t where t.tpc_num not in (select tpc_num from topiclikes group by tpc_num)), (select 0 as c from dual)) where category like '" + category + "' " +
							"order by c desc, tpc_num desc)) where r >= ? and r <= ?";
				} else if(orderBy.equals("조회순")) {
					String odr = "tpc_hit desc";
					sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
							"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
							"(select * from topics where category like '" + category + "'  order by "+ odr + ")) " + 
							"where r >= ? and r <= ?";
				} else if(orderBy.equals("최신순")) {
					String odr = "tpc_reg desc";
					sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
							"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
							"(select * from topics where category like '" + category + "' order by "+ odr + ")) " + 
							"where r >= ? and r <= ?";
				} else {
					sql = "select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from " + 
							"(select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from " +
							"(select * from topics where category like '" + category + "' order by tpc_num desc)) " + 
							"where r >= ? and r <= ?";
				}
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				topicList = new ArrayList(); // 결과가 있으면 list 객체 생성해서 준비
				do { // if문에서 rs.next() 실행되서 커서가 내려가버렸으니 do-while로 먼저 데이터 꺼내게 하기
					TopicDTO dto = new TopicDTO();
					dto.setTpc_num(rs.getInt(1));
					dto.setCategory(rs.getString(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setTpc_title(rs.getString(5));
					dto.setTpc_content(rs.getString(6));	
					dto.setTpc_hit(rs.getInt(7));
					dto.setTpc_reg(rs.getTimestamp(8));
					topicList.add(dto); // 리스트에 추가
				} while(rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return topicList;
	}
	
	// 게시글 하나 가져오기
	public TopicDTO getTopic(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TopicDTO dto = null;
		
		try {
			conn = getConnection();
			
			String sql = "update topics set tpc_hit = tpc_hit+1 where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			pstmt.executeUpdate();
			
			sql = "select * from topics where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new TopicDTO();
				dto.setTpc_num(rs.getInt(1));
				dto.setCategory(rs.getString(2));
				dto.setUserID(rs.getString(3));
				dto.setNickname(rs.getString(4));
				dto.setTpc_title(rs.getString(5));
				dto.setTpc_content(rs.getString(6));
				dto.setTpc_hit(rs.getInt(7));
				dto.setTpc_reg(rs.getTimestamp(8));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return dto;
		
	}
	
	// 해당 게시글의 댓글 목록 가져오기
	public List getTopicComments(int tpc_num, int start, int end) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List topicCommentsList = null;
		
		try {
			conn = getConnection();
			String sql = "select tpc_com_num, tpc_num, userID, nickname, tpc_com_content, tpc_com_reg, r from("
					+ "select tpc_com_num, tpc_num, userID, nickname, tpc_com_content, tpc_com_reg, rownum r from ("
					+ "select tpc_com_num, tpc_num, userID, nickname, tpc_com_content, tpc_com_reg from topicComments where tpc_num = ? order by tpc_com_num desc)) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				topicCommentsList = new ArrayList(); // 결과가 있으면 list 객체 생성해서 준비
				do { // if문에서 rs.next() 실행되서 커서가 내려가버렸으니 do-while로 먼저 데이터 꺼내게 하기
					TopicCommentDTO dto = new TopicCommentDTO();
					dto.setTpc_com_num(rs.getInt(1));
					dto.setTpc_num(rs.getInt(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setTpc_com_content(rs.getString(5));
					dto.setTpc_com_reg(rs.getTimestamp(6));
					topicCommentsList.add(dto); // 리스트에 추가
				} while(rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return topicCommentsList;
	}
	
	
	// 해당 게시글 댓글 수 가져오기
	public int getTopicCommentCount(int tpc_num) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = getConnection();
			String sql = "select count(*) from topicComments where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_num);
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
	
	// 게시글 댓글 추가하기
	public void insertTopicComment(TopicCommentDTO dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into topiccomments values(topiccomments_seq.nextVal,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getTpc_num());
			pstmt.setString(2, dto.getUserID());
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getTpc_com_content());

			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 게시글 댓글 삭제하기
	public void deleteTopicComment(int tpc_com_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from topiccomments where tpc_com_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_com_num);

			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 게시글 수정
	public void updateTopic(TopicDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
				conn = getConnection();	
				String sql = "update topics set category = ?, tpc_title = ?, tpc_content = ?, tpc_reg = sysdate where tpc_num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getCategory());
				pstmt.setString(2, dto.getTpc_title());
				pstmt.setString(3, dto.getTpc_content());
				pstmt.setInt(4,dto.getTpc_num());
			
				pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 게시글 삭제
	public void deleteTopic(int tpc_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "delete from topics where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_num);
			pstmt.executeUpdate();
			
			sql = "delete from topiccomments where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_num);
			pstmt.executeUpdate();
			
			sql = "delete from topiclikes where tpc_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tpc_num);
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 인기순 N번째 게시글 가져오기 
	public TopicDTO getLikeTopic(int num) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		TopicDTO dto = null;
		
		try {
			conn=getConnection();
			String sql = "select r, tpc_num, c from (select rownum r, tpc_num, c "
					+ "from (select tpc_num, count(*) c from topiclikes group by tpc_num order by c desc)) "
					+ "where r = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				int tpc_num = rs.getInt("tpc_num");
				
				sql="select * from groups where group_num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, tpc_num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					dto = new TopicDTO();
					dto.setTpc_num(rs.getInt(1));
					dto.setCategory(rs.getString(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setTpc_title(rs.getString(5));
					dto.setTpc_content(rs.getString(6));
					dto.setTpc_hit(rs.getInt(7));
					dto.setTpc_reg(rs.getTimestamp(8));
				}
			} else {
				sql = "select tpc_num, category, userID, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, r from ("
						+ "select tpc_num, category, userID, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, rownum r from ("
						+ "select * from topics order by tpc_num desc))" + 
						" where r = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					dto = new TopicDTO();
					dto.setTpc_num(rs.getInt(1));
					dto.setCategory(rs.getString(2));
					dto.setUserID(rs.getString(3));
					dto.setNickname(rs.getString(4));
					dto.setTpc_title(rs.getString(5));
					dto.setTpc_content(rs.getString(6));
					dto.setTpc_hit(rs.getInt(7));
					dto.setTpc_reg(rs.getTimestamp(8));
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs !=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt !=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn !=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return dto;
	}
	
	// 전체 게시글 가져오기
		public List getLikeTopics() {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List topicList = null;
			System.out.println("getTopics");
			
			
			try {
				conn = getConnection();
				String sql = "select * from (select tpc_num, category, userid, nickname, tpc_title, tpc_content, tpc_hit, tpc_reg, c, rownum r from (select * " + 
									"from (select t.tpc_num, t.category, t.userid, t.nickname, t.tpc_title, t.tpc_content, t.tpc_hit, t.tpc_reg, tl.c from topics t, (select tpc_num, count(tpc_num) c from topiclikes group by tpc_num) tl " + 
									"where t.tpc_num = tl.tpc_num " + 
									"union " + 
									"select * " + 
									"from (select * from topics t where t.tpc_num not in (select tpc_num from topiclikes group by tpc_num)), (select 0 as c from dual)) " + 
									"order by c desc, tpc_num desc))";
				
				pstmt = conn.prepareStatement(sql);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					topicList = new ArrayList(); // 결과가 있으면 list 객체 생성해서 준비
					do { // if문에서 rs.next() 실행되서 커서가 내려가버렸으니 do-while로 먼저 데이터 꺼내게 하기
						TopicDTO dto = new TopicDTO();
						dto.setTpc_num(rs.getInt(1));
						dto.setCategory(rs.getString(2));
						dto.setUserID(rs.getString(3));
						dto.setNickname(rs.getString(4));
						dto.setTpc_title(rs.getString(5));
						dto.setTpc_content(rs.getString(6));	
						dto.setTpc_hit(rs.getInt(7));
						dto.setTpc_reg(rs.getTimestamp(8));
						topicList.add(dto); // 리스트에 추가
					} while(rs.next());
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return topicList;
		}
	
}
