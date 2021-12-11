<%@page import="ecopang.model.UsersDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자목록 탈퇴계정</title>
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
	//세션에서 id뽑아서 id가 관리자것  admin이면 이 페이지 보여주기
	//일반회원 id이면 못 보도록 처리

	String sel="";
	String search = null;
	if(request.getParameter("sel") != null) {
		sel = request.getParameter("sel");
		if (sel.equals("3")) { sel = "탈퇴"; }
		else if(sel.equals("4")) { sel = "강제탈퇴"; }
		else { sel = "전체";}
	}
	
	System.out.println("sel : " + sel);
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	
	// ** 게시글 페이지 관련 정보 세팅 ** 
	// 한페이지에 보여줄 게시글의 수
	int pageSize = 3; 

	// 현재 페이지 번호  
	String pageNum = request.getParameter("pageNum"); // 요청시 페이지번호가 넘어왔으면 꺼내서 담기. 
	if(pageNum == null){ //pageNum 파라미터 안넘어왔을때.
		pageNum = "1";
	}
	
	// 현재 페이지에 보여줄 게시글 시작과 끝 등등 정보 세팅 
	int currentPage = Integer.parseInt(pageNum); // 계산을 위해 현재페이지 숫자로 변환하여 저장 
	int startRow = (currentPage - 1) * pageSize + 1; // 페이지 시작글 번호 
	int endRow = currentPage * pageSize; // 페이지 마지막 글번호
	//DB에서 정렬했을때 가져오는 번호범위이다 첫번째부터 열개까지 가져와라 ~같은 
	int count = 0;
	UsersDAO dao = new UsersDAO();
	List delList = null;
	
	if(search != null){//검색하면
		count = dao.getSelCount(sel, search);
		if(count > 0){
			delList = dao.getSelInfo(sel, search, startRow, endRow);
		}
	}else{//검색안하면
		count = dao.getDelCount(sel);
		if(count > 0 ){
			delList = dao.getDeleteinfo(sel, startRow, endRow);
		}
	}
	
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
			<form>
				<select name="sel" id="sel" onchange="selChange()">
					<option value="1" >선택</option>
					<option value="2" selected>전체</option>
					<option value="3" <% if(sel.equals("탈퇴")){ %> selected <% } %>>탈퇴</option>
					<option value="4" <% if(sel.equals("강제탈퇴")){ %> selected <% } %>>강제탈퇴</option>
				</select>
				아이디 <input type="text" name="search"/>
				<input type="submit" value="검색"/>
			</form>
				<table>
					<th>아이디</th>
					<th>닉네임</th>
					<th>처리사항</th>
					<th>상세내용</th>
					<% if(count ==0){ %>
					<tr>
						<td colspan="4">탈퇴한 회원이 없습니다</td>
					</tr>
				<% } else {
					if (delList != null) {
						for (int i = 0; i < delList.size(); i++){
							UsersDTO userArticle = (UsersDTO)delList.get(i);
							if (userArticle != null) {	%>
								<tr>
									<td><%=userArticle.getUserID()%></td>
									<td><%=userArticle.getNickname()%></td>
									<td><%=userArticle.getUser_state()%></td>
									<td><%=userArticle.getComplaints()%></td>
								</tr>
						<%	}
						}
					} 
				} %>
				</table>
				<div class="paging">
			<% if(count>0){
				// 페이지 번호를 몇개까지 보여줄것인지 지정 
				int pageBlock=3;
				// 총 몇페이지가 나오는지 
				int pageCount=count/pageSize+(count % pageSize==0 ? 0 :1);
				// 현재 페이지에서 보여줄 첫번째 페이지 번호 
				int startPage=(int)((currentPage-1)/pageBlock)* pageBlock+1;
				// 현재 페이지에서 보여줄 마지막 페이지 번호
				int endPage=startPage+pageBlock-1;
				
				if(endPage>pageCount)endPage=pageCount;
				
				//검색시, 페이지 번호 처리 
				if(sel !=null && search !=null){	
					// 왼쪽 꺽쇄
					if(startPage>pageBlock){ %>
						<a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=startPage-pageBlock %>&sel=<%=sel%>&search=<%=search%>"> &lt;</a>			
				<% }
					// 페이지 번호 뿌리기
					for(int i=startPage; i<=endPage; i++){ %>
						<a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; <%= i %> &nbsp; </a>
				<%} 		
					// 오른쪽 꺽쇄
					if(endPage<pageCount){ %>
						 &nbsp; <a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel%>&search=<%=search%>"> &gt; </a>
				<%}
				}else{//검색 안했을때
					//왼쪽 꺽쇄
					if(startPage>pageBlock){ %>
						<a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=startPage-pageBlock %>" class="pageNums"> &lt; </a>
				<% 	}		
					// 페이지 번호 뿌리기 
					for(int i=startPage; i<=endPage;i++){ %>
						<a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=i%>"> &nbsp; <%= i %> &nbsp; </a>
				<% 	}	
					// 오른쪽 꺽쇄
					if(endPage<pageCount){ %>
					 	  <a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp?pageNum=<%=startPage+pageBlock%>"> &gt; </a>
		      <%  } 
					
				}// else
			} %>		
			</div>
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