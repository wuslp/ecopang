<%@page import="ecopang.model.GroupDTO"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>소모임 삭제</title>
</head>
<%
	int group_num = Integer.parseInt(request.getParameter("group_num"));
	int pageNum=Integer.parseInt(request.getParameter("pageNum"));
	
	GroupDAO dao = new GroupDAO();
	dao.deleteGroup(group_num);

%>
<script>
	alert("소모임 삭제가 완료되었습니다.")
	window.location='groupMain.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>';
	
</script>
<body>
		
</body>
	
</html>