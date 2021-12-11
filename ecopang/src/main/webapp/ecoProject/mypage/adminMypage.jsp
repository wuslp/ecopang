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
<head>
	<meta charset="UTF-8">
	<title>관리자 MYPAGE</title>
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



<%
	//세션에서 id뽑아서 id가 관리자것  admin이면 이 페이지 보여주기
	//일반회원 id이면 못 보도록 처리

	String thisuserID = (String) session.getAttribute("memId");
	if (!thisuserID.equals("admin")) {//임시
%>
	<script>
		alert("관리자 페이지 입니다");
		history.back();
	</script>
<%
	}
%>
<%

	String userID=(String)request.getParameter("userID");

//내정보/ 참여중인활동/ 완료된활동/ 좋아요누른 모임/ 내 작성글/ 내 작성댓글
//세션에서 id 가져오기
 //id로 해당 id의 정보 users테이블에서 가져오기
 /*주석처리*/
 
 	//userID로 회원정보얻어오기
	UsersDAO dao = new UsersDAO();
	UsersDTO userid =dao.getUser(userID);
	
	//ㄴDB에서 userID의 프사이름 get
	String imgs =userid.getUser_img();
	
	
	//userID 로 nickname 같은 것 activities 에서 찾아서 활동 내역으로 뿌려주기.
	List articleList = null;
	articleList = dao.getAct(userID);
	
	 //완료된 활동내역 가져오기
	 List endList = null;
	// endList = dao.getActend(userID);
	 
	 //로그인된 id가 좋아요 한 소모임 글 가져오기
	List likeList = null;
	//likeList = dao.getGroupLikes(userID);
	 
	
	//작성한 후기글 가져오기
	List revList = null;
	//*revList = dao.getRevlist(userID);
	 //후기글의 원 소모임 제목 가져오기
	 int group_num =0;
	 //dao.getReTitle(group_num);
	 
	//작성한 커뮤니티 글 가져오기 
	List topList = null;
	//topList = dao.getToplist(userID);
	 
	//작성한 댓글 가져오기
	List comList = null;
	//*comList =dao.getTopicComments(userID);
	
	//댓글에 해당하는 타이틀 메서드
	int toptitle=0;
	dao.getComTopic(toptitle);
	
