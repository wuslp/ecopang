<%@page import="java.io.File"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>userDeletePro</title>
</head>
<!-- 넘어오는데이터 탈퇴사유, 불만사항기입, 비밀번호확인
	활동상태 변경해야함 -->
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto" class="ecopang.model.UsersDTO" />
<%
	String userID = (String)session.getAttribute("memId");
	String del_reason = request.getParameter("del_reason");
	String complaints = request.getParameter("complaints");
	String pwch = request.getParameter("pwch");
	
	UsersDAO dao = new UsersDAO();
	// 삭제전 사진이름 가져오기
	String photo = dao.getUser_img(userID);
	System.out.println(photo);
	// 파일경로
	String path = request.getRealPath("imgs");
	path += "\\" + photo;
	System.out.println(path);
	
	int res = dao.deleteUser(userID, del_reason, complaints, pwch);
	
	if(res == 1){
		System.out.println("삭제완료");	
		
		// 이미지 파일도 삭제
		File f = new File(path);
		f.delete();
		
		// 세션삭제
		session.invalidate(); 
		// 쿠키가 있으면 쿠키 삭제
		Cookie[] coos = request.getCookies();
		if(coos != null){
			for(Cookie c : coos){
				if(c.getName().equals("autoId") || c.getName().equals("autoPw") || c.getName().equals("autoCh")){
					c.setMaxAge(0);
					response.addCookie(c);
				}
			}
		}
		 // 메인으로 이동
		response.sendRedirect("../main/main.jsp");
	}else{%>
		<script>
			alert("비밀번호가 일치하지 않습니다.");
			history.go(-1);
		</script>
<%	}%>
<body>

</body>
</html>