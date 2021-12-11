<%@page import="ecopang.model.ReviewLikesDAO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.ReviewDTO"%> 
<%@page import="ecopang.model.UsersDTO"%> 
<%@page import="java.util.List"%>
<%@page import="ecopang.model.ReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>review</title>
	<style>
	#button{
		border-radius:50%;
		width:60px;
		height:60px;
		background:#2ea0ff;
		font-size: 50px;
		font-weight: 3000;
		color:#fff;
		border:none;
		box-shadow: 2px 2px 2px #888;
	}
	#followplus { 
	position:absolute; 
	top:500px; right:10%;
	}
	
	</style>
	<script src="//code.jquery.com/jquery-3.6.0.js"></script>
</head>

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
<!-- 글씨체  -->
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<!-- 글씨체  -->

 <!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >


	
	<script>
		function report(inputForm) {
			var url = "/ecopang/ecoProject/mypage/reportForm.jsp?category="+inputForm.category.value+"&num="+inputForm.num.value+"&userID="+inputForm.userID.value;
			open(
					url,
					"reviewAll",
					"toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=500, height=400");
		}
	</script>
	

<%	
	//12페이지에서 group_num 받아오기	
	//+++ 임시
	String userID = (String)session.getAttribute("memId");
	int group_num = 0;
	if(request.getParameter("group_num") != null) {
		group_num = Integer.parseInt(request.getParameter("group_num"));
	}

	
	String sort = request.getParameter("sort");
	if(sort == null){
		sort="1";
	}
	//후기 전체 글을 담아올것
	int revCount = 0;//후기글 전체 개수
	List revList = null;//후기글 담아올 List 변수 생성
	
	ReviewDAO dao = new ReviewDAO();//사용할 java dao 객체 생성
	
	//페이지 정보** 
	// 한페이지에 보여줄 게시글의 수(변수로 지정할것이다.나중에 다시 바꿀수도 있으니) 
	int pageSize = 3; 

	// 현재 페이지 번호  
	String pageNum = "1"; 
	if(request.getParameter("pageNum") != null){ // 
		pageNum = request.getParameter("pageNum");
	}
	
	// 현재 페이지에 보여줄 게시글 시작과 끝 등등 정보 세팅 
	int currentPage = Integer.parseInt(pageNum); // 계산을 위해 현재페이지 숫자로 변환하여 저장 
	int startRow = (currentPage - 1) * pageSize + 1; // 페이지 시작글 번호 
	int endRow = currentPage * pageSize; // 페이지 마지막 글번호
	//DB에서 정렬했을때 가져오는 번호범위이다 첫번째부터 열개까지 가져와라 ~같은 

	// ++ 서치 한다면 밑에서 검색어 작성해서 list요청했다면 , 아래 reSel/reSearch 변수에 파라미터가 들어갈 것 임.
	String revSel = "userID";
	if(request.getParameter("revSel") != null) {
		revSel = request.getParameter("revSel");
	}
	String revSearch = "";
	if(request.getParameter("revSearch") != null) {
		revSearch = request.getParameter("revSearch");
	}
	
	//++
	revCount = dao.getRevPhoto(revSel,revSearch, group_num);//검색된 글의 총 개수 가져오는것
	//검색한 글이 하나라도 있으면 검색한 글 가져오기
	
	if(revCount >0){
		revList = dao.getRevPho(startRow, endRow, revSel, revSearch, group_num, sort);
	}
	//좋아요
	ReviewLikesDAO like = new ReviewLikesDAO();
	System.out.println("revList 확인 :"+revList);
	//--------------------------------------------------------------
	
