<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="ecopang.model.ActDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="activity" class="ecopang.model.ActDTO"/>
<jsp:setProperty property="*" name="activity"/>
<%
	ActDAO dao = new ActDAO(); 
	int res = dao.updateActivity(activity);
	if(res == 1) { %>
	<script>
		alert("활동이 작성되었습니다.");
		self.close();
		</script>
	<% } else { %>
	<script>
		alert("작성을 실패했습니다.");
		self.close();
	</script>
	<% } %>
	

<body>

</body>
</html>