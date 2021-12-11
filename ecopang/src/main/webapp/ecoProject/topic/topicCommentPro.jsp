<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.TopicCommentDTO"%>
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
	request.setCharacterEncoding("UTF-8");

	TopicDAO dao = new TopicDAO();
	UsersDAO udao = new UsersDAO();
	UsersDTO udto=udao.getUser((String)session.getAttribute("memId"));
	TopicCommentDTO dto = new TopicCommentDTO();
	int select = Integer.parseInt(request.getParameter("select"));
	int num = Integer.parseInt(request.getParameter("tpc_num"));
	dto.setTpc_num(num);
	dto.setUserID((String)session.getAttribute("memId"));
	dto.setNickname(udto.getNickname()); 
	dto.setTpc_com_content(request.getParameter("topicComment"));
	
	
	if(select == 1) {
		dao.insertTopicComment(dto); %>	
		<script>
			window.location=document.referrer;
		</script>		
<%	} else if(select == 0) {
		dao.deleteTopicComment(num); %>
		<script>
			window.location=document.referrer;
		</script>	
<%	} 
%>	
<body>

</body>
</html>