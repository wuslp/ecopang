<%@page import="ecopang.model.ReportsDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고버튼 처리 </title>
</head>
<%
	//세션에서 id뽑아서 id가 관리자것  admin이면 이 페이지 보여주기
	//일반회원 id이면 못 보도록 처리
	
	String userID= "";
	if(session.getAttribute("memId") != null) {
		userID = (String)session.getAttribute("memId");
	}
	System.out.println("75번 관리자 페이지 접속중 아이디 출력 : "+userID);
	if(!userID.equals("admin")){	//임시	%>
		<script>
			alert("관리자 페이지 입니다");
			history.back();
		</script>
<%}%>

<%

	String reUserID = request.getParameter("reUserID");
	int rep_num = Integer.parseInt(request.getParameter("rep_num"));
	String res = request.getParameter("res");

	UsersDAO dao = new UsersDAO();
	ReportsDTO rdao = new ReportsDTO();//신고 dto
	if(res.equals("1")){//넘어가기
		//넘어가는 메서드 usersDAO에 ,매개변수 아이디
		dao.getPassUser(rep_num);
		response.sendRedirect("adminReportList.jsp");
	}else if(res.equals("2")){//경고
		//경고주는 메서드 usersDAO에 ,매개변수 아이디
		dao.getWarnUser(reUserID, rep_num);
		response.sendRedirect("adminReportList.jsp");
	}else{//강제탈퇴
		//탈퇴하는 메서드 usersDAO에 ,매개변수 아이디
		dao.getDropUser(reUserID, rep_num);
		response.sendRedirect("adminReportList.jsp");
	}

%>
<body>

</body>
</html>