%>

	<script>
	$(window).scroll(function(){
		var scrollTop = $(document).scrollTop();
		$("#followplus").stop();
		$("#followplus").animate( {"top": scrollTop +650},250);
		});
	$(function(){
		  $("input[name=onlyPho]").click(function(){
			  alert("모두 보기");
			  $(location).attr('href',"reviewAll.jsp?group_num=<%=group_num %>");
		  });
		});
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
					<li><a href="/ecopang/ecoProject/main/main.jsp">메인</a></li>
					<li><a href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
					<li><a class="active" href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
					<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->
		
		<div class="main_content3">
			<div class="reviewSearch">
				<h1>후기 더보기</h1>
				<%--작성자 또는 내용으로 검색하기 --%>
				<form action="reviewPhoto.jsp">
					<input type="hidden" value="<%= group_num %>" name="group_num" />
					<select name="revSel">
						<option value="userID" <% if(revSel.equals("userID")){ %> selected <% } %> >작성자</option>
						<option value="rev_content" <% if(revSel.equals("rev_content")){ %> selected <% } %> >내용</option>
					</select>
					<input type="text" name="revSearch"/>
					<input type="submit" value="검색"/>
				</form>
				<br/>
				<span class="reviewSort"><a href="reviewPhoto.jsp?sort=2&pageNum=<%=pageNum%>&revSel=<%=revSel%>&revSearch=<%=revSearch%>&group_num=<%=group_num %>">인기순</a></span>
				<span class="reviewSort"><a href="reviewPhoto.jsp?pageNum=<%=pageNum%>&revSel=<%=revSel%>&revSearch=<%=revSearch%>&group_num=<%=group_num %>">최신순</a></span> 
				<span class="onlyPhoto">사진 후기만 보기 <input type="checkBox" name="onlyPho" value="null" checked></span>
			</div>
				<div class="reviewItems">
					<%if(revList != null){
						for(int i =0; i<revList.size();i++){
							if(revList.get(i) != null) {
								ReviewDTO revdto = (ReviewDTO)revList.get(i);
								UsersDTO uudto = dao.getUserInfo(revdto.getRev_num()); 
								int rev_num = revdto.getRev_num();
								boolean userLikeRev = like.userLikesReview(userID, rev_num);
								int revLikeCount = like.reviewLikeCount(rev_num);%>
								<div class="reviewItem">
									<div class="topItem">
									<%  if(uudto.getUser_img() == null){ %>
						 					<img src="/ecopang/ecoProject/imgs/default.png" class="userImg"/>
									<%  }else{ %>
						 					<img src="/ecopang/ecoProject/imgs/<%=uudto.getUser_img()%>" class="userImg"/>
				 					<%  } %>
									<h1><%=revdto.getUserID()%></h1>
									<%-----------------------------------------------좋아요/신고하기 넣기---------------------------------------------- --%>
									<div class="topBtns">	
										<%if(userID == null){ %>
	         								<button onclick="javascript:likebtn()" class="likeBtn">♧</button>
	          								x&nbsp;<%=revLikeCount %>
	      								<%}else{%>
						         			<div class="rs<%=i%>">
						           			 <%if(userLikeRev==true){ %>
						             			<button onclick="callByAjax<%=i %>(<%=rev_num%>)" class="likeBtn">♣</button>
						              			x&nbsp;<%=revLikeCount %>
						          			 <%}else{ %>
						             			<button onclick="callByAjax<%=i %>(<%=rev_num%>)" class="likeBtn">♧</button>
						              			x&nbsp;<%=revLikeCount %>
						      				<%} %>
			      							</div>
	   									<%} %>
										<form name="inputForm">
											<button onclick="report(this.form)" class="reportBtn">신고하기</button>
											<input type="hidden" name="category" value="후기"/> 
											<input type="hidden" name="num" value="<%= revdto.getRev_num()%>"/> 
											<input type="hidden" name="userID" value="<%= revdto.getUserID()%>"/> 
										</form>	
									</div>
								</div>
								<div class="bottomItem">
									<% if(revdto.getRev_img() != null){ %>
										<div class="reviewPhoto">
							 				<img src="/ecopang/ecoProject/imgs/<%=revdto.getRev_img()%>">
										</div>	
									<% } %>
									<div class="reviewContent"><%=revdto.getRev_content() %></div>
								</div>
							</div>
						<%	}
						}
					}else{%>
						<h1>작성된 후기가 없습니다! 첫 후기를 작성해 보세요 !</h1>
					<%} %>
				</div>
		</div>
		<%-- 페이지 번호 --%>
		<div class="paging">
		<% if(revCount > 0) {
			// 페이지 번호를 몇개까지 보여줄것인지 지정
			int pageBlock = 3; 
			// 총 몇페이지가 나오는지 계산 
			int pageCount = revCount / pageSize + (revCount % pageSize == 0 ? 0 : 1);
			// 현재 페이지에서 보여줄 첫번째 페이지번호
			int startPage = (int)((currentPage-1)/pageBlock) * pageBlock + 1; 
			// 현재 페이지에서 보여줄 마지막 페이지번호 
			int endPage = startPage + pageBlock - 1; 
			// 마지막에 보여줄 페이지번호는, 전체 페이지 수에 따라 
			if(endPage > pageCount) endPage = pageCount; 
			
			//++검색시, 페이지 번호 처리
			// 왼쪽 화살표 
			if(startPage > pageBlock) { %>
				<a href="reviewPhoto.jsp?pageNum=<%=startPage-pageBlock %>&revSel=<%=revSel%>&revSearch=<%=revSearch%>&group_num=<%=group_num %>" class="pageNums"> &lt; &nbsp;</a>
		<%	}
			// 페이지 번호 뿌리기 
			for(int i = startPage; i <= endPage; i++){ %>
				<a href="reviewPhoto.jsp?pageNum=<%=i%>&revSel=<%=revSel%>&revSearch=<%=revSearch%>&group_num=<%=group_num %>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
		<%	}
			// 오른쪽 화살표 : 전체 페이지 개수(pageCount)가 endPage(현재보는페이지에서의 마지막번호) 보다 크면 
			if(endPage < pageCount) { %>
				&nbsp; <a href="reviewPhoto.jsp?pageNum=<%=startPage+pageBlock%>&revSel=<%=revSel%>&revSearch=<%=revSearch%>&group_num=<%=group_num %>" class="pageNums"> &gt; </a>
		<%	}
		}//if(count > 0)%>			
			<div id="followplus">
				<input type="button" value="+" id="button" onclick="window.location='reviewWriteForm.jsp?group_num=<%=group_num%>'">
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
<script>
function likebtn()
{ alert('로그인 후 이용 가능한 기능입니다.'); }

