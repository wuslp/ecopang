<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.InfoDAO"%>
<%@page import="ecopang.model.InfoDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@
500&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet"
	type="text/css">
<head>
<meta charset="UTF-8">
<title>infoList/공지사항 목록 페이지</title>
</head>
<%
	// 한 페이지에 보여줄 게시글의 수
	int pageSize = 10;

	// 현재 페이지 번호
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null) {
		pageNum = "1";
	}

	// 현재 페이지에 보여줄 게시글 시작과 끝 등등 정보 세팅
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;

	InfoDAO dao = new InfoDAO();
	// 전체 글의 개수 가져오기
	int count = dao.getInfoCount();
	//System.out.println("infolist.jsp >> count : "+count);

	List infoList = null;
	if (count > 0) {
		infoList = dao.getInfos(startRow, endRow);
	}
	int number = count - (currentPage - 1) * pageSize;

	// 날짜 출력 형태 패턴 생성 
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
<div id="infoList" class="info_content_area">
	<div class="info-content">		
		<div class="leftbar"> 
			<ul>
				<li><a href="/ecopang/ecoProject/news/eventList.jsp">이벤트</a></li>
				<Li><a class="active1" href="/ecopang/ecoProject/news/infoList.jsp">공지사항</a></Li>
			</ul>
		</div>	<!-- leftbar -->	
		
		<!-- 공지사항 컨텐츠 -->
	<div class="info-right">
		<div class="info-content">
			<div class="info_button">
			<table>
				<%
					if (!(session.getAttribute("memId") == null || !session.getAttribute("memId").equals("admin"))) {
				%>
				<tr>
					<td><button onclick="window.location='infoWriteForm.jsp'">
							글쓰기</button></td>
				</tr>
				<%
					}
				%>
				<br/>
			</table>
			</div>	
			
			<div class="info-inner">
			<table>	
				<%
					if (count == 0) {
				%>
				<tr>
					<td align="center">공지사항이 없습니다.</td>
				</tr>
				<%
					} else {
				%>
				<tr class="table_top">
					<!-- <td>No.</td> -->
					<td >제목</td>
					<td>작성일</td>
				</tr>
				<%
					for (int i = 0; i < infoList.size(); i++) {
							InfoDTO dto = (InfoDTO) infoList.get(i);
				%>
				<tr>
					<%-- <td><%= dto.getInfo_num() %></td> --%>
					<td align="left"><a
						href="infoContent.jsp?info_num=<%=dto.getInfo_num()%>"><%=dto.getInfo_title()%></a>
					</td>
					<td><%=dto.getInfo_reg()%></td>
				</tr>
				<%
					}
				%>

			<%
				}
			%>
			</table>
			</div>
			</div>
			</div>

			<%-- 페이지 번호 --%>
			<div class="number">
				<%
					if (count > 0) {
						int pageBlock = 5;
						int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
						int startPage = (int) ((currentPage - 1) / pageBlock) * pageBlock + 1;
						int endPage = startPage + pageBlock - 1;
						if (endPage > pageCount)
							endPage = pageCount;

						if (startPage > pageBlock) {
				%>
				<a href="infoList.jsp?pageNum=<%=startPage - pageBlock%>"
					class="pageNums">&lt;</a>
				<%
					}
						for (int i = startPage; i <= endPage; i++) {
				%>
				<a href="infoList.jsp?pageNum=<%=i%>" class="pageNums"> &nbsp;
					<%=i%> &nbsp;
				</a>
				<%
					}
						if (endPage < pageCount) {
				%>
				<a href="infoList.jsp?pageNum=<%=startPage + pageBlock%>"
					class="pageNums">&gt;</a>
				<%-- &lt; == < --%>
				<%
					}
					}
				%>
			</div>
			<!-- 페이지번호 div 닫음 -->
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
	</div><!-- #page -->
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
</html>