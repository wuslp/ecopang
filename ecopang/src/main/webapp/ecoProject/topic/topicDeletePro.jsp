<%@page import="ecopang.model.TopicDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	int tpc_num = Integer.parseInt(request.getParameter("tpc_num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	TopicDAO dao = new TopicDAO();
	dao.deleteTopic(tpc_num);
%>
<script>
	alert("게시글 삭제가 완료되었습니다.")
	window.location='topicList.jsp?pageNum=<%=pageNum%>';
</script>
<body>

</body>
</html>