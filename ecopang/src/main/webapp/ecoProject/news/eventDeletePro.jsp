<%@page import="ecopang.model.EventDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	int eve_num = Integer.parseInt(request.getParameter("eve_num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	EventDAO dao = new EventDAO();
	dao.deleteEvent(eve_num);
%>
<script>
	alert("이벤트 삭제가 완료되었습니다.")
	window.location='eventList.jsp?pageNum=<%=pageNum%>';
</script>
<body>

</body>
</html>