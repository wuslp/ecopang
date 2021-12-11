<%@page import="java.sql.Timestamp"%>
<%@page import="ecopang.model.InfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>infoWritePro/공지사항작성프로</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 넘어오는 데이터 : 제목info_title, 내용info_content
	필요 : 작성날짜info_reg, 게시글 번호info_num -->
<jsp:useBean id="dto" class="ecopang.model.InfoDTO"/>
<jsp:setProperty property="*" name="dto"/>
<%
	// 넘어오는 데이터 뺀 나머지
	dto.setInfo_reg(new Timestamp(System.currentTimeMillis()));

	// dto 주고 디비에 저장시키기
	InfoDAO dao = new InfoDAO();
	dao.insertInfo(dto); 
	
	// 게시판 목록으로 이동
	response.sendRedirect("infoList.jsp");
%>
<body>

</body>
</html>