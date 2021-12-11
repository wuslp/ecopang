<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>signupPro</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto" class="ecopang.model.UsersDTO" />
<% 
	String path = request.getRealPath("ecoProject/imgs");
	System.out.println(path);
	int max = 1024*1024*5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	dto.setUserID(mr.getParameter("userID"));
	dto.setPw(mr.getParameter("pw"));
	dto.setName(mr.getParameter("name"));
	dto.setNickname(mr.getParameter("nickname"));
	dto.setUser_img(mr.getFilesystemName("user_img"));
	dto.setBirth(mr.getParameter("birth"));
	dto.setUser_city1(mr.getParameter("user_city1"));
	dto.setUser_district1(mr.getParameter("user_district1"));
	dto.setUser_city2(mr.getParameter("user_city2"));
	dto.setUser_district2(mr.getParameter("user_district2"));
	dto.setUser_city3(mr.getParameter("user_city3"));
	dto.setUser_district3(mr.getParameter("user_district3"));
	
	UsersDAO dao = new UsersDAO();
	// insertUser == 유저정보 디비 저장
	dao.insertUser(dto);
%>
<%-- <jsp:setProperty property="*" name="dto"/>	--%>
<body>
	<script>
		// 페이징처리
		alert("회원가입이 정상적으로 처리 되었습니다.");
		window.location.href="loginForm.jsp"; // 로그인페이지로 이동
	</script>
</body>
</html>