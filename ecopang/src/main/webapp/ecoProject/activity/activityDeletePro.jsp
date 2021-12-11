<%@page import="ecopang.model.ActDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
//	int act_num=Integer.parseInt(request.getParameter("act_num"));
//	String pw = request.getParameter("userId");
%>

<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="activity" class="ecopang.model.ActDTO"/>
<jsp:setProperty property="*" name="activity"/>
<%

	ActDAO dao = new ActDAO();
	int group_num = Integer.parseInt(request.getParameter("group_num"));
	int act_num = Integer.parseInt(request.getParameter("act_num"));
	int res = dao.deleteActivity(act_num);
	if(res == 1) { %>
	<script>
		alert("삭제되었습니다.");
		window.location="/ecopang/ecoProject/group/groupContent.jsp?group_num=<%= group_num%>";
	</script>
	<% } else { %>
	<script>
		alert("삭제를 실패했습니다.");
		window.location="/ecopang/ecoProject/group/groupContent.jsp?group_num=<%= group_num%>";
	</script>
	<% } %>
<body>
</body>
</html>