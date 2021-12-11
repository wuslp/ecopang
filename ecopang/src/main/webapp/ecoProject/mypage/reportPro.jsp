<%@page import="ecopang.model.ReportsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>reportPro</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 넘어오는데이터 
	form에서 받은건 카테고리, 고유번호, 신고대상아이디
	pro에서 받은건 신고사유, 상세내용
	신고한사람id는 session에서 꺼내기
	유저테이블의 신고횟수 변경해야함 : usersDTO 있어야해 -->
<jsp:useBean id="dto" class="ecopang.model.ReportsDTO" />
<%
	dto.setCategory(request.getParameter("category"));
	dto.setNum(Integer.parseInt(request.getParameter("num")));
	dto.setUserID(request.getParameter("userID"));
	dto.setReporterID((String)session.getAttribute("memId"));
	dto.setRep_reason(request.getParameter("rep_reason"));
	dto.setRep_content(request.getParameter("rep_content"));
	
	ReportsDAO dao = new ReportsDAO();
	// insertReport == 신고하기 디비 저장
	dao.insertReport(dto);
%>
<body>
		<script type="text/javascript">
			alert("신고가 완료되었습니다.");
			opener.history.go(-1);
			self.close();
		</script>
</body>
</html>