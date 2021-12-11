<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
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
%>
<jsp:useBean id="dto" class="ecopang.model.EventCommentDTO"/>
<jsp:setProperty property="*" name="dto" />
<%
 	String eve_comment= request.getParameter("eve_comment");
	int eve_num = Integer.parseInt(request.getParameter("eve_num"));
	EventCommentDAO dao = new EventCommentDAO();
	UsersDAO udao = new UsersDAO();
	UsersDTO udto = new UsersDTO();
	udto = udao.getUser((String)session.getAttribute("memId"));
	dto.setEve_comment(eve_comment);
	dto.setEve_num(eve_num);
	dto.setUserID((String)session.getAttribute("memId"));
	dto.setNickname(udto.getNickname());
	dao.insertEventComment(dto);
	System.out.println(dto);
	response.sendRedirect("eventContent.jsp?eve_num="+ eve_num);
%>
<body>

</body>
</html>