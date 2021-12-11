<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.EventCommentDTO"%>
<%@page import="ecopang.model.EventCommentDAO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.EventDAO"%>
<%@page import="ecopang.model.EventDTO"%>
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
<title>이벤트 상세페이지</title>
<link href="style.css" rel="stylesheet" type="text/css" >
<%
	request.setCharacterEncoding("UTF-8");	
%>
</head>
<script langauge="javascript">
	function sorry(){
		alert("준비중인 페이지입니다.(쉿! 개발중 ^.~!)");
	}
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
<% 
	String userID = "";
	if(session.getAttribute("memId") != null) {
		userID = (String)session.getAttribute("memId");
	}
 	

	//상세페이지 기본 변수들 미리설정
	int eve_num = 0; //이벤트 고유번호 없으면 0으로 세팅하되
	if(request.getParameter("eve_num") != null) //만약에 받아온 번호가 있으면
		eve_num = Integer.parseInt(request.getParameter("eve_num")); //그걸로 세팅해주고
	System.out.println(eve_num);
	int pageNum = 1; //페이지 넘버 1로 세팅하되
	if(request.getParameter("pageNum") != null) //받아온 번호 잇으면
		pageNum = Integer.parseInt(request.getParameter("pageNum")); //그걸로 세팅해라
	
	EventDAO  dao = new EventDAO(); //dao객체 생성해주고
	EventDTO dto = dao.getEventContent(eve_num); // dto타입으로 필요한 변수들 채워주기 (밑에서 필요한거 꺼내쓸거임)
	UsersDTO udto = new UsersDTO();
	UsersDAO udao = new UsersDAO();
	String userNickname = udto.getNickname();
	//댓글
	EventCommentDAO cdao = new EventCommentDAO(); //댓글 dao 객체 생성
	EventCommentDTO cdto = new EventCommentDTO(); //댓글 dto 객체생성
	//댓글 페이지 1로 설정해두되
	int commentPage = 1;
	if(request.getParameter("commentPage") != null) //만약에 넘어온 수 있으면 그걸로 해줘라
		commentPage = Integer.parseInt(request.getParameter("commentPage"));
	
	int pageSize = 5;
	
	int currentPage = commentPage; 
	int startRow = (currentPage - 1) * pageSize + 1; 
	int endRow = currentPage * pageSize; 
	
	
	//list타입의 이벤트 댓글 객체형성해줌
	List eventCommentList = null;
	int count = cdao.getEveCommentCount(eve_num);//이벤트댓글 고유번호 던져줄테니 카운트 세와라
	
	if(count > 0) { //테이블에 1개라도 있으면
		eventCommentList = cdao.getEveComments(eve_num,startRow, endRow); //이벤트 댓글 꺼내와서 넣어주셈
	}
	int number = count - (currentPage - 1) * pageSize; 
	
	
	//쿠키

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
		response.sendRedirect("/ecopang/ecoProject/main/loginPro.jsp");
	}
}else {
    udto = udao.getUser((String)session.getAttribute("memId"));
}
	System.out.println(udto);
	System.out.println(udto);
	
%>

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
				            <a href="/ecopang/ecoProject/main/singupForm.jsp">회원가입</a>
				        <% } else { %>
				            <a href="/ecopang/ecoProject/main/logout.jsp">로그아웃</a>
				            <a href="#">마이페이지</a>
				        <% } %>
			        </div>
		        </div><br/>
			</div> <!-- site branding -->
			
		<!-- nav bar -->	
			<nav class="nav">
				<ul class="menubar">
					<li><a href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
					<li><a class="active" href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
					<li><a href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
					<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->


<div id="event" class="site-content">
<div id="eventList" class="event_content_area1">
	<div class="event-content">
		<div class="content-inner">
				<table class="content-table">
					<tr>
						<td class="title1">
							<h3>이벤트 : <%= dto.getEve_title() %></h3><br>
						</td>
							<% if(userID.equals("admin")){%>
							<td class="button1">
								<button onclick="window.location='eventModifyForm.jsp?eve_num=<%=dto.getEve_num()%>&pageNum=<%=pageNum%>'">수정</button>
								<button onclick="window.location='eventDeletePro.jsp?eve_num=<%=dto.getEve_num()%>&pageNum=<%=pageNum%>'">삭제</button>
								<button onclick="window.location='eventList.jsp?pageNum=<%=pageNum%>'">목록</button>
							</td>
							<%}else{ %>
							<td class="button1">
							<button onclick="window.location='eventList.jsp?pageNum=<%=pageNum%>'">목록</button>
							</td>
							
							<%} %>
					</tr>
					<tr>
						<td class="title2">
							이벤트 기간 : <%= dto.getEve_startdate()%> ~ <%=dto.getEve_enddate() %>
						</td>
					</tr>
					<tr>
						<td class="title3" colspan="2">
							<img src="/ecopang/ecoProject/imgs/<%= dto.getEve_img()%>" width="500"> 
							<%= dto.getEve_content() %>
						</td>
					</tr>
				</table>
			</div>
			<div class="topicCommentDiv1">
				<!-- 댓글 -->
				<% if(eventCommentList != null) { 
					for(int i = 0; i < eventCommentList.size(); i++) { 
						cdto = (EventCommentDTO)eventCommentList.get(i);
						String img = udao.getUser_img(cdto.getUserID());%>
						<div class="eventCommentRow">							
							<div class="commentImg">
								<img src=/ecopang/ecoProject/imgs/<%= img %> />
							</div>
							<div class="commentContent">
								<div class="commentTop1">
									<div class="commentNickname">
										<%= cdto.getNickname() %>
									</div>
									<!-- 댓글삭제 -->
									<div class="commentDeleteBtn1"> 
										<form action="eventCommentDel.jsp?eve_com_num=<%=cdto.getEve_com_num() %>&eve_num=<%=eve_num%>&pageNum=<%=pageNum%>" method="post">
											<% if(cdto.getUserID().equals((String)session.getAttribute("memId"))) {  %>
												<button onclick="submit">삭제</button>
											<% } %>
										</form>
									</div>
								</div>
								<div class="comment">
									<%=cdto.getEve_comment() %>
								</div>
							</div>
						</div>
					<% } 
					}%>
				</div>
				<!-- 댓글 작성  -->
				<form action="eventCommentPro.jsp?eve_num=<%=eve_num %>" method="post">
					<% if(session.getAttribute("memId") != null) { %>
						<div class="commentInput">
							<input type="text" name="eve_comment"/>
							<button onclick="submit">댓글작성</button>
						</div>
					<% } %>
				</form>
		</div>
						</div> 
				</div> <!-- content-area --> 
		</div> <!-- site content -->
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
</body>
</html>