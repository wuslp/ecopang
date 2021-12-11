<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ecopang.model.InfoDTO"%>
<%@page import="ecopang.model.InfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- 글씨체  -->
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<!-- 글씨체  -->
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"rel="stylesheet"integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet"type="text/css">
<head>
<meta charset="UTF-8">
<title>infoContent/공지사항 내용 상세페이지</title>
</head>

<%
	int info_num = Integer.parseInt(request.getParameter("info_num"));

	InfoDAO dao = new InfoDAO();
	InfoDTO dto = dao.getinfo(info_num);

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

	//쿠키
	UsersDTO udto = null;
	UsersDAO udao = new UsersDAO();
	if (session.getAttribute("memId") == null) { // 세션속성없다
		// 세션이 없으면 쿠키는 있나
		String id = null, pw = null, auto = null;
		Cookie[] coos = request.getCookies();
		if (coos != null) {
			for (Cookie c : coos) {
				if (c.getName().equals("autoId"))
					id = c.getValue();
				udto = udao.getUser(id);
				if (c.getName().equals("autoPw"))
					pw = c.getValue();
				if (c.getName().equals("autoCh"))
					auto = c.getValue();
			}
		}
		// 세션은 없지만, 쿠키가 있어서 위코드로 값을 꺼내 담아보고,
		// 만약에 세변수에 값이 들어있으면 session 만들어주기 위해 loginPro로 바로 이동시키기.
		if (auto != null && id != null && pw != null) {
			response.sendRedirect("/ecopang/ecoProject/main/loginPro.jsp");
		}
	} else {
		udto = udao.getUser((String) session.getAttribute("memId"));
	}
%>
<script>
function removeCheck() {
	if (confirm("정말 삭제하시겠습니까??") == true){    //확인
		window.location.href="infoDeletePro.jsp?info_num=<%=info_num%>
	";
		} else { //취소
			return false;
		}
	}
function userBtnFunction() {
	document.getElementById("userDropdown").classList.toggle("show");
	}
	window.onclick = function(event) {
	if(!event.target.matches('.userBtn *')) {
	var dropdowns = document.getElementsByClassName("dropdownContent");
	var i;
	for(i = 0; i < dropdowns.length; i++) {
	var openDropdown = dropdowns[i];
	if(openDropdown.classList.contains('show')) {
	openDropdown.classList.remove('show');
	}
	}
	}}
</script>

<script> /* 회원버튼 스크립트 */
function userBtnFunction() { 
	document.getElementById("userDropdown").classList.toggle("show");
}

window.onclick = function(event) {
	if(!event.target.matches('.userBtn *')) {
		var dropdowns = document.getElementsByClassName("dropdownContent");
		var i;
		for(i = 0; i < dropdowns.length; i++) {
			var openDropdown = dropdowns[i];
			if(openDropdown.classList.contains('show')) {
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
						<a href="https://www.instagram.com" target="_blank"> <img
							src="/ecopang/ecoProject/imgs/instagram.png"></a>
					</div>
					<!-- 로고 -->
					<div class="site-title">
						<a href="/ecopang/ecoProject/main/main.jsp"> <img
							src="/ecopang/ecoProject/imgs/ecopang.png" />&nbsp;ecopang
						</a>
					</div>
					<!-- 회원버튼 -->
					<div class="dropdown">
						<div class="userBtn" onclick="userBtnFunction()">
							<div class="userImg">
								<%
									if (udto == null || udto.getUser_img() == null) {
								%>
								<img src="/ecopang/ecoProject/imgs/default.png" />
								<%
									} else {
								%>
								<img src="/ecopang/ecoProject/imgs/<%=udto.getUser_img()%>" />
								<%
									}
								%>
							</div>
							<div class="btnImg">
								<div class="btnLine"></div>
								<div class="btnLine"></div>
								<div class="btnLine"></div>
							</div>
						</div>
						<div id="userDropdown" class="dropdownContent">
							<%
								if (udto == null) {
							%>
							<a href="/ecopang/ecoProject/main/loginForm.jsp">로그인</a> <a
								href="/ecopang/ecoProject/main/singupForm.jsp">회원가입</a>
							<%
								} else {
							%>
							<a href="/ecopang/ecoProject/main/logout.jsp">로그아웃</a> <a
								href="#">마이페이지</a>
							<%
								}
							%>
						</div>
					</div>
					<br />
				</div>
				<!-- site branding -->
				
				<!-- nav bar -->
				<nav class="nav">
					<ul class="menubar">
						<li><a href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
						<li><a class="active" href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
						<li><a href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
						<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
					</ul>
				</nav>
			</div>
			<!-- header-wrap -->
		</header>
		<!-- 헤더 끝 -->
		
<div id="info" class="site-content">
<div id="info" class="event_content_area">		
		<div class="info-content1">
			<table class="info1">
				<tr>
					<td><h3><%=dto.getInfo_title()%></h3></td>
					<td class="info-date"><%=sdf.format(dto.getInfo_reg())%></td>
					<%
						if (!(session.getAttribute("memId") == null || !session.getAttribute("memId").equals("admin"))) {
					%>
					<td  class="info-button" colspan="2">
						<button
							onclick="window.location='infoModifyForm.jsp?info_num=<%=info_num%>'">수정</button>
						<button onclick="removeCheck()">삭제</button>
					</td>
					<%
						}
					%>
				</tr>
			</table>
			<table class="info2">	
				<tr>
					<td colspan="3" height="100"><%=dto.getInfo_content()%></td>
				</tr>
			</table>
			<table class="info3">	
				<tr>
					<td colspan="3">
						<button onclick="window.location='infoList.jsp'">목록가기</button>
					</td>
				</tr>
			</table>
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
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"ntegrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"crossorigin="anonymous"></script>
</body>
</html>