<%@page import="ecopang.model.InfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>infoModifyPro/공지사항 수정 프로</title>
</head>
<%
	if (session.getAttribute("memId") == null || !session.getAttribute("memId").equals("admin")) {
		int info_num = Integer.parseInt(request.getParameter("info_num"));
%>
<script>
		alert("공지사항을 수정할 자격이 없습니다");
		window.location.href="infoContent.jsp?info_num=<%=info_num%>";
</script>
<%} else {
 request.setCharacterEncoding("UTF-8"); %>
<!-- 넘어오는 데이터 : 제목info_title, 내용info_content, 게시글 번호info_num -->
<jsp:useBean id="dto" class="ecopang.model.InfoDTO"/>
<jsp:setProperty property="*" name="dto"/>
<%
	InfoDAO dao = new InfoDAO();
	dao.updateInfo(dto); 
%>
<script>
	// 페이징처리
	alert("수정완료");
	window.location.href="adminEventInfo.jsp";
</script>
<%} %>
<body>

</body>
</html>