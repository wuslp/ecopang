<%@page import="ecopang.model.EventCommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int eve_num = Integer.parseInt(request.getParameter("eve_num"));
	int eve_com_num = Integer.parseInt(request.getParameter("eve_com_num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	EventCommentDAO dao = new EventCommentDAO();
	dao.deleteTopicComment(eve_com_num);
%>
<body>
	<script>
	alert("댓글 삭제 완료되었습니다.")
	window.location='eventContent.jsp?eve_num=<%=eve_num%>&pageNum=<%=pageNum%>';
</script>
</body>
</html>