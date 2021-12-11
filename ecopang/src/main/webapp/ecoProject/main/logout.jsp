<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>로그아웃</title>
</head>
<%
	// 세션삭제
	session.invalidate(); 
	
	// 쿠키가 있으면 쿠키 삭제
	Cookie[] coos = request.getCookies();
	if(coos != null){
		for(Cookie c : coos){
			if(c.getName().equals("autoId") || c.getName().equals("autoPw") || c.getName().equals("autoCh")){
				c.setMaxAge(0);
				c.setPath("/");
				response.addCookie(c);
				System.out.println("쿠키 저장된거 삭제 됐당");
			}
		}
	}
	response.sendRedirect("main.jsp");
%>
<body>

</body>
</html>