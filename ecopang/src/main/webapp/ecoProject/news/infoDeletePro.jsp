<%@page import="ecopang.model.InfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>infoDeletePro/공지사항삭제</title>
</head>
<%
	if (session.getAttribute("memId") == null || !session.getAttribute("memId").equals("admin")) {
		int info_num = Integer.parseInt(request.getParameter("info_num"));
%>
	<script>
		alert("공지사항을 삭제할 자격이 없습니다");
		window.location.href="infoContent.jsp?info_num=<%=info_num%>";
	</script>
<%} else {
	int info_num = Integer.parseInt(request.getParameter("info_num"));
	
	InfoDAO dao = new InfoDAO();
	dao.deleteInfo(info_num); 
%>
<script>
	// 페이징처리
	alert("삭제완료");
	window.location.href="infoList.jsp"; 
</script>
<%} %>
<body>

</body>
</html>