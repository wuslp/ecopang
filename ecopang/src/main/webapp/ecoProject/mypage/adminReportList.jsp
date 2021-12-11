<%@page import="ecopang.model.UsersDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.ReportsDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 신고 목록</title>
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
	
	//파라미터넘겨줄 경우 뽑아주기
	String warn = request.getParameter("warn");
	if(warn == null){warn ="4";}
	// ** 게시글 페이지 관련 정보 세팅 ** 
	// 한페이지에 보여줄 게시글의 수
	int pageSize = 3; 

	// 현재 페이지 번호  
	String pageNum = request.getParameter("pageNum");  
	if(pageNum == null){ //pageNum 파라미터 안넘어왔을때.
		pageNum = "1";
	}
	
	// 현재 페이지에 보여줄 게시글 시작과 끝 등등 정보 세팅 
	int currentPage = Integer.parseInt(pageNum); // 계산을 위해 현재페이지 숫자로 변환하여 저장 
	int startRow = (currentPage - 1) * pageSize + 1; // 페이지 시작글 번호 
	int endRow = currentPage * pageSize; // 페이지 마지막 글번호
	
	UsersDTO dto = new UsersDTO();
	UsersDAO dao = new UsersDAO();
	ReportsDTO rdao = new ReportsDTO();//신고 dto
	//++서치시 변수에 파라미터가 들어갈 것 임.
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");

	//이페이지 에서는 
	//신고된 회원정보를 불러오면됨 
	//신고테이블reports - reportsDTO

	//회원 리스트가 하나라도 있으면 글들을 다시 가져오기 
	int count = 0;
	List usersList = null; 

	//검색시 , 미검색시 분기처리
	if(sel != null && search != null){//검색을한 경우
		count = dao.getSeRepCount(sel,search);//검색된 글의 총 개수 가져오는것

		//검색한 글이 하나라도 있으면 검색한 글 가져오기
		if(count > 0){
			usersList = dao.getSeRepinfo(startRow, endRow, sel, search);
		}
	}else{//검색안함. 전체 게시판 요청
		
		// 전체 글의 개수 가져오기 
		count = dao.getRepCount();
		// 글이 하나라도 있으면 글들을 다시 가져오기 
		if(count > 0){//미처리 , 경고 , 넘어가기
			if(warn.equals("1")){//미처리
				count=dao.getWarn1Count();
				usersList = dao.getWarn1(startRow, endRow); 
			}else if(warn.equals("2")){//경고
				count=dao.getWarn2Count();
				usersList = dao.getWarn2(startRow, endRow);
			}else if(warn.equals("3")){//넘어가기
				count=dao.getWarn3Count();
				usersList = dao.getWarn3(startRow, endRow);
			}else{//아무것도 필터링 안할떄, 모두 가져와줌
				usersList = dao.getRepinfo(startRow, endRow);
			}
		}//if
	}//else
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
		
			<h1 align="center"> 관리자 신고 관리</h1>
			<form action="adminReportList.jsp">
				<table >
					<tr>
						<td>
							<select name="sel">
								<option value="userID" >신고대상 아이디</option>
								<option value="rep_reason" >신고 사유</option>
							</select>
							<input type="text" name="search" size="50"/>
							<input type="submit" value="검색"/>
						</td>
					</tr>
					<tr>
						<td></td>
					</tr>
					<tr>
						<td>
						<a href="adminReportList.jsp?warn=1">미처리</a>
						<a href="adminReportList.jsp?warn=2">경고</a>
						<a href="adminReportList.jsp?warn=3">넘어가기</a>
						</td>
					</tr>
				</table>
			</form><br/><br/><br/>
				<% if(count == 0){ %>
			<form action="adminDeletePro.jsp">
				<table>
					<tr>
						<td>신고대상(아이디) 신고수 신고자 신고날짜</td>
						<td>신고카테고리 신고사유 게시글 링크</td>
						<td>신고 상세내용</td>
					</tr>
					<tr>
						<td align="center"> <pre>아직 신고된 회원이 없습니다!!</pre></td>
					</tr>
				</table>
			</form>
				<%}else{%>
				<form action="adminDeletePro.jsp">
					<table>
					<%if(usersList !=null){ %>
							<th>신고대상</th>
							<th>신고수</th>
							<th>신고자</th>
							<th>신고날짜</th>
							<th>신고카테고리</th>
							<th>신고사유</th>
							<th>상세내용</th>
						<%for(int i = 0; i < usersList.size(); i++){
							ReportsDTO usersInfo = (ReportsDTO)usersList.get(i); %>
							<tr>
								<td><%=usersInfo.getUserID()%></td>
								<td><%=dao.getUser(usersInfo.getUserID()).getReportCount() %> </td>
								<td><%= usersInfo.getReporterID()%></td>
								<td><%=usersInfo.getRep_reg()%></td>
								<td><%=usersInfo.getCategory()%></td>
								<td><%=usersInfo.getRep_reason()%> </td>
								<td><%=usersInfo.getRep_content()%></td>
							</tr>
							<% if(usersInfo.getProcessing().equals("false")){%>
							<tr>
								<td colspan="7" text-align="left"> 
								<input type="button" value="넘어가기" onclick="window.location='adminDeletePro.jsp?res=1&rep_num=<%=usersInfo.getRep_num()%>&reUserID=<%=usersInfo.getUserID()%>'">
								<input type="button" value="경고" onclick="window.location='adminDeletePro.jsp?res=2&rep_num=<%=usersInfo.getRep_num()%>&reUserID=<%=usersInfo.getUserID()%>'">
								<input type="button" value="계정탈퇴" onclick="window.location='adminDeletePro.jsp?res=3&rep_num=<%=usersInfo.getRep_num()%>&reUserID=<%=usersInfo.getUserID()%>'">
								</td>
							</tr>
							<%}else{//if(usersInfo.getProcessing() 가 true)%>
							<tr>
								<td colspan="7" text-align="left"> 
								<input type="button" value="처리완료" disabled/> &nbsp;  <%=usersInfo.getResult() %>
								</td>
							</tr>
						 	<%}//else(usersInfo.getProcessing() "false")닫기 %>
						<%}//for문 닫는거 %>
				</table>
				</form>
					<%}else{//if (usersList !=null) 닫는것%>	
						<pre>해당 분류 신고가 없습니다</pre>	
					<%}%>
			
		
			<%-- 페이지 번호 --%>
				<div class="paging">
					<% if(count > 0) {
						// 페이지 번호를 몇개까지 보여줄것인지 지정
						int pageBlock = 4; 
						// 총 몇페이지
						int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
						// 현재 페이지에서 보여줄 첫번째 페이지번호
						int startPage = (int)((currentPage-1)/pageBlock) * pageBlock + 1; 
						// 현재 페이지에서 보여줄 마지막 페이지번호
						int endPage = startPage + pageBlock - 1; 
						// 마지막에 보여줄 페이지번호는, 전체 페이지 수에 따라 달라질 수 있다. 
						// 전체 페이지수(pageCount)가 위에서 계산한 endPage보다 작으면 전체 페이지수가 endPage. 
						if(endPage > pageCount) endPage = pageCount; 
						
						//++검색시, 페이지 번호 처리
						if(search !=null){
						
							// 왼쪽 
							if(startPage > pageBlock) { %>
								<a href="adminReportList.jsp?pageNum=<%=startPage-pageBlock %>&sel=<%=sel %>&search=<%=search%>" class="pageNums"> &lt; &nbsp;</a>
						<%	}
							
							// 페이지 번호 
							for(int i = startPage; i <= endPage; i++){ %>
								<a href="adminReportList.jsp?pageNum=<%=i%>&sel=<%=sel %>&search=<%=search%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
						<%	}
							
							// 오른쪽  
							if(endPage < pageCount) { %>
								&nbsp; <a href="adminReportList.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel %>&search=<%=search%>" class="pageNums"> &gt; </a>
						<%	}
						
						}else{//if검색 안 했을때
								// 왼쪽  
								if(startPage > pageBlock) { %>
									<a href="adminReportList.jsp?pageNum=<%=startPage-pageBlock %>&warn=<%=warn%>" class="pageNums"> &lt; &nbsp;</a>
							<%	}
								
								for(int i = startPage; i <= endPage; i++){ %>
									<a href="adminReportList.jsp?pageNum=<%=i%>&warn=<%=warn%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
							<%	}
								
								// 오른쪽  
								if(endPage < pageCount) { %>
									&nbsp; <a href="adminReportList.jsp?pageNum=<%=startPage+pageBlock%>&warn=<%=warn%>" class="pageNums"> &gt; </a>
							<%	}
						}//else 검색 안했을때 
					
					}//if(count > 0)%>
				<%}//else count!= 닫음 %>
					
				</div><%--pagenum --%>
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