<%@page import="ecopang.model.MypageDAO"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="ecopang.model.ReviewDTO"%>     
<%@page import="ecopang.model.TopicCommentDTO"%>
<%@page import="ecopang.model.TopicDTO"%>
<%@page import="ecopang.model.ActDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
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
	<title>MYPAGE</title>
</head>
<%
//내정보/ 참여중인활동/ 완료된활동/ 좋아요누른 모임/ 내 작성글/ 내 작성댓글
//세션에서 id 가져오기
 //id로 해당 id의 정보 users테이블에서 가져오기
 /*주석처리*/
	String userID = (String)session.getAttribute("memId");
	
 	//userID로 회원정보얻어오기
	UsersDAO dao = new UsersDAO();
	UsersDTO userid =dao.getUser(userID);
	MypageDAO mydao = new MypageDAO();
	
	
	//ㄴDB에서 userID의 프사이름 get
	String imgs =userid.getUser_img();
	
	
	//userID 로 nickname 같은 것 activities 에서 찾아서 활동 내역으로 뿌려주기.
	List articleList = null;
	
	
	 //완료된 활동내역 객체생성
	 List endList= null;
	 
	//로그인된 id가 좋아요 한 소모임 글 가져오기
	List likeList = null;
	//likeList = dao.getGroupLikes(userID);
	 
	
	
	
%>
<%	
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null) {
		pageNum = "1";
	}

	
	
	 //----------------------------------------------------------------------
	//참여중인 활동 목록 페이징 변수 생성
	int actPageSize = 3; //한 페이지당 들어갈 컨텐트 숫자
	String actPageNum = request.getParameter("actPageNum");
	if (actPageNum == null) {
		actPageNum = "1";
	}

	int currentActPage = Integer.parseInt(actPageNum);
	int actStartRow = (currentActPage - 1) * actPageSize + 1;
	int actEndRow = currentActPage * actPageSize;
	int userActCount = mydao.myActCount(userID);
	System.out.println("userActCount : " + userActCount);
	if(	userActCount > 0){
		articleList = mydao.myAct(userID, actStartRow, actEndRow);
	}
	

