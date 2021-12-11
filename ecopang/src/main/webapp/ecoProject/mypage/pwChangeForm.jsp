<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mypageModifyForm</title>
</head>
<% if(session.getAttribute("memId") == null){ %>
	<script>
		alert("로그인해주세요.");
		//self.close();
		window.location="/ecopang/ecoProject/main/loginForm.jsp";
	</script>
<%} else{
	String userID = (String)session.getAttribute("memId");
%>
<script>
	// 유효성 검사 : 다 작성했는지
	function check(){
		var inputs = document.inputForm;
		console.log(inputs);
		
		if(!inputs.pw.value){
			alert("현재 비밀번호를 입력하세요");
			return false;
		}
		if(!inputs.newPw.value){
			alert("새 비밀번호를 입력하세요");
			return false;
		}
		if(!inputs.newPwch.value){
			alert("새 비밀번호 확인란을 입력하세요");
			return false;
		}
		
		// 새비밀번호 == 새비밀번호 확인란
		if(inputs.newPw.value != inputs.newPwch.value){
			alert("비밀번호를 동일하게 입력하세요");
			return false;
		}
	}
	// 취소버튼 누를때 닫히게
	function cancel(){
		self.close();
	}
</script>
<body>
	<div>
		<form action="pwChangePro.jsp" method="post" name="inputForm" onsubmit="return check()">
		<table>
			<tr><td> 비밀번호 변경 </td></tr>
			<tr>
				<td>현재 비밀번호</td>
				<td><input type="password" name="pw" /></td>
			</tr>
			<tr>
				<td>새 비밀번호</td>
				<td><input type="password" name="newPw" /></td>
			</tr>
			<tr>
				<td>새 비밀번호 확인</td>
				<td><input type="password" name="newPwch" /></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정"/>
					<input type="button" value="취소" onclick="cancel()"/>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
<%} %>
</html>