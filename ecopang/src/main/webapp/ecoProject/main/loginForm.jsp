<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link href="/ecopang/ecoProject/popupstyle.css" rel="stylesheet" type="text/css" >

<head>
	<meta charset="UTF-8">
	<title>loginPage</title>
	
</head>
<%
	int pageNum = 1;
	if(request.getParameter("pageNum") != null)
		pageNum = Integer.parseInt(request.getParameter("pageNum"));
		
%>
<body>
	<div>
		<div class="loginInput">
		    <div class="loginTitle">
		        로그인
		    </div>
			<form action="loginPro.jsp" method="post">
				<table class="table1">
					<tr>
						<td><img src="/ecopang/ecoProject/imgs/login_id.png" /></td>
						<td><input type="text" name="userID"/></td>
					</tr>
					<tr>
						<td><img src="/ecopang/ecoProject/imgs/login_pw.png" /></td>
						<td><input type="password" name="pw"/></td>
					</tr>
                </table>
                <table class="table2">
					<tr>
						<td class="checkbox">
							자동 로그인
						</td>
						<td>
						    <input type="checkbox" name="auto" value="1" /> 
						</td>
					</tr>
                </table>
                <table class="loginBtn">
					<tr>
						<td colspan="2">
							<input type="submit" value="로그인" />
							<input type="button" value="회원가입" onclick="window.location='signupForm.jsp'" />
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>