<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
    
<!DOCTYPE html>
<html>
<!-- 글씨체  -->
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<!-- 글씨체  -->

 <!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >

<head>
<meta charset="UTF-8">
<title>게시글 작성 페이지</title>
</head>
   <!-- bootstrap  -->
   <link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
   <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.js"></script> 
   <script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
   
   <!-- * summernote의 스타일시트와 자바스크립트을 사용하기 위한 선언 */ -->
   <link href="/ecopang/ecoProject/summernote/summernote.css" rel="stylesheet">
   <script src="/ecopang/ecoProject/summernote/summernote.js"></script>

   <script type="text/javascript"> //자바스크립트 코드 선언
        /* 이미지 서버 업로드 함수 */
       function sendFile(file, editor) {
            // 파일 전송을 위한 폼생성
          data = new FormData(); // 보내줄  <form....><input type="file" name="uploadFile" /></form>
           data.append("uploadFile", file);  
           $.ajax({ // ajax를 통해 파일 업로드 처리 (요청함 )
               data : data, //데이터 = 데이터
               type : "POST", // post방식 전송
               url : "summernoteImgUpload.jsp", //받을 url 
               cache : false, 
               contentType : false,
               processData : false,
               success : function(data) { // 처리가 성공할 경우 실행할 함수, data매개변수는 실행하고 나온 결과를 담아주는 변수 
                  // data 변수는 서버에 이미지 파일저장하고(summernotImgUpload.jsp에서 하는일) 저장된 파일의 경로와 파일명을 돌려받은 결과가 담기는 곳이다.
                    // 에디터에 이미지 출력
                  $(editor).summernote('editor.insertImage', data.url);
               },
               error : function(e){   //처리 실패할 경우 실행될 함수 : 에러의 내용이 e매개변수에 담겨져 console에 노출됨
                  console.log("errror");
                  console.log(e);
               }
           });
       }
    // 유효성 검사
   	function check(){
   		// 필수 기입요소 작성확인
   		var inputs = document.inputForm;
   		console.log(inputs);
   		
   		if(inputs.category.value == "선택"){
   			alert("카테고리를 선택해주세요.");
   			return false;
   		}
   		if(!inputs.tpc_title.value){
   			alert("제목을 입력하세요");
   			return false;
   		}
   		if(!inputs.tpc_content.value){
   			alert("내용을 입력하세요");
   			return false;
   		}
   	}
   </script>
 <%
UsersDAO udao = new UsersDAO();
UsersDTO udto = null;

if(session.getAttribute("memId") == null) { // 세션속성없다 
	// 세션이 없으면 쿠키는 있나
	String id = null, pw = null, auto = null;
	Cookie[] coos = request.getCookies();
	
	if(coos != null) {	
		for(Cookie c : coos) {
			if(c.getName().equals("autoId")) id = c.getValue(); udto = udao.getUser(id);
			if(c.getName().equals("autoPw")) pw = c.getValue();
			if(c.getName().equals("autoCh")) auto = c.getValue();
		}
	}
	// 세션은 없지만, 쿠키가 있어서 위코드로 값을 꺼내 담아보고,
	// 만약에 세변수에 값이 들어있으면 session 만들어주기 위해 loginPro로 바로 이동시키기.
	if(auto != null && id != null && pw != null) {
		response.sendRedirect("loginPro.jsp");
	}
}else {
    udto = udao.getUser((String)session.getAttribute("memId"));
}
%>  
   
<script>
	/* 회원버튼 스크립트 */
	function userBtnFunction() {
		document.getElementById("userDropdown").classList.toggle("show");
	}
	window.onclick = function(event) {
		if (!event.target.matches('.userBtn *')) {
			var dropdowns = document.getElementsByClassName("dropdownContent");
			var i;
			for (i = 0; i < dropdowns.length; i++) {
				var openDropdown = dropdowns[i];
				if (openDropdown.classList.contains('show')) {
					openDropdown.classList.remove('show');
				}
			}
		}
	}
