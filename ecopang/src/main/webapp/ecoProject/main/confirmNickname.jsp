<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>별명 중복확인</title>
<%
	request.setCharacterEncoding("UTF-8");
	String nickname = request.getParameter("nickname");
	UsersDAO dao = new UsersDAO();
	boolean result = dao.confirmNickname(nickname); 
%>
<script>
	// 유효성 검사
	function check(){
		var inputs = document.inputForm;
		console.log(inputs);
		
		if(!inputs.nickname.value){
			alert("별명을 입력하세요");
			return false;
		}
	}
</script>
<body>
	<br />
	<% if(result){ %>
		<table>
			<tr>
				<td><%=nickname %>, 이미 사용중인 별명 입니다. </td>
			</tr>
		</table>
		<br />
		<form action="confirmNickname.jsp" method="post" name="inputForm" onsubmit="return check()">
			<table>
				<tr>
					<td> 다른 아이디를 선택하세요. <br />
						<input type="text" name="nickname" />
						<input type="submit" value="별명 중복확인" /> 
					</td>
				</tr>
			</table>
		</form>
	<%}else{ // id 존재x %>
		<table>
			<tr>
				<td>입력하신 <%=nickname %>는 사용가능한 별명 입니다. <br />
					<input type="button" value="사용하기" onclick="setNickname()"/>
				</td>
			</tr>
		</table>
	<%} %>
	
	<script>
		function setNickname(){
			opener.document.inputForm.nicknameUncheck.value = "nicknameCheck";  
			opener.document.inputForm.nickname.value = "<%=nickname%>";  
			self.close();
		}
	</script>
	
</body>
</html>