//------------------------------------------------------------------------
	
	//완료된 활동 페이징 변수생성
	int endActPageSize = 3; //한 페이지당 들어갈 컨텐트 숫자
	String endActPageNum = request.getParameter("endActPageNum");
	if (endActPageNum == null) {
		endActPageNum = "1";
	}

	int endActCurrentPage = Integer.parseInt(endActPageNum);
	int endActStartRow = (endActCurrentPage - 1) * actPageSize + 1;
	int endActEndRow = endActCurrentPage * endActPageSize;
	int myEndActCount = mydao.myEndActCount(userID);
	if(	myEndActCount > 0){
		endList = mydao.myEndAct(userID, endActStartRow, endActEndRow);
	}
	
	System.out.println("완료활동 카운트 : " + myEndActCount);
	

	
	//--------------------------------------------------------------------------------------------------

	//내가 좋아요 한 글 페이징 처리  변수생성
	int likeConPageSize = 5; //한 페이지당 들어갈 컨텐트 숫자
	String likeConPageNum = request.getParameter("likeConPageNum");
	if ( likeConPageNum == null) {
		likeConPageNum = "1";
	}

	int likeConCurrentPage = Integer.parseInt(likeConPageNum);
	int likeConStartRow = (likeConCurrentPage - 1) * likeConPageSize + 1;
	int likeConEndRow = likeConCurrentPage * likeConPageSize;

	//---------------------------------------------------------------------------------------------------
	//내가 작성한 글 페이지 처리 변수생성
	
	int myConPageSize = 5; //한 페이지당 들어갈 컨텐트 숫자
	String myConPageNum = request.getParameter("myConPageNum");
	if ( myConPageNum == null) {
		myConPageNum = "1";
	}

	int myConCurrentPage = Integer.parseInt(myConPageNum);
	int myConStartRow = (myConCurrentPage - 1) * myConPageSize + 1;
	int myConEndRow = myConCurrentPage * myConPageSize;
	
	
	
	//내가 작성한 댓글 페이지 처리 변수생성
	int myComPageSize = 5; //한 페이지당 들어갈 컨텐트 숫자
	String myComPageNum = request.getParameter("myComPageNum");
	if ( myComPageNum == null) {
		myComPageNum = "1";
	}
	int myComCurrentPage = Integer.parseInt(myComPageNum);
	int myComStartRow = (myComCurrentPage - 1) * myComPageSize + 1;
	int myComEndRow = myComCurrentPage * myComPageSize;
	
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


	<%--회원탈퇴 팝업창 js 처리--%>
	<script>
	   function userDelete(inputForm){
	      var url = "userDeleteForm.jsp";
	      open(url, "userDeleteForm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=800, height=1000");
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
					<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->

<div id="info" class="site-content">
<div id="infoList" class="info_content_area">		

<%if(userID.equals("admin")){%>
   <div class="bod2">
         <div class="main_content">
            <h3 class="mp-title">관리자 정보</h3>
               <form name="inputForm">
                  <table class="mp-table1" >
                     <tr>
                        <td rowspan="6">
                        <%   //이미지가 없을경우
                           if(imgs == null || imgs == ""){
                        %>
                           <img src="/ecopang/ecoProject/imgs/default.png" width="300"/>
                              
                        <%   }else{//이미지가 있다면 
                        %>
                           <img src="/ecopang/ecoProject/imgs/<%=imgs%>" width="200"/>
                           <%}//else%>
                        </td>
                     </tr>
                     <tr>
                        <td><h3>아이디(이메일)</h3>
                        <h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=userid.getUserID() %></h3></td>
                     </tr>
                     <tr>
                        <td><h3>이름/ 별명/ 등급</h3></td>
                        <td><h3><%=userid.getName() %> / <%=userid.getNickname() %> / <%=userid.getUser_level() %></h3></td>
                     </tr>
                     <tr>
                        <td colspan="2">
                        <input type="button" value="관리자 정보 수정" onclick="window.location='mypageModifyForm.jsp'" class="button"/>
                        </td>
                     </tr>
                  </table>
                  <h3 class="mp-title">관리 목록</h3>
					<ul>
						<li><a href="/ecopang/ecoProject/mypage/adminReportList.jsp">신고목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminUserList.jsp">회원목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp">탈퇴목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminEventInfo.jsp">이벤트/공지사항 관리</a></li>
					</ul>    
               </form>   
            </div><%--관리자정보 div --%>
         </div>
<%}else {%>
		<div class="bod2">
			<div class="main_content">
				<h3 class="mp-title">마이페이지</h3>
					<form>
						<table class="mp-table1" >
							<tr>
								<td class="td1" rowspan="5">
								<%	//이미지가 없을경우
									if(imgs == null || imgs == ""){
							
								%>
									<img src="/ecopang/ecoProject/imgs/default.png" width="300"/>
										
								<%	}else{//이미지가 있다면 
								%>
									<img src="/ecopang/ecoProject/imgs/<%=imgs%>" width="200"/>
									<%}//else%>
								</td>
								<td class="td2"><h3>아이디(이메일)</h3></td>
								<td><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=userid.getUserID() %></h3></td>
							</tr>
							<tr>
								<td class="td2"><h3>이름/ 별명/ 등급</h3></td>
								<td><h3><%=userid.getName() %> / <%=userid.getNickname() %> / <%=userid.getUser_level() %></h3></td>
							</tr>
							<tr>
								<td class="td2"><h3>관심지역</h3></td>
								<td><h3><%=userid.getUser_city1()%><%=userid.getUser_district1() %><%=userid.getUser_city2()%><%=userid.getUser_district2() %><%=userid.getUser_city3()%><%=userid.getUser_district3() %></h3></td>
							</tr>
							<tr>
								<td class="td2"><h3>생년월일</h3></td>
								<td><h3><%=userid.getBirth() %></h3></td>
							</tr>
						</table>
					</form>	
							<div class="mpbutton">
								<input type="button" value="정보수정" onclick="window.location='mypageModifyForm.jsp'" class="button"/>
								<input type="button" value="탈퇴" onclick="userDelete(this.form)" class="button"/>
							</div>	
				</div><%--내정보 div --%>
			
			
			
				<div class="mypageActivity">
					<form><h3>참여중인 활동</h3>
						<%//확인용 출력 
						if(articleList != null) {
							if(articleList.size() > 0){
								for(int i = 0; i < articleList.size(); i++){
								ActDTO article = (ActDTO)articleList.get(i); 
							%>
								<table border="1" style="float:left;">
									<tr>
										<td><h5>활동제목 : <a href="/ecopang/ecoProject/group/groupContent.jsp?group_num=<%=article.getGroup_num()%>"><%=article.getAct_title()%></a>&nbsp;</h5></td><td></td>
									<tr>
										<td> 장소 : <%=article.getPlace() %>&nbsp;</td>
									<tr>
										<td colspan="2">시간 : <%=article.getAct_date() %>&nbsp;</td>
									</tr>
									<tr>
										<td><input type="button" value="참가 중" onclick="" class="button"/> <%=dao.getActCount(article.getAct_num()) %> / <%=article.getMax_user()%></td>
									</tr>
								</table>
							<%}//for문 끝%>
							<!-- 활동 3개 초과 참석시 페이징 처리 -->
						<%}
					 }else{%>
						<h4>참여중인 활동이 없습니다. 마음에 드는 소모임을 찾아 활동에 참여 해보세요!</h4>
						<button type="button" onclick="location.href='/ecopang/ecoProject/group/groupMain.jsp'" class="button"> Let's Go!</button>
					<%}%>
					</form>
				</div><%--참여중인 활동 div --%>
				
				
				<!-- 활동 페이지 넘버 부분  -->
				<div class="gc-actnum">
					<%
					if (userActCount > 0) {
						int actPageBlock = 5; //보여줄 페이지 숫자 1, 2, 3
						int actPageCount = userActCount / actPageSize + (userActCount % actPageSize == 0 ? 0 : 1);
						int actStartPage = (int) ((currentActPage - 1) / actPageBlock) * actPageBlock + 1;
						int actEndPage = actStartPage + actPageBlock - 1;
						if (actEndPage > actPageCount) actEndPage = actPageCount;
						if (actStartPage > actPageBlock) {%>
							<a href="mypage.jsp?actPageNum=<%=actStartPage - actPageBlock%>&pageNum=<%=pageNum%>">&lt;</a>
						<%}
						for (int i = actStartPage; i <= actEndPage; i++) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&actPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
						<%}
						if (actEndPage < actPageCount) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&actPageNum=<%=actStartPage + actPageBlock%>">&gt;</a>
						<%}
					}%>
				</div>
				
				
				<div class="mypageActivity">
					<form><h3>완료된 활동</h3>
					<%if(endList != null){ 
							if(endList.size() > 0){
								 for(int i = 0; i < endList.size(); i++){
										ActDTO endArticle = (ActDTO)endList.get(i); %>
										 
										<table border="1" style="float:left;">
											<tr>
												<td><h5>활동제목 : <a href="/ecopang/ecoProject/group/groupContent.jsp?group_num=<%=endArticle.getGroup_num()%>"><%=endArticle.getAct_title()%></a>&nbsp;</h5></td>
											<tr>
												<td>장소장소 : <%=endArticle.getPlace() %>&nbsp;</td>
											<tr>
												<td>시간 : <%=endArticle.getAct_date() %>&nbsp;</td>
											</tr>
											<tr>
												<td><input type="button" value="종료" class="endbutton"/></td>
											</tr>
										</table>
								<%}//for
							}//if endList.size > 0 %>
					<%}else{//else endList 가 없으면 %>
						<h4>종료된 활동이 없습니다.</h4>
					 <%}%>
					</div> <%--완료된 활동 div --%>
			
					<div class="gc-actnum">
					<%
					if (myEndActCount > 0) {
						int endActPageBlock = 5; //보여줄 페이지 숫자 1, 2, 3
						int endActPageCount = myEndActCount / endActPageSize + (myEndActCount % endActPageSize == 0 ? 0 : 1);
						int endActStartPage = (int) ((endActCurrentPage - 1) / endActPageBlock) * endActPageBlock + 1;
						int endActEndPage = endActStartPage + endActPageBlock - 1;
						if (endActEndPage > endActPageCount) endActEndPage = endActPageCount;
						if (endActStartPage > endActPageBlock) {%>
							<a href="mypage.jsp?endPageNum=<%=endActStartPage - endActPageBlock%>&pageNum=<%=pageNum%>">&lt;</a>
						<%}
						for (int i = endActStartPage; i <= endActEndPage; i++) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&endActPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
						<%}
						if (endActEndPage < endActPageCount) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&endPageNum=<%=endActStartPage + endActPageBlock%>">&gt;</a>
						<%}
					}%>
				</div>
					
					
					
					
					
					<%-- 좋아요 누른 게시물들 테이블 --%>
				<%
					List contentList = mydao.myLikeContent(userID, likeConStartRow, likeConEndRow);
					int likeContentCount = mydao.myLikeContentCount(userID);
				%>
				<div class="main_content2">
					<div class="mypageLike">
					<h3>좋아요 누른 게시글/소모임</h3>
					<form>
						<table>
							<th>카테고리</th>
							<th>제목</th>
							<th>작성일</th>
							<%if(contentList != null){ 
								for(int i =0;i<contentList.size();i++){//있는만큼 반복ㅎ
								String[] sdto =	(String[])contentList.get(i); //담기
								String url;
								if(sdto[0].equals("게시글")) {
									url = "/ecopang/ecoProject/topic/topicContent.jsp?tpc_num=";
								} else if(sdto[0].equals("소모임")) {
									url = "/ecopang/ecoProject/group/groupContent.jsp?group_num=";
								} else {
									url = "/ecopang/ecoProject/group_activity_review/reviewAll.jsp?group_num=";
								}
								
								%>
								<%if(sdto != null){ %>
								<tr>
									<td><%=sdto[0] %></td>
									<td><a href="<%=url%><%= sdto[1] %>"><%=sdto[2]%></a></td>
									<td><%=sdto[4] %></td>
								</tr>
								
				
							<%} else { %>
								<tr>
									<td colspan="4">좋아요 누른 게시물이 없습니다.</td>
								</tr>
							<%}
							}%>
						</table>
					</form>
					</div>
				</div>
				<div class="gc-actnum">
					<%
					if (likeContentCount > 0) {
						int likeConPageBlock = 5; //보여줄 페이지 숫자 1, 2, 3
						int likeConPageCount = likeContentCount / likeConPageSize + (likeContentCount % likeConPageSize == 0 ? 0 : 1);
						int likeConStartPage = (int) ((likeConCurrentPage - 1) / likeConPageBlock) * likeConPageBlock + 1;
						int likeConEndPage = likeConStartPage + likeConPageBlock - 1;
						if (likeConEndPage > likeConPageCount) likeConEndPage = likeConPageCount;
						if (likeConStartPage > likeConPageBlock) {%>
							<a href="mypage.jsp?actPageNum=<%=likeConStartPage - likeConPageBlock%>&pageNum=<%=pageNum%>">&lt;</a>
						<%}
						for (int i = likeConStartPage; i <= likeConEndPage; i++) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&likeConPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
						<%}
						if (likeConEndPage < likeConPageCount) {%>
							<a href="mypage.jsp?pageNum=<%=pageNum%>&likeConPageNum=<%=likeConStartPage + likeConPageBlock%>">&gt;</a>
						<%}
					}%>
				</div>
			<%  } %>
						<!-- 내가 작성한 게시물 -->
							<%
							List myContentList = mydao.myContents(userID, myComStartRow, myComEndRow);
							int myContentCount = mydao.myContentCount(userID);
								%>
								<div class="main_content2">
									<div class="mypageLike">
									<h3>내가 작성한 게시물</h3>
									<form>
										<table>
											<th>카테고리</th>
											<th>제목</th>
											<th>작성일</th>
											<%if(myContentList != null){ 
												for(int i =0;i<myContentList.size();i++){//있는만큼 반복ㅎ
													String[] sdto =	(String[])myContentList.get(i); //담기
													System.out.println(sdto);
													String url;
													if(sdto[0].equals("게시글")) {
														url = "/ecopang/ecoProject/topic/topicContent.jsp?tpc_num=";
													} else if(sdto[0].equals("소모임")) {
														url = "/ecopang/ecoProject/group/groupContent.jsp?group_num=";
													} else {
														url = "/ecopang/ecoProject/group_activity_review/reviewAll.jsp?group_num=";
													}%>
													<%if(sdto != null){ %>
													<tr>
														<td><%=sdto[0] %></td>
														<td><a href="<%=url%><%= sdto[1] %>"><%=sdto[2]%></a></td>
														<td><%=sdto[4] %></td>
													</tr>
													<%}
												} %>
											<%}else{ %>
												<tr>
													<td colspan = "3"> 작성된 게시물/소모임이 없습니다.</td>
												</tr>										
											<%} %>
									</table>
									
								<div class="gc-actnum">
									<%
									if (myContentCount > 0) {
										int myConPageBlock = 5; //보여줄 페이지 숫자 1, 2, 3
										int myConPageCount = myContentCount/ myConPageSize + (myContentCount % myConPageSize == 0 ? 0 : 1);
										int myConStartPage = (int) ((likeConCurrentPage - 1) / myConPageBlock) * myConPageBlock + 1;
										int myConEndPage = myConStartPage + myConPageBlock - 1;
										if (myConEndPage > myConPageCount) myConEndPage = myConPageCount;
										if (myConStartPage > myConPageBlock) {%>
											<a href="mypage.jsp?myConPageNum=<%=myConStartPage - myConPageBlock%>&pageNum=<%=pageNum%>">&lt;</a>
										<%}
										for (int i = myConStartPage; i <= myConEndPage; i++) {%>
											<a href="mypage.jsp?pageNum=<%=pageNum%>&myConPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
										<% }
										if (myConEndPage < myConPageCount) {%>
											<a href="mypage.jsp?pageNum=<%=pageNum%>&myConPageNum=<%=myConStartPage + myConPageBlock%>">&gt;</a>
										<% }
									}%>
								</div>	
						</form>
						</div>
						</div>
				
				<!-- 내가 작성한 댓글 -->
					<%
							List myCommentList = mydao.myCommentList(userID, myComStartRow,myComEndRow);
							int myCommentCount = mydao.myCommentCount(userID);
								%>
								<div class="main_content2">
									<div class="mypageLike">
									<h3>내가 작성한 댓글</h3>
									<form>
										<table>
											<th>카테고리</th>
											<th>원글 제목</th>
											<th>댓글 내용</th>
											<th>작성일</th>
											<%if(myCommentList != null){ 
												for(int i =0;i<myCommentList.size();i++){//있는만큼 반복ㅎ
													String[] sdto =	(String[])myCommentList.get(i); //담기
													String url = "";
													if(sdto[0].equals("게시글")) {
														url = "/ecopang/ecoProject/topic/topicContent.jsp?tpc_num=";
													} else if(sdto[0].equals("이벤트")) {
														url = "/ecopang/ecoProject/news/groupContent.jsp?eve_num=";
													} %>
													<%if(sdto != null){ %>
													<tr>
														<td><%=sdto[0] %></td>
														<td><a href="<%=url%><%= sdto[1] %>"><%=sdto[2]%></a></td>
														<td><%= sdto[3] %></td>
														<td><%=sdto[4] %></td>
													</tr>
													<%}
												} %>
											<%}else{ %>
												<tr>
													<td colspan = "3"> 작성한 댓글이 없습니다.</td>
												</tr>										
											<%} %>
									</table>
									
								<div class="gc-actnum">
									<%
									if (myCommentCount > 0) {
										int myComPageBlock = 5; //보여줄 페이지 숫자 1, 2, 3
										int myComPageCount = myCommentCount/ myComPageSize + (myCommentCount % myComPageSize == 0 ? 0 : 1);
										int myComStartPage = (int) ((myComCurrentPage - 1) / myComPageBlock) * myComPageBlock + 1;
										int myComEndPage = myComStartPage + myComPageBlock - 1;
										if (myComEndPage > myComPageCount) myComEndPage = myComPageCount;
										if (myComStartPage > myComPageBlock) {%>
											<a href="mypage.jsp?myComPageNum=<%=myComStartPage - myComPageBlock%>&pageNum=<%=pageNum%>">&lt;</a>
										<%}
										for (int i = myComStartPage; i <= myComEndPage; i++) {%>
											<a href="mypage.jsp?pageNum=<%=pageNum%>&myComPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
										<% }
										if (myComEndPage < myComPageCount) {%>
											<a href="mypage.jsp?pageNum=<%=pageNum%>&myComPageNum=<%=myComStartPage + myComPageBlock%>">&gt;</a>
										<% }
									}%>
								</div>	
						</form>
						</div>
						</div>
				
				
				
				
				
				
				
			<% } %>

				
		
				
				</div>
				
				<br/><br/><br/>
		</div><%--body div --%>	
		
	
</div> <!-- content-area --> 
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
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>

</html>