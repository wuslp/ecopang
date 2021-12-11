<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.InfoDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.EventDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>이벤트 공지사항 관리자 수정 페이지</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String userID= "";
	if(session.getAttribute("memId") != null) {
		userID = (String)session.getAttribute("memId");
	}
	if (!userID.equals("admin")) {
%>
<script>
		alert("관리자 전용 페이지 입니다.");
		window.location.href="/ecopang/ecoProject/main/main.jsp";
</script>
<%
	} else { // 세션아이디가 admin
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
	<!-- 글씨체  -->
	<link rel="preconnect" href="https://fonts.googleapis.com"> 
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
	<!-- 글씨체  -->

	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >
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
	<script>
		function selChange() {
			var sel = document.getElementById("sel").options[document.getElementById("sel").selectedIndex].value;
			var url = '/ecopang/ecoProject/mypage/adminDeleteUser.jsp?sel=' + sel
			window.location=url;
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
						<li><a class="active" href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
						<li><a href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
						<li><a href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
						<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
					</ul>
				</nav>
			</div><!-- header-wrap -->
		</header> <!-- 헤더 끝 -->
<%

	UsersDAO dao = new UsersDAO();
	int count = dao.getEvenCount();
	
	//1.이벤트 
	List evList = null;

	// ** 페이지 관련 정보 세팅 ** 
	int pageSize = 5; 
	// 현재 페이지 번호  
	String pageNum = request.getParameter("pageNum"); 
	if(pageNum == null){
		pageNum = "1";
	}

	int currentPage = Integer.parseInt(pageNum); 
	int startRow = (currentPage - 1) * pageSize + 1; 
	int endRow = currentPage * pageSize; 
	//++
	if(count > 0){
		evList = dao.getEventAll(startRow, endRow); //글을 startRow 부터 end까지
	}

	
	//2.공지사항
	int count2 = dao.getInfoCount(); 
	List infoList = null;

	// ** 페이지 관련 정보 세팅 ** 
	int pageSize2 = 5; 
	// 현재 페이지 번호  
	String pageNum2 = request.getParameter("pageNum2"); 
	if(pageNum2 == null){
		pageNum2 = "1";
	}

	int currentPage2 = Integer.parseInt(pageNum2); 
	int startRow2 = (currentPage2 - 1) * pageSize2 + 1; 
	int endRow2 = currentPage2 * pageSize2; 
	//++
	if(count2 > 0){
		infoList = dao.getInfoAll(startRow2, endRow2); //공지사항 start 부터 end 까지
	}		
		
		
		
%>
<%
	//관리자 모드에 이벤트/공지사항 모아서 볼 수 있는 메뉴 추가
	//이벤트 공지사항 모두 이 페이지로 불러오기
	//추가 삭제 수정 
%>
	<div class="body">
		<div class="leftDiv"><%--왼쪽 으로 --%>
			<ul>
				<li><a href="/ecopang/ecoProject/mypage/adminReportList.jsp">신고목록</a></li>
				<li><a href="/ecopang/ecoProject/mypage/adminUserList.jsp">회원목록</a></li>
				<li><a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp">탈퇴목록</a></li>
				<li><a href="/ecopang/ecoProject/mypage/adminEventInfo.jsp">이벤트/공지사항 관리</a></li>
			</ul>
		</div>
		<div class="rightDiv">
	<div class="adminmain">
		<h1 align="center"> 관리자 이벤트/공지사항 페이지</h1>
		<div class="event">
			<h4>
				이벤트 목록
				<input type="button" value="새글작성" onclick="window.location='adminEventWriteForm.jsp'">
			</h4>
			<table>
				<th>이벤트 제목</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>상세내용</th>
				<th></th>
			<% if(count == 0){%>
				<tr>
					<td><pre>작성된 이벤트 목록이 없습니다 ! ! 이벤트를 작성해 보세요</pre></td>
				</tr>
			<%}else{%>
			<form action="adminEventInfoPro.jsp">	
			
				<%for(int i = 0; i < evList.size(); i++){
					EventDTO edto = (EventDTO)evList.get(i); 
					System.out.println("22 : "+edto);%>
					<input type="hidden" name="eve_num" value="<%=edto.getEve_num() %>"> 
					<input type="hidden" name="check" value="1"> 
						<tr>
							<td><a href="/ecopang/ecoProject/news/eventContent.jsp?eve_num=<%=edto.getEve_num()%>"><%=edto.getEve_title() %></a></td>
							<td><%=edto.getEve_startdate() %></td>
							<td><%=edto.getEve_enddate() %></td>
							<td>
								<% if(edto.getEve_content() != null && edto.getEve_content().length() > 15) { %>
									<%=edto.getEve_content().substring(0,15) + "..." %>
								<% } else { %>
									<%=edto.getEve_content() %>
								<% } %>
							</td>
							<td>
								<input type="button" value="수정" onclick="window.location='adminEventModifyForm.jsp?eve_num=<%=edto.getEve_num()%>'">
								<input type="submit" value="삭제">
							</td>
						</tr>
					<%}%>
				<%}//else %>
				</table>
			</form>
		</div><br/><br/>
		
		
		
		<%-- 이벤트 리스트 페이징 번호 --%>
		<div class="paging">
		<% if(count > 0) {
			// 페이지 번호를 몇개까지 보여줄것인지 지정
			int pageBlock = 5; 
			// 총 몇페이지가 나오는지 계산 
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			
			// 현재 페이지에서 보여줄 첫번째 페이지번호
			int startPage = (int)((currentPage-1)/pageBlock) * pageBlock + 1; 
			// 현재 페이지에서 보여줄 마지막 페이지번호 
			int endPage = startPage + pageBlock - 1; 
			// 마지막에 보여줄 페이지번호는, 전체 페이지 수에 따라 
			if(endPage > pageCount) endPage = pageCount; 
			
			//페이지 번호 처리
			// 왼쪽 화살표
					if(startPage > pageBlock) { %>
						<a href="adminEventInfo.jsp?pageNum=<%=startPage-pageBlock %>" class="pageNums"> &lt; &nbsp;</a>
				<%	}
					// 페이지 번호 뿌리기 
					for(int i = startPage; i <= endPage; i++){ %>
						<a href="adminEventInfo.jsp?pageNum=<%=i%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
				<%	}	
					// 오른쪽 화살표
					if(endPage < pageCount) { %>
						&nbsp; <a href="adminEventInfo.jsp?pageNum=<%=startPage+pageBlock%>" class="pageNums"> &gt; </a>
				<%	}
			}//if(count > 0)%>		
		</div><%-- 이벤트 리스트 페이징 번호 --%><br/><br/><br/><br/>
		
		
		
		
		<div class="info">
			<h4>
				공지사항 목록
				<input type="button" value="새글작성" onclick="window.location='adminInfoWriteForm.jsp'"> 
			</h4>
			<table>
				<th>공지사항 번호</th>
				<th>공지사항 제목</th>
				<th>공지사항 내용</th>
				<th>공지사항 작성날짜</th>
				<th></th>
			<% if(count == 0){%>
					<tr>
						<td><pre>작성된 공지사항 목록이 없습니다 ! ! 공지사항을 작성해 보세요</pre></td>
					</tr>
			<%}else{%>			
			<form action="adminEventInfoPro.jsp"> 
					
				<%for(int i = 0; i < infoList.size(); i++){
					InfoDTO idto = (InfoDTO)infoList.get(i); %>
					<input type="hidden" name="check" value="2"> 
					<tr>
						<td><%=idto.getInfo_num() %></td>
						<td><a href="/ecopang/ecoProject/news/infoContent.jsp?info_num=<%=idto.getInfo_num()%>"><%=idto.getInfo_title() %></a></td>
						<td>
							<% if(idto.getInfo_content() != null && idto.getInfo_content().length() > 15) { %>
								<%=idto.getInfo_content().substring(0,15) + "..." %>
							<% } else { %>
								<%=idto.getInfo_content() %>
							<% } %>
						</td>
						<td><%=idto.getInfo_reg().toString().substring(0,16) %></td>
						<td>
							<input type="button" value="수정" onclick="window.location='adminInfoModifyForm.jsp?info_num=<%=idto.getInfo_num()%>'">
							<input type="submit" value="삭제"><input type="hidden" name="info_num" value="<%=idto.getInfo_num() %>">
						</td>
					</tr>
					<%}%>
				<%}//else %>
				</table>
			</form>
		</div><br/><br/><br/><br/>
		
		
		
		<%-- 공지사항 리스트 페이징 번호 --%>
		<div class="paging">
		<% if(count2 > 0) {
			// 페이지 번호를 몇개까지
			int pageBlock2 = 5; 
			// 총 몇페이지
			int pageCount2 = count2 / pageSize2 + (count2 % pageSize2 == 0 ? 0 : 1);
			int startPage2 = (int)((currentPage2-1)/pageBlock2) * pageBlock2 + 1; 
			int endPage2 = startPage2 + pageBlock2 - 1;  
			if(endPage2 > pageCount2) endPage2 = pageCount2; 
			
			//페이지 번호 처리
			// 왼쪽 화살표
					if(startPage2 > pageBlock2) { %>
						<a href="adminEventInfo.jsp?pageNum2=<%=startPage2-pageBlock2 %>" class="pageNums"> &lt; &nbsp;</a>
				<%	}
					// 페이지 번호 뿌리기 
					for(int i = startPage2; i <= endPage2; i++){ %>
						<a href="adminEventInfo.jsp?pageNum2=<%=i%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
				<%	}	
					// 오른쪽 화살표
					if(endPage2 < pageCount2) { %>
						&nbsp; <a href="adminEventInfo.jsp?pageNum2=<%=startPage2+pageBlock2%>" class="pageNums"> &gt; </a>
				<%	}
			}//if(count > 0)%>		
		</div><%-- 공지사항 리스트 페이징 번호 --%><br/><br/><br/><br/>
		
		
		
	</div><%--adminmain --%>
	</div>
	</div>
	
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
<% } %>
</html>