%>
<%
	// ** 게시글 페이지 관련 정보 세팅 ** 
	//1.완료된 활동- 한페이지에 보여줄 게시글의 수(변수로 지정할것이다.나중에 다시 바꿀수도 있으니) 
	int pageSize = 3; 

	//1.완료된 활동- 현재 페이지 번호  
	String pageNum = request.getParameter("pageNum"); // 요청시 페이지번호가 넘어왔으면 꺼내서 담기. 
	if(pageNum == null){ // mypage.jsp 라고만 요청했을때, 즉 pageNum 파라미터 안넘어왔을때.
		pageNum = "1";
	}
	System.out.println("pageNum : "+pageNum);
	
	
	//1.완료된 활동- 현재 페이지에 보여줄 게시글 시작과 끝 등등 정보 세팅 
	int currentPage = Integer.parseInt(pageNum); // 계산을 위해 현재페이지 숫자로 변환하여 저장 
	int startRow = (currentPage - 1) * pageSize + 1; // 페이지 시작글 번호 
	int endRow = currentPage * pageSize; // 페이지 마지막 글번호
	//DB에서 정렬했을때 가져오는 번호범위이다 첫번째부터 열개까지 가져와라 ~같은 
	
	
	//1.완료된 활동- 완료된 활동 글 가져오기  ->db가야됨
	//완료된 활동- 전체 글의 개수 가져오기 
	int count = dao.getActCount(userID);   
	System.out.println("count : " + count);
	
	if(count > 0){
		endList = dao.getActend(userID, startRow, endRow); //글을 싹다가져오는것이아니고 startRow 부터 end까지 
	}
	
	//--------------------------------------------------------------------------------------------------
	//2.커뮤니티 글 
	int pageSize2 = 1; 

	//2.커뮤니티 글- 현재 페이지 번호  
	String pageNum2 = request.getParameter("pageNum2"); 
	if(pageNum2 == null){ 
		pageNum2 = "1";
	}
	System.out.println("pageNum2 : "+pageNum2);
	
	
	//2.커뮤니티 글- 현재 페이지에 보여줄 게시글 시작과 끝
	int currentPage2 = Integer.parseInt(pageNum2); 
	int startRow2 = (currentPage2 - 1) * pageSize2 + 1;  
	int endRow2 = currentPage2 * pageSize2;
	
	
	//2.커뮤니티 글 가져오기  
	// 전체 글의 개수 가져오기 
	int count2 =dao.getTopCount(userID);
	System.out.println("count2 : "+count2);
	
	if(count2 >0){
		topList=dao.getTop(userID, startRow2, endRow2);
	}
	
	//---------------------------------------------------------------------------------------------------
	//3.댓글
	int pageSize3 = 2; 

	//3.커뮤니티 댓글  
	String pageNum3 = request.getParameter("pageNum3");  
	if(pageNum3 == null){
		pageNum3 = "1";
	}
	System.out.println("pageNum3 : "+pageNum3);
	
	
	//3.커뮤니티 댓글 
	int currentPage3 = Integer.parseInt(pageNum3);  
	int startRow3 = (currentPage3 - 1) * pageSize3 + 1; 
	int endRow3 = currentPage3 * pageSize3; 
	
	
	//3.커뮤니티 댓글  
	// 전체 글의 개수
	int count3 =dao.getTopCount(userID);
	System.out.println("count3 : "+count3);
	
	if(count3 >0){
		comList=dao.getComm(userID, startRow3, endRow3);
	}
	
	//4.후기글 가져오기
	int pageSize4 = 1; 

	//4.글- 현재 페이지 번호  
	String pageNum4 = request.getParameter("pageNum4"); 
	if(pageNum4 == null){ 
		pageNum4 = "1";
	}
	System.out.println("pageNum4 : "+pageNum4);
	
	
	//4.후기글- 현재 페이지에 보여줄 게시글 시작과 끝
	int currentPage4 = Integer.parseInt(pageNum4); 
	int startRow4 = (currentPage4 - 1) * pageSize4 + 1;  
	int endRow4 = currentPage4 * pageSize4; 
	
	
	//4.후기 글 가져오기  
	// 전체 글의 개수 가져오기 
	int count4 =dao.getRevCount(userID);
	System.out.println("count4 : "+count4);
	if(count4 >0){
		revList=dao.getRevlist(userID, startRow4, endRow4);
	}
	
	
	//5.좋아요글 가져오기
	int pageSize5 = 4; 

	//5.현재 페이지 번호  
	String pageNum5 = request.getParameter("pageNum5"); 
	if(pageNum5 == null){
		pageNum5 = "1";
	}
	System.out.println("pageNum5 : "+pageNum5);
	
	
	//5.글- 현재 페이지에 보여줄 게시글 시작과 끝
	int currentPage5 = Integer.parseInt(pageNum5);  
	int startRow5 = (currentPage5 - 1) * pageSize5 + 1;  
	int endRow5 = currentPage5 * pageSize5; 
	
	
	//5.좋아요 글 가져오기  
	// 전체 글의 개수 가져오기 
	int count5 =dao.getRevCount(userID);
	System.out.println("count5 : "+count5);
	if(count4 >0){
		likeList=dao.getGroupLikes(userID, startRow5, endRow5);
	}
	
%>


	<%--회원탈퇴 팝업창 js 처리--%>
	<script>
	   function userDelete(inputForm){
	      var url = "userDeleteForm.jsp";
	      open(url, "userDeleteForm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=800, height=1000");
	   }
	</script>
