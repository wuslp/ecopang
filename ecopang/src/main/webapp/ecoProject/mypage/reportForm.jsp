<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.ReportsDTO"%>
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
	<title>reportForm</title>
</head>
<!-- 
신고하기 사용시 복붙하세요
// 새창여는 이벤트
<script>
function report(inputForm) {
	var url = "reportForm.jsp";
	open(
			url,
			"reportForm",
			"toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=500, height=400");
}
</script> 

// 새창여는 function name(report) 추가
// Form name="inputForm" 추가
// 신고누르면 카테고리, 고유번호, 신고대상아이디 자동 넘어와야함...
// hidden 으로 넘겨주세요
<tr>
<td><input type="button" value="신고하기" onclick="report(this.form)" />
	<input type="hidden" name="category" value=""/> // 신고대상 유형(카테고리, 유저, 소모임 등 문자열로)
	<input type="hidden" name="num" value=""/> // 신고대상 고유번호
	<input type="hidden" name="userID" value=""/> // 신고대상아이디
</td>
</tr>
-->
<% if(session.getAttribute("memId") == null){ %>
	<script>
		alert("로그인해주세요.");
		//self.close();
		window.location="/ecopang/ecoProject/main/loginForm.jsp";
	</script>
<%} else{// 로그인되어있을때 
	// 신고한사람아이디
	String reporterID = (String)session.getAttribute("memId");
// 신고누르면 카테고리, 고유번호, 신고대상아이디 가져와야함 주석풀고 사용@@@@@@@
	// 카테고리
	 String category = request.getParameter("category");
	// 글 고유 번호
	 int num = Integer.parseInt(request.getParameter("num"));
	// 신고대상아이디
	 String userID = request.getParameter("userID");

	// 임시..! 사용할땐 밑에 지우고 위에 주석 풀고 사용하기@@@@@@@@@@@@@@@@@@@@@
	/* String category="꿀팁";
	int num = 1;
	String userID ="test@test.com"; */
	
	// 신고당한 유저id 활동상태 뽑아오기
	UsersDAO dao = new UsersDAO();
	String user_state = dao.getUser_state(userID);

	if(user_state.equals("활동")){ // 신고당한 사람의 활동상태 : 활동 (신고가능), 강퇴/탈퇴(신고불가능)
%>
<script>
//유효성검사
function check() {
	var inputs = document.inputForm;
	console.log(inputs);

	if (!inputs.rep_content.value) {
		alert("상세내용을 작성해 주세요");
		return false;
	}
}
// 취소 누를때 자동 창 닫기
function cancel(){
	self.close();
}
</script>
<body>
	<div class="reportForm">
		<form action="reportPro.jsp?category=<%=category%>&num=<%=num%>&userID=<%=userID%>" method="post" name="inputForm" onsubmit="return check()">
			<table class="reportTable">
				<tr>
					<td class="reportMessage">신고 대상</td>
				</tr>
				<tr>
					<td>
						<!-- 신고대상아이디 -->
						<%= userID %>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">신고사유</td>
				</tr>
				<tr>
					<td>
						<select name="rep_reason">
							<option>욕설/음란글</option>
							<option>광고</option>
							<option>사기</option>
							<option>운영자사칭</option>
							<option>개인정보유출</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">상세내용*</td>
				</tr>
				<tr>
					<td>
						<textarea rows="10" cols="40" name="rep_content" class="reportText"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<input type="submit" value="신고하기" class="btn"/>
						<input type="button" value="취소" onclick="cancel()" class="btn"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
<%}// 활동일때 if문 닫음
	// 탈퇴계정확인후 창 닫기
	else if(user_state.equals("탈퇴")){%>
	<script>
		alert("탈퇴한 계정입니다.");
		self.close();
	</script>
<%}// 강퇴계정 확인후 창 닫기
	else if(user_state.equals("강퇴")){%>
	<script>
		alert("부적절한행동으로 인해 활동이 중단된 계정입니다.");
		self.close();
	</script>
<%} // 강퇴일때 elseif 문 닫음
}// 로그인되어있을때 보여주기 닫음 %>
</html>