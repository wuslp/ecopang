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
	<title>signupForm</title>
</head>
<%
	if (session.getAttribute("memId") != null) {// 로그인 되어있을땐 회원가입페이지 못들어오게
%>
<script>
	alert("로그인한 상태입니다.");
	window.location = "/ecopang/ecoProject/main/main.jsp";
</script>
<%
	} else {// 로그인 안한 상태%>
<script>
// 유효성 검사
	function check(){
		// 필수 기입요소 작성확인
		var inputs = document.inputForm;
		console.log(inputs);
		
		if(!inputs.userID.value){
			alert("이메일을 입력하세요");
			return false;
		}
		if(inputs.idUncheck.value != "idCheck"){
			alert("이메일 중복체크를 하세요");
			return false;
		}
		if(!inputs.pw.value){
			alert("비밀번호를 입력하세요");
			return false;
		}
		if(!inputs.pwCh.value){
			alert("비밀번호 확인란을 입력하세요");
			return false;
		}
		if(!inputs.name.value){
			alert("이름을 입력하세요");
			return false;
		}
		if(!inputs.nickname.value){
			alert("별명을 입력하세요");
			return false;
		}
		if(inputs.nicknameUncheck.value != "nicknameCheck"){
			alert("별명 중복체크를 하세요");
			return false;
		}
		
		// 비밀번호 == 비밀번호 확인란
		if(inputs.pw.value != inputs.pwCh.value){
			alert("비밀번호를 동일하게 입력하세요");
			return false;
		}
	}
	
	// 아이디 중복체크 확인
	function confirmUserID(inputForm){
		if(inputForm.userID.value == "" || !inputForm.userID.value){
			alert("아이디를 입력하세요");
			return false;
		}
		// 팝업
		var url = "confirmUserID.jsp?userID=" + inputForm.userID.value;
		open(url, "confirmUserID",  "toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=400, height=200");
	}
	
	// onkeydown : 중복체크 눌렀지만, 사용하기 안하고 다른 아이디 적었을경우
	// 중복체크 안되어있다는걸 해줄려고 idUncheck 하는것
	function inputIdCh(){
		document.inputForm.idUncheck.value="inUncheck";
	}
	
	// 별명 중복체크 확인
	function confirmNickname(inputForm){ 
		if(inputForm.nickname.value == "" || !inputForm.nickname.value){
			alert("별명을 입력하세요");
			return false;
		}
		// 팝업
		var url = "confirmNickname.jsp?nickname=" + inputForm.nickname.value;
		open(url, "confirmNickname",  "toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=400, height=200");
	}
	function inputNicknameCh(){
		document.inputForm.nicknameUncheck.value="inUncheck";
	}

</script>
<body style="background-color: #888;">
	<div>
	    <div class="signupInput">
		    <div class="signupTitle">회원가입</div>
			    <form action="signupPro.jsp" method="post" name="inputForm" onsubmit="return check()" enctype="multipart/form-data">
                <table class="table3">
                    <tr><td colspan="2" id="id-userID">이메일 (필수 입력)</td></tr>
                    <tr>
                        <td>
                            <input type="text" name="userID" onkeydown="inputIdCh()" class="text"/>
                        </td>
                        <td><input type="button" value="중복 확인" onclick="confirmUserID(this.form)" class="btn"/>
                            <!-- onkeydown : 아이디를 썻다 지웠을경우 다시 중복확인하도록 -->
                            <input type="hidden" name="idUncheck" value="idUncheck"/>
                        </td>
                    </tr>
                    <tr><td colspan="2">비밀번호 (필수 입력)</td></tr>
                    <tr>
                        <td colspan="2"><input type="password" name="pw" class="text"/></td>
                    </tr>
                    <tr><td colspan="2">비밀번호 확인 (필수 입력)</td></tr>
                    <tr>
                        <td colspan="2"><input type="password" name="pwCh" class="text"/> </td>
                    </tr>
                    <tr><td colspan="2">이름 (필수 입력)</td></tr>
                    <tr>
                        <td colspan="2"><input type="text" name="name" class="text"/></td>
                    </tr>
                    <tr><td colspan="2" id="id-userNickname">별명 (필수 입력)</td></tr>
                    <tr>
                        <td><input type="text" name="nickname" onkeydown="inputNicknameCh()" class="text"/></td>
                        <td><input type="button" value="중복 확인" onclick="confirmNickname(this.form)" class="btn"/>
                            <input type="hidden" name="nicknameUncheck" value="nicknameUncheck"/>
                        </td>
                    </tr>
                    <!-- 밑에부터는 선택항목 -->
                    <tr><td colspan="2">프로필 사진 (선택)</td></tr>
                    <tr>
                        <td rowspan="2">
                        <!-- 사진 선택 안할때 default 이미지 뿌려줌 // 선택 후 선택이미지 보여줌 -->
                            <img src="/ecopang/ecoProject/imgs/default.png" id="previewImg" width="150" />
                        </td>
                        <td>
                            <label for="user_img">첨부파일 (선택)</label>
                            <input type="file" name="user_img" id="user_img" onchange="preview(this)" class="file"/>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="button" value="삭제" onclick="cancel()" class="btn"/></td>
                    </tr>
                    <tr><td colspan="2">생년월일 (선택)</td></tr>
                    <tr>
                        <td colspan="2"><input type="date" name="birth" class="date"/></td>
                    </tr>
                    <tr><td colspan="2">관심지역 (선택)</td></tr>
                    <tr>
                        <td><select name="user_city1" class="location">
                            <option value="All"> 시/도 선택 </option>
                            <option> 서울시 </option>
                        </select></td>
                        <td><select name="user_district1" class="location">
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
                        <td><select name="user_city2"  class="location">
                            <option value="All"> 시/도 선택 </option>
                            <option> 서울시 </option>
                        </select></td>
                        <td><select name="user_district2" class="location">
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
                        <td><select name="user_city3" class="location">
                            <option value="All"> 시/도 선택 </option>
                            <option> 서울시 </option>
                        </select></td>
                        <td><select name="user_district3" class="location">
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
                        <td colspan="2" style="text-align: right; padding-top: 20px;">
                            <input type="submit" value="가입" class="btn"/> 
                            <input type="reset" value="재작성" class="btn"/>
                        </td>
                    </tr>
                </table>
            </form>
		</div>
	</div>
</body>
<script>
	// 이미지 선택시 미리보기
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
	// 이미지 삭제시 file, previewimg 초기화
	function cancel(){
		  var elem = document.getElementById("previewImg");
		  elem.src = "/ecopang/ecoProject/imgs/default.png"; // img 초기화
		  
		  var user_img = document.getElementById("user_img");
		  user_img.value = ""; // file 초기화
	}
</script>
<%}%>
</html>