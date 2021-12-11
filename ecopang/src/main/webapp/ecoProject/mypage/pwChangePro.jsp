<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>pwChangePro</title>
</head>
<% if(session.getAttribute("memId") == null){ %>
   <script>
      alert("로그인해주세요.");
      //self.close();
      window.location="/ecopang/ecoProject/main/loginForm.jsp";
   </script>
<%} else{
	String userID = (String)session.getAttribute("memId");
%>
<jsp:useBean id="dto" class="ecopang.model.UsersDTO" />
<%
	// 현재 비번, 새 비번 받아옴
	String pw = request.getParameter("pw");
	String newPw = request.getParameter("newPw");
	
	UsersDAO dao = new UsersDAO();
	// pwChange == 비밀번호 변경
	int res = dao.pwChange(userID, pw, newPw);  
	
	if(res == 1){%>
	<script >
		alert("비밀번호 수정 완료");
		self.close();
	</script>
	<% }else{ %>
	<script >
		alert("현재비밀번호가 일치하지 않습니다. 확인 후 다시 시도해보세요.");
		history.go(-1);
	</script>
	<%} %>
<body>
</body>
<%} %>
</html>