function callByAjax0(num){
	var rev_num = num
	var userID=	"<%=userID%>"
	var group_num = <%=group_num%>
	propage ='/ecopang/ecoProject/group_activity_review/reviewLikePro.jsp?i=0';
	 $.post( // 보내기 방식
		   propage,  // 받는 페이지
		   { //보내줄 데이터
		      rev_num : rev_num,
		      userID : userID,
		      group_num : group_num
		   },
		   function(data){ //결과받아서
		      $('.rs0').empty().append(data); //rs class로 보내주기
		   },
		   'html'
	);
}
function callByAjax1(num){
	var rev_num = num
	var userID=	"<%=userID%>"
	var group_num = <%=group_num%>
	propage ='/ecopang/ecoProject/group_activity_review/reviewLikePro.jsp?i=1';
	 $.post( // 보내기 방식
		   propage,  // 받는 페이지
		   { //보내줄 데이터
		      rev_num : rev_num,
		      userID : userID,
		      group_num : group_num
		   },
		   function(data){ //결과받아서
		      $('.rs1').empty().append(data); //rs class로 보내주기
		   },
		   'html'
	);
}
function callByAjax2(num){
	var rev_num = num
	var userID=	"<%=userID%>"
	var group_num = <%=group_num%>
	propage ='/ecopang/ecoProject/group_activity_review/reviewLikePro.jsp?i=2';
	 $.post( // 보내기 방식
		   propage,  // 받는 페이지
		   { //보내줄 데이터
		      rev_num : rev_num,
		      userID : userID,
		      group_num : group_num
		   },
		   function(data){ //결과받아서
		      $('.rs2').empty().append(data); //rs class로 보내주기
		   },
		   'html'
	);
}

</script>
</html>