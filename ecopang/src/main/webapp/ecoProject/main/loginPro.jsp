<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginPro</title>
</head>
<% request.setCharacterEncoding("UTF-8");
	// loginForm 에서 넘어옴
	String userID = request.getParameter("userID");
	String pw = request.getParameter("pw");
	String auto = request.getParameter("auto");
	
	// 저장된 쿠키가 있어 넘어옴
	Cookie [] coos = request.getCookies();
	if(coos != null){
		for(Cookie c : coos){
			if(c.getName().equals("autoId")) userID = c.getValue();
			if(c.getName().equals("autoPw")) pw = c.getValue();
			if(c.getName().equals("autoCh")) auto = c.getValue();
		}
	}
	
	System.out.println("로그인프로페이지 userID : " + userID);
	System.out.println("pw : " + pw);
	System.out.println("auto : " + auto);
	
	UsersDAO dao = new UsersDAO(); 
	String user_state = dao.getUser_state(userID);
	
	if(user_state.equals("활동")){
		boolean res = dao.idPwCheck(userID, pw); 
		if(res){// id, pw 일치 -> 로그인 처리
			if(auto != null){ // 자동로그인 체크, 로그인 시도
				// 쿠키 생성
				Cookie c1 = new Cookie("autoId", userID);
				Cookie c2 = new Cookie("autoPw", pw);
				Cookie c3 = new Cookie("autoCh", auto);
				c1.setPath("/");
				c2.setPath("/");
				c3.setPath("/");
				c1.setMaxAge(60*60*24); // 24시간 // 쿠키기간 갱신
				c2.setMaxAge(60*60*24); // 24시간
				c3.setMaxAge(60*60*24); // 24시간
				response.addCookie(c1);
				response.addCookie(c2);
				response.addCookie(c3);
			}
		
		// 세션ID = memId
			session.setAttribute("memId", userID); // 세션에 속성추가! -> 로그인 처리함
			response.sendRedirect("main.jsp"); // main으로 이동

			for(Cookie c : coos){
				System.out.println(c.getName() +" : " +c.getValue());
			}
		}else{ %>
			<script>
				alert("id 또는 pw가 일치하지 않습니다. 다시 시도해주세요.");
				history.go(-1);
			</script>	
		<%}
	// 탈퇴계정 alert
	}else if(user_state.equals("탈퇴")){%>
		<script>
			alert("탈퇴한 회원입니다.");
			history.go(-1);
		</script>
	<%
	// 강퇴계정 alert
	}else if(user_state.equals("강퇴")){%>
		<script>
			alert("부적절한행동으로 인해 활동이 중단된 계정입니다. 문의 : 하단의 이메일...");
			history.go(-1);
		</script>
<%}%>
<body>

</body>
</html>