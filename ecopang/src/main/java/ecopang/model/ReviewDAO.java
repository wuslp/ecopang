package ecopang.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class ReviewDAO {

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
			return ds.getConnection();
	}

	//reviewWritePro
	//리뷰 작성글 insert
	public void insertReview(ReviewDTO reviews) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count =0;
		
		try {
			conn=getConnection();
			String sql="insert into reviews values(reviews_seq.nextval, ?, ?, ?, ?, ?, ?)";
			//"insert into reviews values(reviews_seq.nextVal,?,?,?,?,?,?,?)";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, reviews.getGroup_num());
			pstmt.setString(2, reviews.getUserID());
			pstmt.setString(3, reviews.getRev_content());
			pstmt.setString(4, reviews.getRev_img());//
			pstmt.setTimestamp(5, reviews.getRev_reg());
			pstmt.setInt(6, reviews.getLikesCount());
			count = pstmt.executeUpdate();
					
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try{rs.close();}catch(Exception e){e.printStackTrace();}
			if(pstmt != null) try{pstmt.close();}catch(Exception e){e.printStackTrace();}
			if(conn != null) try{conn.close();}catch(Exception e){e.printStackTrace();}
		}
		
	}
	
	
	//reviewAll
	//리뷰 개수 가져오기
	public int getRevCount(int group_num) {
		Connection conn = null;
		PreparedStatement pstmt =null;
		int revCount =0;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql="select count(*) from reviews where group_num =?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				revCount = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return revCount;
	}
	
	//1-2.페이지 범위만큼 가져오기
	
	public List getRevArticles(int start, int end, int group_num) {//1~4개 ,기본로딩이 최신순
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List revList = null;
		
		try {
			conn = getConnection();
			String sql ="select A.*, r from (select reviews.*, rownum r from reviews where group_num = ? order by rev_reg desc)A where r >= ? and r <= ?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
		
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				revList = new ArrayList();//결과가 있으면 list 객체 생성해서 준비
				ReviewDTO revdto = null;
				do {
					revdto = new ReviewDTO();//반복할 때 마다 ReviewDTO에 다시 담는것.
					//do 밖에 생성하면 안됨
					revdto.setGroup_num(rs.getInt("group_num"));
					revdto.setRev_num(rs.getInt("rev_num"));
					revdto.setUserID(rs.getString("userId"));
					revdto.setRev_content(rs.getString("rev_content"));
					revdto.setRev_img(rs.getString("rev_img"));
					revdto.setRev_reg(rs.getTimestamp("rev_reg"));
					revdto.setLikesCount(rs.getInt("likesCount"));
					
					revList.add(revdto);
				}while(rs.next());	
			}
			
		}catch(Exception e ) {
			e.printStackTrace();
		}finally{
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		} 
		return revList;
	}
	
	
	
	//작성자 회원 정보 담기
	//	->후기글에서 ,그글 작성자 
	//		-> users 테이블 
	//			->review 테이블
	
	public UsersDTO getUserInfo(int rev_num) {
		Connection conn = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		UsersDTO usersdto = null;
		
		try{
			conn = getConnection();
			String sql="select B.* from reviews A, users B where (A.userID = B.userID) and A.rev_num=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, rev_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				usersdto = new UsersDTO();//18ro
				usersdto.setUserID(rs.getString("userID"));
				usersdto.setPw(rs.getString("pw"));
				usersdto.setName(rs.getString("name"));
				usersdto.setNickname(rs.getString("nickname"));
				usersdto.setUser_img(rs.getString("user_img"));//5
				usersdto.setBirth(rs.getString("birth"));
				usersdto.setUser_city1(rs.getString("user_city1"));
				usersdto.setUser_district1(rs.getString("user_district1"));
				usersdto.setUser_city2(rs.getString("user_city2"));
				usersdto.setUser_district2(rs.getString("user_district2"));//10
				usersdto.setUser_city3(rs.getString("user_city3"));
				usersdto.setUser_district3(rs.getString("user_district3"));
				usersdto.setUser_level(rs.getInt("user_level"));
				usersdto.setReportCount(rs.getInt("reportCount"));
				usersdto.setWarning(rs.getInt("warning"));//15
				usersdto.setDel_reason(rs.getString("del_reason"));
				usersdto.setComplaints(rs.getString("complaints"));
				usersdto.setUser_state(rs.getString("user_state"));//18개 
				
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return usersdto;
	}
	
	//revewAll
	//작성자 , 내용 검색 가져오기
	//1-1list 검색한 글 갯수 가져오기
	public int getSearchRevCount(String revSel, String revSearch, int group_num) {
		int revCount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn= getConnection();
			String sql = "select count(*) from reviews where "+ revSel +" like '%" + revSearch + "%' and group_num = ?";
			//select count (*) from reviews where userID like '%abc%';
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			rs = pstmt.executeQuery();
						
			if(rs.next()) {
				revCount = rs.getInt(1);//count(*) 은 결과를 숫자로 가져오며,컬럼명 대신에 컬럼번호1로 꺼내기 	
			}
			
		}catch(Exception e ) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return revCount;
	}
	
	
	//1-2 총 글 가져오기
	//list 검색한 글들 가져오기 메서드
	public List getSearchArticles(int startRow, int endRow, String revSel, String revSearch, int group_num, String sort) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List revList = null;
		
		try {
			if(sort.equals("1")) {
				sort = "rev_reg desc";
			} else {
				sort = "likescount desc";
			}
			
			conn = getConnection();
			String sql = "select * , r from (select reviews.*, rownum r from reviews where "+revSel+" like '%" + revSearch + "%') where r>=? and r<=?";
			sql="select A.* , r from (select reviews.*, rownum r from reviews where "+revSel+" like '%"+revSearch+"%' and group_num = ? order by " + sort + ")A where r>=? and r<=?";
			//select * from reviews where userID like '%test%' order by rev_reg desc;//기본로딩 최신순으로 
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			revList = new ArrayList();//결과가 있으면 list 객체 생성해서 준비
			ReviewDTO searchArticle = null;
			if(rs.next()) {
				do {//if문에서 rs.next() 실행되어서 커서가 내려가 버렸으니 do-while로 먼저 데이터 꺼내게 하기
					searchArticle = new ReviewDTO();
					searchArticle.setGroup_num(rs.getInt("group_num"));
					searchArticle.setRev_num(rs.getInt("rev_num"));
					searchArticle.setUserID(rs.getString("userId"));
					searchArticle.setRev_content(rs.getString("rev_content"));
					searchArticle.setRev_img(rs.getString("rev_img"));
					searchArticle.setRev_reg(rs.getTimestamp("rev_reg"));
					searchArticle.setLikesCount(rs.getInt("likesCount"));
					
					revList.add(searchArticle);//리스트에 추가
					
				}while(rs.next());	
			}
			
		}catch(Exception e ) {
			e.printStackTrace();
		}finally{
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return revList;
	}
	
	
	//사진 있는 후기는 총 몇개일까?
	public int getRevPhoto(String revSel, String revSearch, int group_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int revPhoto =0;
		
		try {
			conn = getConnection();
			String sql="select count(*) from reviews where rev_img is not null and (group_num = ? and " + revSel + " like '%" + revSearch + "%')";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			rs =pstmt.executeQuery();
			
			if(rs.next()) {
				revPhoto = rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return revPhoto;
	}
	
	//
	//사진후기를 페이지 범위만큼 가져오기
	
	public List getRevPho(int start, int end, String revSel, String revSearch, int group_num, String sort) {//1~3
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List revList = null;
		
		try {
			if(sort.equals("1")) {
				sort = "rev_reg desc";
			} else {
				sort = "likescount desc";
			}
			conn = getConnection();
			String sql="select A.*, r from (select reviews.*, rownum r from reviews where (group_num = ? and rev_img is not null) and " + revSel + " like '%" + revSearch + "%' order by " + sort + ")A where r>=? and r<=?";
			
			//기본 최신순
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, group_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
		
			rs = pstmt.executeQuery();
			if(rs.next()) {
				revList = new ArrayList();//결과가 있으면 list 객체 생성해서 준비
				ReviewDTO revdto = null;
				do {
					revdto = new ReviewDTO();
					//
					revdto.setGroup_num(rs.getInt("group_num"));
					revdto.setRev_num(rs.getInt("rev_num"));
					revdto.setUserID(rs.getString("userId"));
					revdto.setRev_content(rs.getString("rev_content"));
					revdto.setRev_img(rs.getString("rev_img"));
					revdto.setRev_reg(rs.getTimestamp("rev_reg"));
					revdto.setLikesCount(rs.getInt("likesCount"));
					
					revList.add(revdto);
				}while(rs.next());	
			}
			
		}catch(Exception e ) {
			e.printStackTrace();
		}finally{
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return revList;
	}
	
	
	//2-1 사진글에서만 서치 개수
	//작성자 , 내용 검색 가져오기
	//검색한 글 갯수 가져오기
	public int getSearchPRevCount(String phoRevSel, String phoRevSearch) {
		int phoRevCount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn= getConnection();
			String sql = "select count(*) from reviews where "+ phoRevSel +" like '%" + phoRevSearch + "%' and rev_img is not null";
			//select count (*) from board where userID like '%test3@nate.com%';
			pstmt= conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				phoRevCount = rs.getInt(1);//count(*) 은 결과를 숫자로 가져오며,컬럼명 대신에 컬럼번호1로 꺼내기 
				System.out.println(phoRevCount);
			}
		}catch(Exception e ) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return phoRevCount;
	}
	
	//2-2 검색한 사진글 가져오기
	//list 검색한 글들 가져오기 메서드
	public List getSearchPArticles(int startRow, int endRow, String phoRevSel, String phoRevSearch) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List revList = null;
		
		try {
			conn = getConnection();
			String sql ="select A.*, r from (select reviews.*, rownum r from reviews where "+phoRevSel+" like '%"+phoRevSearch+"%' and rev_img is not null order by rev_reg desc)A where r>=? and r<=?";
			//select * from reviews where userID like '%test%';
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			revList = new ArrayList();//list 객체 생성해서 준비
			ReviewDTO searchArticle = null;
			if(rs.next()) {
				do {//
					searchArticle = new ReviewDTO();
					searchArticle.setGroup_num(rs.getInt("group_num"));
					searchArticle.setRev_num(rs.getInt("rev_num"));
					searchArticle.setUserID(rs.getString("userId"));
					searchArticle.setRev_content(rs.getString("rev_content"));
					searchArticle.setRev_img(rs.getString("rev_img"));
					searchArticle.setRev_reg(rs.getTimestamp("rev_reg"));
					searchArticle.setLikesCount(rs.getInt("likesCount"));
					
					revList.add(searchArticle);//리스트에 추가
					
				}while(rs.next());	
			}
		}catch(Exception e ) {
			e.printStackTrace();
		}finally{
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}
		}
		return revList;
	}
	//테스트용 테테테테테테스트용 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
	public List getTestList(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List phoList  = null;
		
		try {
		conn = getConnection();
		String sql="select * from reviews where rev_img is not null ";
		pstmt = conn.prepareStatement(sql);
		rs =pstmt.executeQuery();
		
		if(rs.next()) {
			phoList = new ArrayList();
			do {
				ReviewDTO phodto = new ReviewDTO();
				phodto.setRev_num(rs.getInt("rev_num"));;
				phodto.setGroup_num(rs.getInt("group_num"));
				phodto.setUserID(rs.getString("userID"));
				phodto.setRev_content(rs.getString("rev_content"));
				phodto.setRev_img(rs.getString("rev_img"));
				phodto.setRev_reg(rs.getTimestamp("rev_reg"));
				phodto.setLikesCount(rs.getInt("likesCount"));
				phoList.add(phodto);
				
			}while(rs.next());
		}
		
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}			
		}
		return phoList;
	}
	
	//최신순으로 정렬 해서 가져오기 시켜 
	public List getNewRev(int group_num) {

			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List laList  = null;
			
			try {
			conn = getConnection();
			String sql="select * from reviews order by rev_reg desc";
			pstmt = conn.prepareStatement(sql);
			rs =pstmt.executeQuery();
			
			laList = new ArrayList();
			ReviewDTO ladto = null;
			if(rs.next()) {
				do {
					ladto = new ReviewDTO();
					ladto.setRev_num(rs.getInt("rev_num"));;
					ladto.setGroup_num(rs.getInt("group_num"));
					ladto.setUserID(rs.getString("userID"));
					ladto.setRev_content(rs.getString("rev_content"));
					ladto.setRev_img(rs.getString("rev_img"));
					ladto.setRev_reg(rs.getTimestamp("rev_reg"));
					ladto.setLikesCount(rs.getInt("likesCount"));
					laList.add(ladto);
					
				}while(rs.next());
			}
			
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}			
			}
			return laList;
	}
	
	// 인기순 정렬 
	public List getBestRev(int start, int end) {
		List rev = null; 
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			List<Integer> nums = new ArrayList<>();  // 인기글순으로 정렬된 그 리뷰 번호
			List<Integer> counts = new ArrayList<>(); // 카운트수 ,좋아요수
			conn = getConnection();
			String sql = "select rev_num, count(*) from reviewlikes group by rev_num order by 2 desc";
			//리뷰 좋아요 많은순으로 rev_num,count수 뽑아옴 
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				nums.add(rs.getInt(1));//rev_num 번호
				counts.add(rs.getInt(2));//그 리뷰의 좋아요 받은 수
			}
			if(nums.size() != 0) {
				rev = new ArrayList();
			}
			for(int i = 0; i < nums.size(); i++) {
				ReviewDTO dto = new ReviewDTO();
				sql = "select A.*, r from (select reviews.*,rownum r from reviews where rev_num = ?)A where r>=? and r<= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, nums.get(i));
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
				
				rs = pstmt.executeQuery();
				if(rs.next()) {
					dto.setRev_num(rs.getInt("rev_num"));
					dto.setGroup_num(rs.getInt("group_num"));
					dto.setRev_content(rs.getString("rev_content"));
					dto.setRev_img(rs.getString("rev_img"));
					dto.setUserID(rs.getString("userID"));
					dto.setLikesCount(counts.get(i));
					rev.add(dto); // dto add
				}
				
			}
			
		}catch(Exception e ) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e ) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e ) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e ) {e.printStackTrace();}			
		}
		return rev;
	}
	
}
