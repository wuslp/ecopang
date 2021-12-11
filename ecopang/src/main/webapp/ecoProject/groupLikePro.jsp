<%@page import="ecopang.model.GroupLike"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
</script>


</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="like" class="ecopang.model.GroupLike" />
<jsp:setProperty property="*" name="like" />

<%
	String userID = request.getParameter("userID");
	int groupNum = Integer.parseInt(request.getParameter("groupNum"));
	GroupLike grouplike = new GroupLike();
	grouplike.groupLikeClick(userID, groupNum);
	response.sendRedirect("group.jsp");
%>
<body>

</body>
</html>