</script>
<body class="ecopang_main">   
<div id="page" class="page">
	<header id="header" class="site-header cf">
		<div class="header-wrap">	
			<div class="site-branding">
				<!-- 인스타그램 -->
				<div class="instagram">
					<a href="https://www.instagram.com" target="_blank">
					<img src="/ecopang/ecoProject/imgs/instagram.png"></a>	
				</div>	
				<!-- 로고 -->	
				<div class="site-title">
					<a href="/ecopang/ecoProject/main/main.jsp">
					<img src="/ecopang/ecoProject/imgs/ecopang.png"/>&nbsp;ecopang</a>
				</div>
				<!--  회원버튼 -->
				<div class="dropdown">
					<div class="userBtn" onclick="userBtnFunction()">
						<div class="userImg">
						<% if(udto == null || udto.getUser_img() == null) { %>
				            <img src="/ecopang/ecoProject/imgs/default.png"/>
			            <% } else { %>
			            	<img src="/ecopang/ecoProject/imgs/<%= udto.getUser_img()%>" />
			            <% } %>
				        </div>
				        <div class="btnImg">
				            <div class="btnLine"></div>
				            <div class="btnLine"></div>
				            <div class="btnLine"></div>
				        </div>
					</div>
					<div id="userDropdown" class="dropdownContent">
						<% if(udto == null) { %>
				            <a href="/ecopang/ecoProject/main/loginForm.jsp">로그인</a>
				            <a href="/ecopang/ecoProject/main/signupForm.jsp">회원가입</a>
				        <% } else { %>
				            <a href="/ecopang/ecoProject/main/logout.jsp">로그아웃</a>
				            <a href="/ecopang/ecoProject/mypage/mypage.jsp">마이페이지</a>
				        <% } %>
			        </div>
		        </div><br/>
			</div> <!-- site branding -->
			<!-- nav bar -->	
			<nav class="nav">
				<ul class="menubar">
					<li><a href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
					<li><a href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
					<li><a href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
					<li><a class="active" href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->
	
	
<div id="info" class="site-content">
<div id="infoList" class="info_content_area">
	<div class="info-content">					
      <div>
         <form action="topicWritePro.jsp" name="inputForm" method="post" onsubmit="return check()">
            <table>
               <tr>
                  <td>
                 	주제
                  </td>
                  <td>
                   	제목
                  </td>
               </tr>
               <tr>
                  <td>
                     <select name="category" class="form-control">
                        <option>선택</option>
                        <option>꿀팁</option>
                        <option>기사/이슈</option>
                        <option>착한가게</option>
                        <option>제품 추천</option>
                        <option>자유게시판</option>
                     </select>
                  </td>
                  <td>
                     <input type="text" name="tpc_title" class="form-control"/>
                  </td>
               </tr>
               <tr>
					<td colspan="2"> 본문 </td>
				</tr>
               <tr>
                  <td colspan="2">
                     <textarea id="summernote" class="form-control" name="tpc_content"></textarea> <br />
                  </td>
               </tr>
            </table>
			<table class="twfbutton">
               <tr>
                  <td>
                     <input type="submit" value="작성" class="btn btn-primary pull-right" />
                     <input type="button" value="취소" class="twfbutton1" onclick="window.location='topicList.jsp'" >
                  </td>
               </tr>
            </table>   
         </form>
	      </div>
      </div>
		</div>
			</div> <!-- content-area --> 
		</div> <!-- site content -->
		<footer>
			<div class="footer_content">
				<div class="inner">
					<p>
						(주)에코팡 <br /> 팀원 : 정한별 박지연 정혜진 양준영 민주홍 조하영 <br /> 서울시 관악구 남부순환로
						1820,에그엘로우14층 전화번호 : 02-6020-0055 팩스번호 : 02-3285-0012
					</p>
				</div>
			</div>
		</footer>
	</div>
	<!-- #page -->
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"
		integrity="sha384-
IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"
		integrity="sha384-
cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"
		crossorigin="anonymous"></script>
</body>


<script>
            $(document).ready(function() { //브라우저 문서가 준비되면 바로 함수 실행
                $('#summernote').summernote({ // summernote 에디터 실행되는 함수
                    height: 400, 
                    width: 700,
               callbacks: { // 콜백을 사용
                        // 이미지를 업로드할 경우 이벤트를 발생
                        // 들어간 이미지만큼 for문 돌려서 에디터 내에 업로드해줌
                   onImageUpload: function(files, editor, welEditable) {
                      for(var i = 0; i < files.length; i++){
                         console.log("files i : " + files[i]);
                         sendFile(files[i], this);
                      }
                      
                  }
               }
            });
         });
      </script>
</html>