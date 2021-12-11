<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>userDeleteForm</title>
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
	// 유효성검사
	function check() {
		var inputs = document.inputForm;
		console.log(inputs);

		if (!inputs.pwch.value) {
			alert("비밀번호를 작성하세요");
			return false;
		}
	}
	// 취소누르면 자동 창 닫기
	function cancel(){
		self.close();
	}
</script>
<body>
<div>
	<div>헤더</div>
	
	<div>
		<form action="userDeletePro.jsp" method="post" name="inputForm" onsubmit="return check()">
			<table>
				<tr>
					<td>탈퇴 사유</td>
				</tr>
				<tr>
					<td>
						<select name="del_reason">
							<option disabled>선택</option>
							<option>탈퇴 후 재가입 희망</option>
							<option>소모임 서비스 불만족</option>
							<option>커뮤니티 서비스 불만족</option>
							<option>서비스 및 고객 지원이 만족스럽지 못함</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>불만 사항 기입(선택)</td>
				</tr>
				<tr>
					<td>
						<textarea rows="10" cols="40" name="complaints"></textarea>
					</td>
				</tr>
				<tr>
					<td>비밀번호 확인</td>
				</tr>
				<tr>
					<td><input type="password" name="pwch" /></td>
				</tr>
				<tr>
					<td>
						<input type="button" value="취소" onclick="cancel()"/>
						<input type="submit" value="탈퇴"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div>푸터</div>
</div>
</body>
<%} %>
</html>