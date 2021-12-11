<%@page import="ecopang.model.EventCommentDAO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.EventDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.EventDAO"%>
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
	<title>Insert title here</title>
</head>

<%

request.setCharacterEncoding("UTF-8"); //인코딩 셋팅
String userID = "";
if(session.getAttribute("memId") != null){userID=(String)session.getAttribute("memId");};

//페이지 넘버 매겨주기 위한 변수들 생성
int pageSize = 5;
String pageNum = request.getParameter("pageNum");
if(pageNum == null) { 
	pageNum = "1";
}

int currentPage = Integer.parseInt(pageNum); 
int startRow = (currentPage - 1) * pageSize + 1; 
int endRow = currentPage * pageSize; 

//이벤트, 회원 객체 생성
EventDAO dao = new EventDAO();
UsersDAO udao = new UsersDAO();

//검색할경우
String sel = request.getParameter("sel");
String search = request.getParameter("search");

List eventList = null;	
int count = 0;				

//searchEventCount메서드, get~ 메서드 생성
if(sel != null && search != null) { 
	count = 0;
	if(count > 0) {
		eventList = null;
	}
} else {
	count = dao.getEventCount(); 
	System.out.println("Eventcount : " + count);
	
	if(count > 0) {
		eventList = dao.getEvents(startRow, endRow);
	}
}
int number = count - (currentPage - 1) * pageSize; 

//댓글 카운트 가져오려고 메서드 써보자
EventCommentDAO comment = new EventCommentDAO();

//쿠키
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
		response.sendRedirect("/ecopang/ecoProject/main/loginPro.jsp");
	}
}else {
    udto = udao.getUser((String)session.getAttribute("memId"));
}

%>

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
<div id="eventList" class="event_content_area">
	<div class="event-content">
	<div class="leftbar"> 
		<ul>
			<li><a class="active1" href="/ecopang/ecoProject/news/eventList.jsp">이벤트</a></li>
			<Li><a href="/ecopang/ecoProject/news/infoList.jsp">공지사항</a></Li>
		</ul>
	</div>	<!-- leftbar -->	
		<!-- 이벤트 목록 불러오는 부분 -->
	<div class="event-right">
		<div class="event-content">
			<%if(userID.equals("admin")){ %>
			<div class="event_button">
				<table>
					<tr>
						<td>
							<input type="button" onclick="window.location='eventWriteForm.jsp'" value=" 이벤트작성" class="basicBtn"/> 
						</td> <!-- 관리자만 보이는 버튼임 -->
					</tr>
				</table>
			</div>	
			<%}else{ %>

			<%} %>
			<%if(eventList == null ) {	//이벤트 리스트가 null 일경우%> 
				등록된 이벤트가 없습니다.
			<%}else{ // 작성된 이벤트리스트가 있을 경우%>
			 <%  for(int i = 0; i < eventList.size(); i++){
				 EventDTO dto = (EventDTO)eventList.get(i);
				 String eve_content = dto.getEve_content(); %>
				 <div class="event-inner">
				 <table>
					 <tr> 
						<td colspan="4">
						<a href="eventContent.jsp?eve_num=<%=dto.getEve_num()%>&pageNum=<%=pageNum%>"><img src ="/ecopang/ecoProject/imgs/<%=dto.getEve_img()%>" width = "300" rowspan="3"></a></td>
						<td class="event-text"> <a href="eventContent.jsp?eve_num=<%=dto.getEve_num()%>&pageNum=<%=pageNum%>"><h2> <%=dto.getEve_title()%> </h2></a> <br/>
						  	이벤트 기간 :  <%= dto.getEve_startdate()%> 부터 <%=dto.getEve_enddate() %> 까지<br/>
						  	 댓글 : (<%=comment.getEveCommentCount(dto.getEve_num())%>) <br/>
						</td>
					 </tr>
				 </table>
				 </div>
				 <% }%>  <br/>
				 <%} %>
			</div>	 
		</div> <!-- event-right -->
		<br/>
		
			<!-- 페이지 넘버 부분  -->
			
			<div class="number">
			
			<% 
				if(count > 0) { 
					int pageBlock = 5;
					int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
					int  startPage = (int)((currentPage - 1) / pageBlock) * pageBlock + 1;
					int endPage = startPage + pageBlock - 1;
					if(endPage > pageCount) endPage = pageCount;
					
					if(sel != null && search != null && !sel.equals("") && !search.equals("")) {
						if(startPage > pageBlock) {%>
							<a href="eventList.jsp?pageNum=<%= startPage - pageBlock%>&sel=<%=sel%>&search=<%=search%>">&lt;</a>
					<% 	}
						for(int i = startPage; i <= endPage; i++) { %>
							<a href="eventList.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>">&nbsp;<%= i %>&nbsp;</a>	
					<%	}
						if(endPage < pageCount) { %>
							<a href="eventList.jsp?pageNum=<%= startPage + pageBlock %>&sel=<%=sel%>&search=<%=search%>">&gt;</a>
					<%	}
					} else {
						if(startPage > pageBlock) {%>
							<a href="eventList.jsp?pageNum=<%= startPage - pageBlock%>">&lt;</a>
					<% 	}
						for(int i = startPage; i <= endPage; i++) { %>
							<a href="eventList.jsp?pageNum=<%=i%>">&nbsp;<%= i %>&nbsp;</a>	
					<%	}
						if(endPage < pageCount) { %>
							<a href="eventList.jsp?pageNum=<%= startPage + pageBlock %>">&gt;</a>
					<%	}
					}
				} %>
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
</div><!-- #page -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>