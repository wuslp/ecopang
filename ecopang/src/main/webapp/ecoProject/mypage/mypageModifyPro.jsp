<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>mypageModifyPro</title>
</head>
<% if(session.getAttribute("memId") == null){ %>
   <script>
      alert("로그인해주세요.");
      window.location="/ecopang/ecoProject/main/loginForm.jsp";
   </script>
<%} else{
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="dto" class="ecopang.model.UsersDTO" />
<%
	// 넘어오는 데이터 : 별명, 프로필사진, 생년월일, 관심지역, 비밀번호 확인란
	String path = request.getRealPath("ecoProject/imgs");// 파일경로
	int max = 1024*1024*5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	// id값 안넘어와서 session에서 뽑기
	String id = (String)session.getAttribute("memId");
	dto.setUserID(id);

	dto.setNickname(mr.getParameter("nickname"));
	dto.setBirth(mr.getParameter("birth"));
	dto.setUser_city1(mr.getParameter("user_city1"));
	dto.setUser_district1(mr.getParameter("user_district1"));
	dto.setUser_city2(mr.getParameter("user_city2"));
	dto.setUser_district2(mr.getParameter("user_district2"));
	dto.setUser_city3(mr.getParameter("user_city3"));
	dto.setUser_district3(mr.getParameter("user_district3"));
	
	dto.setPw(mr.getParameter("pwch"));

	if(mr.getFilesystemName("user_img") != null){//프사변경있을때
		// 기존 프사 삭제
		UsersDAO dao = new UsersDAO();
		String photo = dao.getUser_img(id);
		String path1 = request.getRealPath("imgs");
		path1 += "\\" + photo;
		// System.out.println(path1);
		File f = new File(path1);
		f.delete();
		
		dto.setUser_img(mr.getFilesystemName("user_img"));
	}else{ // 프사변경 없으면
		if(mr.getParameter("exPhoto").equals("null") || mr.getParameter("exPhoto").equals("")){
			dto.setUser_img(null);
		}else{
			dto.setUser_img(mr.getParameter("exPhoto"));// 기존db저장된 이름으로 다시 dto추가
		}
	}
	
	UsersDAO dao = new UsersDAO();
	// updateUser == 회원정보수정
	int result = dao.updateUser(dto);
	
	if(result == 1){%>
		<script >
			alert("회원 정보 수정 완료");
			// 회원정보 수정시 mypage 가게 만들어야함
			window.location.href="mypageModifyForm.jsp"
		</script>
	<% }else{ %>
		<script >
			alert("비밀번호 확인 후 다시 시도해보세요.");
			history.go(-1);
		</script>
<% } %>
<body>
</body>
<%}%>
</html>