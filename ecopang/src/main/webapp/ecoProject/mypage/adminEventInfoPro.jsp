<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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

	// 이벤트, 공지사항 상황 나누기 이런식으로 if로 값이 있을때 받아주는게 좋아요 아니면 null포인트 에러 날수 있음
	int check = 0;
	if(request.getParameter("check") != null) {
		check = Integer.parseInt(request.getParameter("check"));
	}

	UsersDAO dao = new UsersDAO();
	int eve_num = 0;
	int info_num = 0;
	if(check == 1) {
		//이벤트 번호 받아오기
		if(request.getParameter("eve_num") != null) {
			eve_num =  Integer.parseInt(request.getParameter("eve_num"));
			dao.getDelEvent(eve_num);
			response.sendRedirect("adminEventInfo.jsp");
		}
		
	} else if(check == 2) {
		//공지사항 번호 받아오기
		if(request.getParameter("info_num") != null) {
			info_num = Integer.parseInt(request.getParameter("info_num"));
			dao.getDelInfo(info_num);
			response.sendRedirect("adminEventInfo.jsp");
		}
		
	}
	

%>
<body>

</body>
</html>