<body>
	<div class="main">
		<div class="header">
			<%--헤더--%>
		</div>
		
		
		
		
		<div class="body">
			<div class="main">
			
				<%if(userID.equals("admin")){ %>
				<div class="pageList"><%--왼쪽 으로 --%>
					<ul>
						<li><a href="/ecopang/ecoProject/mypage/adminReportList.jsp">신고목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminUserList.jsp">회원목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminDeleteUser.jsp">탈퇴목록</a></li>
						<li><a href="/ecopang/ecoProject/mypage/adminEventInfo.jsp">이벤트/공지사항 관리</a></li>
					</ul>
				</div>
				<%} %>
			
	<div class="bod2">
			<div class="main_content">
				<h3>내정보</h3>
					<form name="inputForm">
						<table border="1" >
							<tr>
								<td rowspan="6">
								<%System.out.println(userid.getUser_img()); %>
								<%	//이미지가 없을경우
									if(imgs == null || imgs == ""){
								%>
									<img src="/ecopang/imgs/proImg.png" width="300"/>
										
								<%	}else{//이미지가 있다면 
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
								<input type="button" value="관리자 정보 수정" onclick="window.location='myPageModifyForm.jsp'" class="button"/>
								</td>
							</tr>
						</table>
					</form>	
				</div><%--내정보 div --%>
			
			
			
				<div class="main_content">
					<form><h3>참여중인 활동 </h3>
						<%//확인용 출력 
						if(articleList != null) {
						if(articleList.size() <= 3){
						%>
						<% //3개 이하일때
							for(int i = 0; i < articleList.size(); i++){
								ActDTO article = (ActDTO)articleList.get(i); 
							%>
							<table border="1" style="float:left;">
							<tr>
								<td><h5>활동제목 : <%=article.getAct_title()%>&nbsp;</h5></td><td><input type="button" value="참가 중" onclick="" class="button"/></td>
							<tr>
								<td>장소장소 : <%=article.getPlace() %>&nbsp;</td>
								<td> <%=dao.getActCount(article.getAct_num()) %> / <%=article.getMax_user()%>&nbsp;</td>
							<tr>
								<td>시간 : &nbsp;</td>
							</tr>
							<tr>
								<td><%=article.getAct_date() %>&nbsp;</td>
							</tr>
							<tr>
								<td>
								<%	//이미지가 없을경우
									if(imgs == null || imgs == ""){
								%>
									<%--<h3>찾는 이미지가 없습니다</h3>
									디폴트 이미지 줄것--%>
									<img src="/ecopang/ecoProject/imgs/proImg.png" width="25"/>
										
								<%	}else{//이미지가 있다면 
								%>
									<img src="/ecopang/ecoProject/imgs/<%=imgs%>" width="25"/>
									<%}//else%>
								</td>
							</tr>
						</table>
							<%}//for%>
						<%}else if(articleList.size() >= 3){
							//3개 이상일때 
							for(int i = 0; i < 3; i++){
								ActDTO article = (ActDTO)articleList.get(i); 
								
						%>
						
						<table border="1" style="float:left;">
							<tr>
								<td><h5>활동제목 : <%=article.getAct_title()%>&nbsp;</h5></td><td><input type="button" value="참가 중" onclick="" class="button"/></td>
							
							<tr>
								<td>장소장소 : <%=article.getPlace() %>&nbsp;</td>
								<td> <%=dao.getActCount(article.getAct_num()) %> / <%=article.getMax_user()%>&nbsp;</td>
							<tr>
								<td>시간 : &nbsp;</td>
							</tr>
							<tr>
								<td><%=article.getAct_date() %>&nbsp;</td>
							</tr>
							<tr>
								<td>
								<%	//이미지가 없을경우
									if(imgs == null || imgs == ""){
								%>
									<%--<h3>찾는 이미지가 없습니다</h3>
									디폴트 이미지 줄것--%>
									<img src="/ecopang/ecoProject/imgs/proImg.png" width="25"/>
										
								<%	}else{//이미지가 있다면 
								%>
									<img src="/ecopang/ecoProject/imgs/<%=imgs%>" width="25"/>
									<%}//else%>
								</td>
							</tr>
						</table>
							<%}//for%>
						<%}else{//else if%>
						<table>
							<tr>
								<td><h4>참여중인 활동이 없습니다 ! 활동을 참여해 보세요 </h4> </td>
							<tr>
						</table>
						<%} 
						}else{//else if%>
						<table>
							<tr>
								<td><h4>참여중인 활동이 없습니다 ! 활동을 참여해 보세요 </h4> </td>
							<tr>
						</table>
						<%} %>
					</form>
				</div><%--참여중인 활동 div --%>
				
				<div class="main_content">
					<h3>완료된 활동</h3>
					<%if(endList != null){ %>
					<form>
						<% for(int i = 0; i < endList.size(); i++){
								ActDTO endArticle = (ActDTO)endList.get(i); 
								 if(endArticle != null){
						%>
						<table border="1" style="float:left;">
						<tr>
							<td><h5>활동제목 : <%=endArticle.getAct_title() %>&nbsp;</h5></td><td><input type="button" value="종료" onclick="" class="button2"/></td>
						<tr>
							<td>장소장소 : <%=endArticle.getPlace() %>&nbsp;</td>
							<td><%=dao.getActCount(endArticle.getAct_num()) %> / <%=endArticle.getMax_user()%>&nbsp;</td>
							
						<tr>
							<td>시간 : <%=endArticle.getAct_date() %>&nbsp;</td>
						</tr>
						</table>
								<%} //if(endArticle != null)
							}//for%>
					</form>
				</div>
			
					<div>
						<table align="center">
							<tr class="h50 lh50">
							    <td colspan="4" class="border-none pagination-p text-center">
							
							<% if(count > 0) {
									// 페이지 원 몇개까지
									int pageBlock = 4; 
									// 총페이지
									int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);//=5/3 +1;
									// 현재 페이지에서 보여줄 첫번째 페이지번호
									int startPage = (int)((currentPage-1)/pageBlock) * pageBlock + 1;//(0/4)*4 +1
									int endPage = startPage + pageBlock - 1; //1+4-1
									// 마지막페이지
									if(endPage > pageCount) endPage = pageCount; //4>2 
									// 왼쪽 화살표
									if(startPage > pageBlock) { %>
									<div class="li-btn">
							            <a class="icon-prev" href="adminMypage.jsp?pageNum=<%=startPage-pageBlock %>" >
							                <span></span>
							            </a>
							        </div>
								<%	}	
										for(int i = startPage; i <= endPage; i++){
								%> 
							            <div class="li">	
							            	<a href="adminMypage.jsp?pageNum=<%=i%>" class="a dot"><%=i %></a>
							            </div>
									<%}// 오른쪽 화살표 
									if(endPage > pageCount) { %>
										<div class="li-btn">
							                <a class="icon-next" href="adminMypage.jsp?pageNum=<%=startPage+pageBlock%>" ></a>
							                    <span></span>
							            </div>
									<%}
								}//if(count > 0)%>
							 	   </td>
								</tr>
							</table>
					<%}else{//else endList 가있으면 %>
						<form>
							<table>
								<tr>
									<td><h6>완료된 활동 리스트가 없습니다 . </h6></td>
								</tr>
							</table>
						</form>
					 <%}%>
				</div><%--완료된 활동 div --%>
		
				<div class="main_content">
					<h3>좋아요 누른 모임</h3>
					
					<form>
							<%if(likeList != null){ 
								for(int i =0;i<likeList.size();i++){//있는만큼 반복ㅎ
								GroupDTO gto =(GroupDTO)likeList.get(i); //담기%>
						<table>
								<%if(gto.getGroup_img() != null){ %>
							<tr>
								<td><img src="/ecopang/ecoProject/img/<%=gto.getGroup_img()%>" width="50px"/></td>
							</tr>
								<%}else{ %>
								<img src="/ecopang/ecoProject/img/ecopang_logo.png" width="50px"/>
								<% } %>
							<tr>
								<td><%=gto.getGroup_title()%></td>
							</tr>
						</table>
							<%} %>
							
						<table align="center">
							<tr class="h50 lh50">
							    <td colspan="4" class="border-none pagination-p text-center">
							
							<% if(count5 > 0) {
									// 페이지 원 몇개까지
									int pageBlock5 = 4; 
									// 총페이지
									int pageCount5 = count5 / pageSize5 + (count5 % pageSize5 == 0 ? 0 : 1);//=5/3 +1;
									// 현재 페이지에서 보여줄 첫번째 페이지번호
									int startPage5 = (int)((currentPage5-1)/pageBlock5) * pageBlock5 + 1;//(0/4)*4 +1
									int endPage5 = startPage5 + pageBlock5 - 1; //1+4-1
									// 마지막페이지
									if(endPage5 > pageCount5) endPage5 = pageCount5; //4>2 
									// 왼쪽 화살표
									if(startPage5 > pageBlock5) { %>
									<div class="li-btn">
							            <a class="icon-prev" href="mypage.jsp?pageNum5=<%=startPage5-pageBlock5 %>" >
							                <span></span>
							            </a>
							        </div>
								<%	}
											for(int i = startPage5; i <= endPage5; i++){
									%> 
							            <div class="li">
							                	<a href="mypage.jsp?pageNum5=<%=i%>" class="a dot"><%=i %></a>
							            </div>
									<%}// 오른쪽 화살표 
									if(endPage5 > pageCount5) { %>
										<div class="li-btn">
							                <a class="icon-next" href="mypage.jsp?pageNum5=<%=startPage5+pageBlock5%>" ></a>
							                    <span></span>
							            </div>
									<%}
								}//if(count > 0)%>
							
						<%}else{ %>
						<table>
							<tr>
								<td><pre>좋아요 한 소모임이 없습니다! 소모임 좋아요를 어서 눌러보세요!</pre></td>
							</tr>
						</table>	
						<%} %>
					</form>
				</div><%--좋아요 누른 모임 --%>
		
		
				<div class="main_content">
					<h3>내 작성글</h3>
		 			
					<form>
					<div>
					<%if(revList != null){ %>
						<% for(int i = 0; i < revList.size(); i++){
							
							ReviewDTO reviewArticle = (ReviewDTO)revList.get(i); 
								if(reviewArticle != null){
						%>
						<table border="1" style="float:left;">
						<tr>
							<td><h5><%=dao.getReTitle(reviewArticle.getGroup_num())%>&nbsp;</h5></td>
						<tr>
							<td><%=reviewArticle.getRev_content() %>&nbsp;</td>
						</tr>
						</table>
							<%} 
							}%>
					<%} %>
					</div>
					
					<div>
					<%if(topList != null){ %>
						<% for(int i = 0; i < topList.size(); i++){
							
							TopicDTO topArticle = (TopicDTO)topList.get(i); 
								 if(topArticle != null){
						%>
						<table border="1" style="float:left;">
						<tr>
							<td><h5><%=topArticle.getTpc_title() %>&nbsp;</h5></td>
						<tr>
							<td><%=topArticle.getTpc_content() %>&nbsp;</td>
						</tr>
						</table>
							 <%} 
							}%>
						</div>
					</form>
				</div>
			
					<div>
						<table align="center">
							<tr class="h50 lh50">
							    <td colspan="4" class="border-none pagination-p text-center">
							
							<% if(count2 > 0) {

									int pageBlock2 = 4; 
									int pageCount2 = count2 / pageSize2 + (count2 % pageSize2 == 0 ? 0 : 1);
									int startPage2 = (int)((currentPage2-1)/pageBlock2) * pageBlock2 + 1;
									int endPage2 = startPage2 + pageBlock2 - 1; //
									if(endPage2 > pageCount2) endPage2 = pageCount2; //
									if(startPage2 > pageBlock2) { %>
									<div class="li-btn">
							            <a class="icon-prev" href="adminMypage.jsp?pageNum2=<%=startPage2-pageBlock2%>&pageNum4=<%=startPage2-pageBlock2%>" >
							                <span></span>
							            </a>
							        </div>
								 <%}								
										for(int i = startPage2; i <= endPage2; i++){
									%> 
							            <div class="li">
							            	<a href="adminMypage.jsp?pageNum2=<%=i%>&pageNum4=<%=i%>" class="a dot"><%=i %></a>
							            </div>
									<%}// 오른쪽 화살표 
										if(endPage2 < pageCount2) { %>
										<div class="li-btn">
										&nbsp; <a href="adminMypage.jsp?pageNum2=<%=startPage2+pageBlock2%>&pageNum4=<%=startPage2+pageBlock2%>" class="pageNums"> &gt; </a>
										</div>
									<%	}
								}%>
							 	   </td>
								</tr>
							</table>
					<%}else{ %>
					<table>
						<tr>
							<td><pre>작성한 글이 없습니다 ! 커뮤니티 게시판을 이용해 보세요 !</pre></td>
						</tr>
					</table>	
					<%} %>
				</div><%--내 작성글 div --%>		
		
		
		
				<div class="main_content">
					<h3>내 작성 댓글</h3>
					<%if(comList != null){ %>
					<form>
						<% for(int i = 0; i < comList.size(); i++){
							
							TopicCommentDTO comArticle = (TopicCommentDTO)comList.get(i); 
								 if(comArticle != null){
						%>
						<table border="1" style="float:left;">
						<tr>
							<td><h5><%=dao.getComTopic(comArticle.getTpc_num())%></h5></td>
						<tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;<%=comArticle.getTpc_com_content() %>&nbsp;</td>
						</tr>
						</table>
						<%} 
						}%>
					</form>
				</div>
			
					<div class="main_content">
						<table align="center">
							<tr class="h50 lh50">
							    <td colspan="4" class="border-none pagination-p text-center">
							
							<% if(count3 > 0) {

									int pageBlock3 = 4; 
									int pageCount3 = count3 / pageSize3 + (count3 % pageSize3 == 0 ? 0 : 1);//
									int startPage3 = (int)((currentPage2-1)/pageBlock3) * pageBlock3 + 1;//
									int endPage3 = startPage3 + pageBlock3 - 1; //
									if(endPage3 > pageCount3) endPage3 = pageCount3; // 
									if(startPage3 > pageBlock3) { %>
									<div class="li-btn">
							            <a class="icon-prev" href="adminMypage.jsp?pageNum3=<%=startPage3-pageBlock3%>" >
							                <span></span>
							            </a>
							        </div>
								<%	}								
										for(int i = startPage3; i <= endPage3; i++){
									%> 
							            <div class="li">
							            	<a href="adminMypage.jsp?pageNum3=<%=i%>" class="a dot"><%=i %></a>
							            </div>
									<%}// 오른쪽 화살표 
									if(endPage3 > pageCount3) { %>
										<div class="li-btn">
							                <a class="icon-next" href="adminMypage.jsp?pageNum3=<%=startPage3+pageBlock3%>" ></a>
							                    <span></span>
							            </div>
								<%}
								}%>
							 	   </td>
								</tr>
							</table>
					<%} %>
				</div><%--댓글 --%>
				
				
				<br/><br/><br/>
		</div><%--body div --%>	
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