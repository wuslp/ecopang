package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GroupDAO {
	
	private Connection getConnection() throws Exception{
		Context ctx=new InitialContext();
		Context env=(Context)ctx.lookup("java:comp/env");
		DataSource ds=(DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
		
	}
	// 소모임 전체 개수 가져오기 
	public int getGroupCount() {
		int count=0;
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			conn=getConnection();
			String sql="select count(*) from groups";
			pstmt=conn.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			if(rs.next()) {
				count=rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			}
			return count;
		}
		// 소모임 목록 가져오기 == list가 완성이 되야 가져올수 있을거 같음
	 	public List getGroups(int start, int end) {
	 		Connection conn=null;
	 		PreparedStatement pstmt=null;
	 		ResultSet rs=null;
	 		List groupList=null;
	 		
	 		try {
	 			conn=getConnection();
	 			String sql="select group_num,userID,group_title,city,location,group_content,group_img,group_reg,r "
	 				+ "from (select group_num,userID,group_title,city,location,group_content,group_img,group_reg,rownum r "
	 				+ "from (select * from groups order by group_num desc)) where r>=? and r<=? ";
	 			
	 			pstmt=conn.prepareStatement(sql);
	 			pstmt.setInt(1, start);
	 			pstmt.setInt(2, end);
	 			rs=pstmt.executeQuery();
	 			
	 			if(rs.next()) {
	 				groupList=new ArrayList();
	 				do {
	 					GroupDTO group=new GroupDTO();
	 					group.setGroup_num(rs.getInt(1));
	 					group.setUserID(rs.getString(2));
	 					group.setGroup_title(rs.getString(3));
	 					group.setCity(rs.getString(4));
	 					group.setLocation(rs.getString(5)); 
	 					group.setGroup_content(rs.getString(6));
	 					group.setGroup_img(rs.getString(7)); 
	 					group.setGroup_reg(rs.getTimestamp(8));
	 					groupList.add(group); // 리스트에 추가

	 				}while(rs.next());
	 						
	 			}//if
	 			
	 			
	 		}catch(Exception e) {
	 			e.printStackTrace();
	 		}finally {
	 			if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
				if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				}
	 			return groupList;
	 		}

	// 소모임에서 작성한거 저장하는 메서드, 각각 저장해서 dto에서 불러줌
	public void insertGroup(GroupDTO dto) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		
		try {
			
			conn=getConnection();
			String sql="insert into groups values(groups_seq.nextVal,?,?,?,?,?,?,sysdate)";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserID());// 임시 유저 아이디 
			pstmt.setString(2, dto.getGroup_title());
			pstmt.setString(3, dto.getCity());
			pstmt.setString(4, dto.getLocation());
			pstmt.setString(5, dto.getGroup_content());
			pstmt.setString(6, dto.getGroup_img());

			pstmt.executeUpdate();

		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt !=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn !=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			
		}
	}	
		// 고유번호 받아 소모임 한개 가져오는 메서드
		public GroupDTO getGroup(int group_num) {
			Connection conn=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			GroupDTO group=null;
			
			try {
				conn=getConnection();

				// 해당 모임 가져오기 
				String sql="select * from groups where group_num=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				
				rs=pstmt.executeQuery();
				if(rs.next()) {
					group=new GroupDTO();
					group.setGroup_num(rs.getInt("group_num"));
					group.setUserID(rs.getString("userID"));
					group.setGroup_title(rs.getString("group_title"));
					group.setCity(rs.getString("city"));
					group.setLocation(rs.getString("location"));
					group.setGroup_content(rs.getString("group_content"));
					group.setGroup_img(rs.getString("group_img"));
					group.setGroup_reg(rs.getTimestamp("group_reg"));
					
					}	
			
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
				if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			}
			return group;
			}
			// 소모임 수정 폼에 글 가져오기 
			public GroupDTO getUpdateGroup(int group_num) {
				GroupDTO group=null;
				Connection conn=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				
				try {
					conn=getConnection();
						String sql="select * from groups where group_num=?";
						pstmt=conn.prepareStatement(sql);
						pstmt.setInt(1, group_num);
						
						rs=pstmt.executeQuery();
						if(rs.next()) {
							group=new GroupDTO();
							group.setGroup_num(rs.getInt("group_num"));
							//group.setUserID(rs.getString("userID"));
							group.setGroup_title(rs.getString("group_title"));
							group.setCity(rs.getString("city"));
							group.setLocation(rs.getString("location"));
							group.setGroup_content(rs.getString("group_content"));
							group.setGroup_img(rs.getString("group_img"));
							group.setGroup_reg(rs.getTimestamp("group_reg"));
						}		
					
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
					if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
					if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				}
				return group;
			}
		
			// 소모임 수정 
			public int updateGroup(GroupDTO dto) {
				Connection conn=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				int result=0;
				
				try {
					conn=getConnection();
					String sql="update groups set group_title=?, city=?, location=?, group_img=?, group_content=? where group_num=?";
					
					pstmt=conn.prepareStatement(sql);
					pstmt.setString(1, dto.getGroup_title());
					pstmt.setString(2, dto.getCity());
					pstmt.setString(3, dto.getLocation());
					pstmt.setString(4, dto.getGroup_img());
					pstmt.setString(5, dto.getGroup_content());
					pstmt.setInt(6, dto.getGroup_num());
					result=pstmt.executeUpdate();

				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
					if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
					if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
				}
				return result; 
				
			}	
			

		//소모임 삭제 
		public void deleteGroup(int group_num) { 
			Connection conn=null;
			PreparedStatement pstmt=null;

			try {
				conn=getConnection();
				String sql="delete from groups where group_num=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, group_num);
				pstmt.executeUpdate();
	
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
			}
			
		}
		
		// 검색된 글의 개수 가져오기 
		public int getSearchGroupCount(String sel, String search) {
			int count=0;
			Connection conn=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			
			try {
				conn=getConnection();
				String sql="select count(*) from groups where "+ sel +" like '%" + search + "%'";
				pstmt=conn.prepareStatement(sql);
				
				rs=pstmt.executeQuery();
				if(rs.next()) {
					count=rs.getInt(1); // count(*)은 결과를 숫자로 가져오며, 컬럼명대신 컬럼번호로 꺼내기
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally{
				if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
				if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
				if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				}
			return count;
			}
			// 검색한 글들 가져오기 
			public List getSearchGroups(int start, int end, String sel, String search, String sort) {
				Connection conn=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				List groupList=null;
				System.out.println("sel : " + sel);
				try {
					conn=getConnection();
					String sql="";
					
					if(sort.equals("1")) {
						sql = "select * from (select A.*, rownum r from (select * from (select g.*,gl.c from groups g,(select group_num,count(*) c from grouplikes group by group_num)gl where g.group_num = gl.group_num " + 
								"union " + 
								"select * from groups,(select 0 c from dual) where group_num not in (select group_num from grouplikes group by group_num)) where " + sel + " like '%" + search + "%' order by c desc)A) where r >= ? and r <= ?";
					} else if(sort.equals("2")) {
						sql="select group_num,userID,group_title,city,location,group_content,group_img,group_reg,r "
				 				+ "from (select group_num,userID,group_title,city,location,group_content,group_img,group_reg,rownum r "
				 				+ "from (select * from groups where " + sel + " like '%" + search + "%'  order by group_reg desc)) where r>=? and r<=?";
					} else if(sort.equals("3")) {
						sql = "select * from (select A.*, rownum r from (select * from (select g.*,gl.c from groups g,(select group_num,count(*) c from reviews group by group_num)gl where g.group_num = gl.group_num " + 
								"union " + 
								"select * from groups,(select 0 c from dual) where group_num not in (select group_num from reviews group by group_num)) where " + sel + " like '%" + search + "%' order by c desc)A) where r >= ? and r <= ?";
					} else {
						sql="select group_num,userID,group_title,city,location,group_content,group_img,group_reg,r "
			 				+ "from (select group_num,userID,group_title,city,location,group_content,group_img,group_reg,rownum r "
			 				+ "from (select * from groups where " + sel + " like '%" + search + "%'  order by group_num desc)) where r>=? and r<=?";
						
					}
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
					
					rs = pstmt.executeQuery();
					GroupDTO group;
					if(rs.next()) {
						groupList=new ArrayList();
						do {
							group = new GroupDTO();
							group.setGroup_num(rs.getInt("group_num"));
							group.setUserID(rs.getString("userID"));
							group.setGroup_title(rs.getString("group_title"));
							group.setCity(rs.getString("city"));
							group.setLocation(rs.getString("location"));
							group.setGroup_content(rs.getString("group_content"));
							group.setGroup_img(rs.getString("group_img"));
							group.setGroup_reg(rs.getTimestamp("group_reg"));
							
							groupList.add(group);
						}while(rs.next());
					}	
					
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
					if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
					if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
				}
				return groupList;
			}
	
			// 그룹 좋아요 가져오기 		
			public GroupDTO getLikeGroup(int num) {
			    Connection conn=null;
			    PreparedStatement pstmt=null;
			    ResultSet rs = null;
			    GroupDTO dto = null;
		    
		    try {
		       conn=getConnection();
		       String sql = "select r, group_num, c from (select rownum r, group_num, c "
		             + "from (select group_num, count(*) c from grouplikes group by group_num order by c desc)) "
		             + "where r = ?";
		       pstmt = conn.prepareStatement(sql);
		       pstmt.setInt(1, num);
		       rs = pstmt.executeQuery();
		       
		       if(rs.next()) {
		          int groupNum = rs.getInt("group_num");
		          
		          sql="select * from groups where group_num=?";
		          pstmt = conn.prepareStatement(sql);
		          pstmt.setInt(1, groupNum);
		          rs = pstmt.executeQuery();
		          
		          if(rs.next()) {
		             dto = new GroupDTO();
		             dto.setGroup_num(groupNum);
		             dto.setUserID(rs.getString("userid"));
		             dto.setGroup_title(rs.getString("group_title"));
		             dto.setCity(rs.getString("city"));
		             dto.setLocation(rs.getString("location"));
		             dto.setGroup_content(rs.getString("group_content"));
		             dto.setGroup_img(rs.getString("group_img"));
		             dto.setGroup_reg(rs.getTimestamp("group_reg"));
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
						
			//소모임 주최자 찾기
			public String getGroupCreator(int group_num) {
				String creator = null;
				Connection conn=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				
				try {
					conn=getConnection();
					String sql="select userID from groups where group_num = ?";
					pstmt=conn.prepareStatement(sql);
					pstmt.setInt(1, group_num);
					rs=pstmt.executeQuery();
					if(rs.next()) {
						creator = rs.getString(1);
					}
					
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					if(rs !=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
					if(pstmt !=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
					if(conn !=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
					}
					return creator;
				}
		}
			


	
	
	
	
	
	
	

	
	
	
	

