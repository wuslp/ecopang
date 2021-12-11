<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
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
<title>mypageModifyForm</title>
</head>
<%
	if (session.getAttribute("memId") == null) {
%>
<script>
	alert("로그인해주세요.");
	window.location = "/ecopang/ecoProject/main/loginForm.jsp";
</script>
<%
	} else {
		String userID = (String) session.getAttribute("memId");

		UsersDAO dao = new UsersDAO();
		// getUser == 유저정보 가져오기
		UsersDTO user = dao.getUser(userID);
%>
<script>
	// 유효성 검사 : 비번 확인후 정보수정
	function check() {
		var inputs = document.inputForm;
		console.log(inputs);

		if (!inputs.pwch.value) {
			alert("비밀번호를 작성하세요");
			return false;
		}
		if(inputs.nicknameUncheck.value != "nicknameCheck"){
			alert("별명 중복체크를 하세요");
			return false;
		}
	}
	function confirmNickname(inputForm) {
		if (inputForm.nickname.value == "" || !inputForm.nickname.value) {
			alert("별명을 입력하세요");
			return false;
		}
		// 팝업
		var url = "confirmNickname.jsp?nickname=" + inputForm.nickname.value;
		open(
				url,
				"confirmNickname",
				"toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=400, height=200");
	}
	function inputNicknameCh(){
		document.inputForm.nicknameUncheck.value="inUncheck";
	}
	// 비밀번호 변경 페이지 새창 띄워주기
	function pwChange(inputForm) {
		var url = "pwChangeForm.jsp";
		open(
				url,
				"pwChangeForm",
				"toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=500, height=400");
	}
	
	// body 뿌린후 function 시작
	function body_init() {
		setDistrict(); // 구 세팅
		setCity(); // 시 세팅
	}
	// district 저장된 정보 selected 하기
	function setDistrict() {
		var district1 = "<%=user.getUser_district1()%>";
		var district2 = "<%=user.getUser_district2()%>";
		var district3 = "<%=user.getUser_district3()%>";
		
		var user_district1 = document.getElementById("user_district1"); //select 객체
		var user_district2 = document.getElementById("user_district2"); //select 객체
		var user_district3 = document.getElementById("user_district3"); //select 객체
		
		user_district1.value = district1;
		user_district2.value = district2;
		user_district3.value = district3;
		
	}
	// city 저장된 정보 selected 하기
	function setCity() {
		var city1 = "<%=user.getUser_city1()%>";
		var city2 = "<%=user.getUser_city2()%>";
		var city3 = "<%=user.getUser_city3()%>";
		
		var user_city1 = document.getElementById("user_city1");
		var user_city2 = document.getElementById("user_city2");
		var user_city3 = document.getElementById("user_city3");
		
		user_city1.value = city1;
		user_city2.value = city2;
		user_city3.value = city3;
	}
</script>
<body onload="javascript:body_init();" style="background-color:#888;">
	<div class="signupInput">
		<div class="signupTitle">회원 정보 수정</div>
			<form action="mypageModifyPro.jsp" method="post" name="inputForm"
				onsubmit="return check()" enctype="multipart/form-data">
				<table class="table3">
					<tr>
						<td colspan="2">*이메일</td>
					</tr>
					<tr>
						<td colspan="2"><%=user.getUserID()%></td>
					</tr>
					<tr>
						<td>*비밀번호</td>
						<td style=" text-align:right;">
							<input type="button" value="비밀번호 변경"
							onclick="pwChange(this.form)" class="btn2"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">*이름</td>
					</tr>
					<tr>
						<td colspan="2"><%=user.getName()%></td>
					</tr>
					<tr>
						<td colspan="2">*별명</td>
					</tr>
					<tr>
						<td><input type="text" name="nickname"
							onkeydown="inputNicknameCh()" value="<%=user.getNickname()%>" class="text"/></td>
						<td style=" text-align:right;"><input type="button" value="중복 확인"
							onclick="confirmNickname(this.form)" class="btn"/>
							<input type="hidden" name="nicknameUncheck" value="nicknameCheck"/>	
						</td>
					</tr>

					<!-- 밑에부터는 선택항목 -->
					<tr>
						<td colspan="2">프로필 사진</td>
					</tr>
					<tr>
						<td rowspan="2">
							<%if (user.getUser_img() != null) {// 사진저장된게 있을경우%> 
								<img src="/ecopang/imgs/<%=user.getUser_img()%>" id="previewImg"  width="150" />
							<%} else {%> 
								<img src="/ecopang/imgs/default.png" id="previewImg"  width="150" /> 
							<%} %>
						</td>
						<td style=" text-align:right;">
							<label for="user_img">첨부파일</label>
                            <input type="file" name="user_img" id="user_img" onchange="preview(this)" class="file"/>
							<input
							type="hidden" id="exPhoto" name="exPhoto" value="<%=user.getUser_img()%>" />
							<%-- 이전 저장된 사진정보 --%></td>
							<tr>
						<td style=" text-align:right;"><input type="button" value="삭제" onclick="cancel()" class="btn"/></td>
				</tr>
					</tr>
					<tr>
						<td colspan="2">생년월일</td>
					</tr>
					<tr>
						<td colspan="2"><input type="date" name="birth"
							value="<%=user.getBirth()%>" class="date"/></td>
					</tr>
					<tr>
						<td colspan="2">관심지역</td>
					</tr>
					<tr>
						<td><select id="user_city1" name="user_city1" class="location">
						<option value="All"> 시/도 선택 </option>
						<option> 서울시 </option>
						</select>
						</td>
						<td>
						<select id="user_district1" name="user_district1" class="location">
						<option value="All">구 선택</option>
						<option>강남구</option>
						<option>강동구</option>
						<option>강북구</option>
						<option>강서구</option>
						<option>관악구</option>
						<option>광진구</option>
						<option>구로구</option>
						<option>금천구</option>
						<option>노원구</option>
						<option>도봉구</option>
						<option>동대문구</option>
						<option>동작구</option>
						<option>마포구</option>
						<option>서대문구</option>
						<option>서초구</option>
						<option>성동구</option>
						<option>성북구</option>
						<option>송파구</option>
						<option>양천구</option>
						<option>영등포구</option>
						<option>용산구</option>
						<option>은평구</option>
						<option>종로구</option>
						<option>중구</option>
						<option>중랑구</option>
					</select></td>
					</tr>
						<td><select id="user_city2" name="user_city2" class="location">
						<option value="All"> 시/도 선택 </option>
						<option> 서울시 </option>
						</select>
						</td>
						<td><select id="user_district2" name="user_district2" class="location">
						<option value="All">구 선택</option>
						<option>강남구</option>
						<option>강동구</option>
						<option>강북구</option>
						<option>강서구</option>
						<option>관악구</option>
						<option>광진구</option>
						<option>구로구</option>
						<option>금천구</option>
						<option>노원구</option>
						<option>도봉구</option>
						<option>동대문구</option>
						<option>동작구</option>
						<option>마포구</option>
						<option>서대문구</option>
						<option>서초구</option>
						<option>성동구</option>
						<option>성북구</option>
						<option>송파구</option>
						<option>양천구</option>
						<option>영등포구</option>
						<option>용산구</option>
						<option>은평구</option>
						<option>종로구</option>
						<option>중구</option>
						<option>중랑구</option>
					</select></td>
					</tr>
						<td><select id="user_city3" name="user_city3" class="location">
						<option value="All"> 시/도 선택 </option>
						<option> 서울시 </option>
						</select>
						</td>
						<td><select id="user_district3" name="user_district3" class="location">
						<option value="All">구 선택</option>
						<option>강남구</option>
						<option>강동구</option>
						<option>강북구</option>
						<option>강서구</option>
						<option>관악구</option>
						<option>광진구</option>
						<option>구로구</option>
						<option>금천구</option>
						<option>노원구</option>
						<option>도봉구</option>
						<option>동대문구</option>
						<option>동작구</option>
						<option>마포구</option>
						<option>서대문구</option>
						<option>서초구</option>
						<option>성동구</option>
						<option>성북구</option>
						<option>송파구</option>
						<option>양천구</option>
						<option>영등포구</option>
						<option>용산구</option>
						<option>은평구</option>
						<option>종로구</option>
						<option>중구</option>
						<option>중랑구</option>
					</select></td>
					</tr>
					<tr>
						<!-- 비밀번호 확인후 정보 변경 -->
						<td colspan="2" style="padding-top:10px;">비밀번호확인<input type="password" name="pwch" class="text" style="margin-left:80px;"/></td>
					</tr>
					<tr>
						<td colspan="2" style="text-align:right;padding-top:30px;"><input type="submit" value="수정"  class="btn"/> <input
							type="reset" value="재작성"  class="btn"/> <input type="button" value="마이페이지"
							onclick="window.location='mypage.jsp'" class="btn2"/>
						</td>
					</tr>
				</table>
			</form>

	</div>
</body>
<script>
// 이미지 미리보기 
function preview(input) {
    if(input.files && input.files[0]) {
        const reader = new FileReader()
        reader.onload = e => {
            const previewImage = document.getElementById("previewImg")
            previewImage.src = e.target.result
        }
        reader.readAsDataURL(input.files[0])
    }
}
// 이미지 미리보기 삭제
	function cancel(){
	  var elem = document.getElementById("previewImg");
	  elem.src = "/ecopang/imgs/default.png"; // img 초기화
	  
	  var user_img = document.getElementById("user_img");
	  user_img.value = ""; // file 초기화
	  
	  var exPhoto = document.getElementById("exPhoto");
	  exPhoto.value = ""; // exPhoto 초기화	  
}
</script>
<%} %>
</html>