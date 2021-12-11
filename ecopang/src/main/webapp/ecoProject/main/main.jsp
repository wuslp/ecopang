<%@page import="java.util.List"%>
<%@page import="ecopang.model.EventDTO"%>
<%@page import="ecopang.model.EventDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.TopicDTO"%>
<%@page import="ecopang.model.TopicDAO"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@page import="ecopang.model.GroupDTO"%>
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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>ECOPANG MAIN</title>
</head>
<%	
	GroupDAO gdao = new GroupDAO();
	GroupDTO gdto = null;

	TopicDAO tdao = new TopicDAO();
	TopicDTO tdto = null;
	
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
	
	EventDAO edao = new EventDAO();
	List<EventDTO> eventList = edao.getMainEvents();
	List<TopicDTO> topicList = tdao.getLikeTopics();
	
%>
<script>

	var index = 0;
	let time;
	
	window.onload = function() {
		slideShow(0);
	}
	// 이벤트 이미지를 6초에 하나씩 보여주는 코드
	function slideShow() {
		var i;
		var x = document.getElementsByClassName("event_img");
		
		for(i = 0; i < x.length; i++) {
			x[i].style.display = "none";
		}
		index++;	
		if(index > x.length) {
			index = 1;
		}
		if(index < 1) {
			index = x.length;
		}
		x[index - 1].style.display = "block";
		time = setTimeout(slideShow, 6000);
	}
	// 이벤트 이미지를 다음으로 넘기고 다시 6초로 설정
	function plusSlides() {
		clearTimeout(time);
		slideShow();
	}
	// 이벤트 이미지를 이전으로 넘기고 다시 6초로 설정
	function minusSlides() {
		index -= 2;
		clearTimeout(time);
		slideShow();
	}
	// 원하는 이미지를 선택해서 보기
	function selectSlides(n) {
		index = n - 1;
		clearTimeout(time);
		slideShow();
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
				            <a href="loginForm.jsp">로그인</a>
				            <a href="signupForm.jsp">회원가입</a>
				        <% } else { %>
				            <a href="logout.jsp">로그아웃</a>
				            <a href="/ecopang/ecoProject/mypage/mypage.jsp">마이페이지</a>
				        <% } %>
			        </div>
		        </div><br/>
			</div> <!-- site branding -->
			<!-- nav bar -->	
			<nav class="nav">
				<ul class="menubar">
					<li><a class="active" href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
					<li><a href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
					<li><a href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
					<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->
	
	<!-- 컨텐츠 -->
	<div id="content" class="site-content">
		<div id="primaray" class="content-area">	
			<main id="main" class="site-main">
				<div class="main_content">
					<h4>이벤트</h4>
					<div class="event_imgs">
							<% if(eventList != null) {
									for(int i = 0; i < eventList.size(); i++ ) {
										if(eventList.get(i) != null ) {%>
											<img class="event_img" src="/ecopang/ecoProject/imgs/<%= eventList.get(i).getEve_img() %>" width="900px" height="250px"
											onclick="window.location='/ecopang/ecoProject/news/eventContent.jsp?eve_num=<%= eventList.get(i).getEve_num() %>'"/>
									<%	}	 	
									}
								} else {%>
								현재 진행중인 이벤트가 없습니다.
							 <% } %>
							<% if(eventList != null) { %>
								<div class="event_btn">
									<button class="btn btn-success" onclick="minusSlides()">&#10094;</button>
										<%for(int i = 0; i < eventList.size(); i++ ) { %>
											<div class="circle">
												<button onclick="selectSlides(<%=i%>)" ></button>
											</div>										
										<% } %>
									<button class="btn btn-success" onclick="plusSlides()">&#10095;</button>
								</div>
							<% }%>
					</div>
				</div> <!-- 이벤트 끝 -->
				
				<div class="group">
						<h4>인기 소모임</h4>
						<div class="group_list">
							<% for(int a = 1; a <= 4; a++) { 
								gdto = gdao.getLikeGroup(a);
								if(gdto != null) { 
									String content = gdto.getGroup_content();
								%>
								<div class="group_item">
									<a href="/ecopang/ecoProject/group/groupContent.jsp?group_num=<%= gdto.getGroup_num() %>" align="center">
										<div class="group_itemImg">
											<img src="/ecopang/ecoProject/imgs/<%= gdto.getGroup_img() %>" />
										</div>
										<div class="group_itemContent">
											<%= gdto.getGroup_title() %>
											 <br/>
												<%	if(content.length() > 12) { %>
													<h5><%= content.substring(0,12) + "..." %></h5>
												<% } else { %>
													<h5><%= content %></h5>
												<% } %>
										</div>
									</a>
								</div>
							<% 		} 
								} 
							%>
						</div>
				</div><!-- 인기 소모임 끝 -->
				<div class="community">
							<h4>인기 게시글</h4>
							<div class="community_list">
								<div class="line">
									<% if(topicList != null) { 
										int size = topicList.size();
										if(size > 9) size = 9;
										for(int i = 0; i < size; i++) { 
											tdto = topicList.get(i);
											String content = tdto.getTpc_content();%>
											<div class="community_item">
												<a href="/ecopang/ecoProject/topic/topicContent.jsp?tpc_num=<%=tdto.getTpc_num()%>">
												<h5><%= tdto.getTpc_title() %></h5>
												</a>
											</div>
									<% } 
									}%>
								</div>
							</div>
				</div><!--community -->
			</main>
		</div><!-- primary -->
	</div><!-- content -->	
	<footer>
		<div class="footer_content">
			<div class="inner">	
			<p>(주)에코팡  <br/>
			팀원 : 정한별 박지연 정혜진 양준영 민주홍 조하영 <br/>
			서울시 관악구 남부순환로 1820,에그엘로우14층 
			전화번호 : 02-6020-0055 팩스번호 : 02-3285-0012</p>
			</div>
		</div>	
	</footer>	
</div><!-- #page -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>