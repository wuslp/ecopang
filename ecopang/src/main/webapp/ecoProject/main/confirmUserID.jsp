<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>ID 중복확인</title>
<%
	String userID = request.getParameter("userID");
	UsersDAO dao = new UsersDAO();
	boolean result = dao.confirmUserID(userID); 
%>
<script>
	// 유효성 검사
	function check(){
		var inputs = document.inputForm;
		console.log(inputs);
		
		if(!inputs.userID.value){
			alert("아이디를 입력하세요");
			return false;
		}
	}
</script>
<body>
	<br />
	<% if(result){  // id 존재 %>
		<table>
			<tr>
				<td><%=userID %>, 이미 사용중인 아이디 입니다. </td>
			</tr>
		</table>
		<br />
		<form action="confirmUserID.jsp" method="post" name="inputForm" onsubmit="return check()">
			<table>
				<tr>
					<td> 다른 아이디를 선택하세요. <br />
						<input type="text" name="userID" />
						<input type="submit" value="ID중복확인" /> 
					</td>
				</tr>
			</table>
		</form>
	<%}else{ // id 존재x %>
		<table>
			<tr>
				<td>입력하신 <%=userID %>는 사용가능한 아이디 입니다. <br />
					<input type="button" value="사용하기" onclick="setUserID()"/>
				</td>
			</tr>
		</table>
	<%} %>
	
	<script>
		function setUserID(){
			// 중복체크결과 idCheck 값 전달
			opener.document.inputForm.idUncheck.value = "idCheck";
			// 회원가입 화면 id입력란 값 전달
			opener.document.inputForm.userID.value = "<%=userID%>";  
			self.close(); // 팝업창 닫기
		}
	</script>
	
</body>
</html>