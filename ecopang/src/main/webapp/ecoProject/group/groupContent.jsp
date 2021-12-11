<%@page import="ecopang.model.ReviewDTO"%>
<%@page import="ecopang.model.ReviewDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.ActDAO"%>
<%@page import="ecopang.model.ActDTO"%>
<%@page import="ecopang.model.ActivityJoinDAO"%>
<%@page import="ecopang.model.GroupLike"%>
<%@page import="ecopang.model.GroupLikeDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- 글씨체  -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap"
	rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap"
	rel="stylesheet">
<!-- 글씨체  -->
<head>
<meta charset="UTF-8">
<title> 소모임 게시글 </title>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet"
	type="text/css">
</head>
<%
int group_num = 0;

if (request.getParameter("group_num") != null) //만약에 받아온 번호가 있으면
	group_num = Integer.parseInt(request.getParameter("group_num")); //그걸로 세팅해주고 

System.out.println(group_num);
//현재 페이지 번호 
int pageNum = 1;
if (request.getParameter("pageNum") != null)
	pageNum = Integer.parseInt(request.getParameter("pageNum"));

// 가져올 변수 
String userID = (String) session.getAttribute("memId");

UsersDAO udao = new UsersDAO();
UsersDTO udto = new UsersDTO();

// 소모임에서 그룹 하나 가져오기 
GroupDAO dao = new GroupDAO();
GroupDTO dto = dao.getGroup(group_num);
System.out.println(dto);
List groupList = null;

//그룹좋아요를 위한 객체 생성 및 변수 생성
GroupLike grouplike = new GroupLike();
boolean userLikeGroups = grouplike.userLikesGroup(userID, group_num);
int grouplikecount = grouplike.groupLikeCount(group_num);

// 검색어 작성해서 list 요청, 아래 sel/search 변수에 파라미터가 들어감
//	String sel= request.getParameter("sel");
//	String search=request.getParameter("search");

//활동 목록 페이징
int actPageSize = 3; //한 페이지당 들어갈 컨텐트 숫자
String actPageNum = request.getParameter("actPageNum");
if (actPageNum == null) {
	actPageNum = "1";
}

int currentActPage = Integer.parseInt(actPageNum);
int actStartRow = (currentActPage - 1) * actPageSize + 1;
int actEndRow = currentActPage * actPageSize;

//활동 목록 불러오기위한 객체 생성 및 변수 생성
ActDTO actdto = new ActDTO();
ActDAO actdao = new ActDAO();

ActivityJoinDAO join = new ActivityJoinDAO();

int actCount = actdao.getActCount(group_num);
List actList = null;
actList = actdao.getActivities(actStartRow, actEndRow, group_num);

// 후기 대략 몇개 보여줄건지
int revPageSize = 3;
String revPageNum = request.getParameter("revPageNum");
if (revPageNum == null) {
	revPageNum = "1";
}

int currentRevPage = Integer.parseInt(revPageNum);
int revStartRow = (currentRevPage - 1) * revPageSize + 1;
int revEndRow = currentRevPage * revPageSize;

// 후기 불러오기 위한 객체 생성
ReviewDTO revdto = new ReviewDTO();
ReviewDAO revdao = new ReviewDAO();
int revCount = revdao.getRevCount(group_num);
List revList = null;
revList = revdao.getRevArticles(1, 3, group_num);

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
		response.sendRedirect("loginPro.jsp");
	}
} else {
	udto = udao.getUser((String) session.getAttribute("memId"));
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
<script>
		function groupLikeAjax(){
			var group_num = <%=group_num%> 
			var userID="<%=userID%>"   
			propage ='/ecopang/ecoProject/group/groupLikeContentPro.jsp';
			$.post( // 보내기 방식
				propage,  // 받는 페이지
				{ //보내줄 데이터
					group_num : group_num,
					userID : userID
				},
				function(data){ //결과받아서
					$('.rs').empty().append(data); //rs class로 보내주기
				},
				'html'
			);
		}
		function likebtn()
		{ alert('로그인 후 이용 가능한 기능입니다.'); }
	</script>
<script>
			function popup(act_num){
				var url = "/ecopang/ecoProject/activity/chat.jsp?act_num=" + act_num
				var option ="width=400, height=600, left=100, top=50"
				window.open(url,option);
			}
		</script>

<script>
		function createPopup(group_num){
			var url = "/ecopang/ecoProject/activity/activityCreateForm.jsp?group_num=" + group_num
			var option ="width=400, height=300, left=100, top=50"
			window.open(url,option);
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
					<!--  회원버튼 -->
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
								href="/ecopang/ecoProject/main/signupForm.jsp">회원가입</a>
							<%
							} else {
							%>
							<a href="/ecopang/ecoProject/main/logout.jsp">로그아웃</a> <a
								href="/ecopang/ecoProject/mypage/mypage.jsp">마이페이지</a>
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
						<li><a href="/ecopang/ecoProject/news/eventList.jsp">소식</a></li>
						<li><a class="active"
							href="/ecopang/ecoProject/group/groupMain.jsp">소모임</a></li>
						<li><a href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
					</ul>
				</nav>
			</div>
			<!-- header-wrap -->
		</header>
		<!-- 헤더 끝 -->


		<div id="topic" class="site-content">
			<div id="topic_main" class="gc_content_area">

				<div class="gc-title">
					<h3><%=dto.getGroup_title()%></h3>
					&nbsp;&nbsp;&nbsp;
					<div>
					<%if(userID == null){ %>
         			<button onclick="javascript:likebtn()" class="likeBtn">♧</button>
          			x&nbsp;<%=grouplikecount%>
					<%
					} else {
					%>
					<div class="rs">
						<%
						if (userLikeGroups == true) {
						%>
						<input onclick="groupLikeAjax()" type="button" value="♣" class="likeBtn"/>
						x&nbsp;<%=grouplikecount%>
						<%
						} else {
						%>
						<input onclick="groupLikeAjax()" type="button" value="♧" class="likeBtn"/>
						x&nbsp;<%=grouplikecount%>
						<%
						}
						%>
					</div>
					<%
					}
					%>
					</div>
					
				</div>
				<!-- gc-title -->
				<div class="gc-button1">
					<%
					if (userID == null) {
					%>
					<input type="button" value="소모임 목록"
						onclick="window.location='groupMain.jsp?pageNum=<%=pageNum%>'" />
					<%
					} else {
					%>
					<%
					if (!userID.equals(dao.getGroupCreator(group_num))) {
					%>
					<input type="button" value="소모임 목록"
						onclick="window.location='groupMain.jsp?pageNum=<%=pageNum%>'" />
					<%
					} else {
					%>
					<input type="button" value="소모임 목록"
						onclick="window.location='groupMain.jsp?pageNum=<%=pageNum%>'" />
					<input type="button" value="수정"
						onclick="window.location='groupModifyForm.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>'" />
					<input type="reset" value="삭제"
						onclick="window.location='groupDeletePro.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>'" />
					<%
					}
					%>
					<%
					}
					%>
				</div>
				<div class="gc-title2">
					<a href="#info">소개글</a>&nbsp; <a id="info"></a> <a href="#active">활동</a>&nbsp;
					<a id="active"></a> <a href="#review">후기</a> <a id="review"></a>
				</div>
				<div class="gc-content">
					<div class="gc-content1">
						<a
						<%
						if (dto.getGroup_img() == null) {
						%>
							href="groupCotent.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>">
							<img src="/ecopang/ecoProject/imgs/groupDefault.png"> <%
						 } else {
						 %> <img src="/ecopang/ecoProject/imgs/<%=dto.getGroup_img()%>">
						<%
						}
						%>
						</a>

					</div>

					<div class="gc-content2">
						<%=dto.getGroup_content()%>
					</div>
				</div>

				<!--활동 -->
				<div class="gc-act">
					<h3>활동</h3>

					<div class="gc-actbutton">
						<%
						if (userID == null) {
						%>
						<input type="button" value="활동 목록"
							onclick="window.location='/ecopang/ecoProject/activity/activityList.jsp?group_num=<%=group_num%>'" />
						<%
						} else {
						%>
						<%
						if (userID.equals(dao.getGroupCreator(group_num))) { //그룹 개설자만 활동 추가가 가능하도록 해둔겁니댜
						%>
						<input type="button" value="활동 목록"
							onclick="window.location='/ecopang/ecoProject/activity/activityList.jsp?group_num=<%=group_num%>'" />
						<input type="button" value="추가"
							onclick="createPopup(<%=group_num%>)" />
						<%
						} else {
						%>
						<input type="button" value="활동 목록"
							onclick="window.location='/ecopang/ecoProject/activity/activityList.jsp?group_num=<%=group_num%>'" />
						<%
						}
						%>
						<%
						}
						%>
					</div>
				</div>
				<div class="gc-actbox">
					<%
					// 활동 목록 불러오기
					if (actList != null) {
						for (int i = 0; i < actList.size(); i++) {
							actdto = (ActDTO) actList.get(i);
							int act_num = actdto.getAct_num();
							boolean userJoinAct = join.userAct(userID, act_num);
							int joinCount = join.actJoinCount(act_num);
							int maxUser = actdto.getMax_user();
					%>
					<div class="gc-actbox1">
						활동 :
						<%=actdto.getAct_title()%><br /> 장소 :
						<%=actdto.getPlace()%>
						<br /> 시간 :
						<%=actdto.getAct_date()%>
						&nbsp;
						<%=actdto.getAct_time()%><br />
						<%
						if (userID == null) {
						%>
						<%=joinCount%>
						명 참가중 (참석 기능은 로그인 후 이용 가능합니다.)
						<%
						} else {
						%>
						<div class="joinrs<%=i%>">
							<%
							if (userJoinAct == true) {
							%>
							<input onclick="joinByAjax<%=i%>(<%=act_num%>,<%=maxUser%>)"
								type="button" value="참가중" />
							<%=joinCount%>/
							<%=maxUser%>
							</br> <input type="button" onclick="popup(<%=act_num%>)" value="채팅하기" />
							<%
							} else {
							%>
							<input onclick="joinByAjax<%=i%>(<%=act_num%>,<%=maxUser%>)"
								type="button" value="참가" />
							<%=joinCount%>/
							<%=maxUser%></br>

							<%
							}
							%>
						</div>
					
					<%
					}
					%>
					</div>
					<%
					}
					%>
					<%
					} else {
					%>
					아직 등록된 활동이 없습니다.
					<%
					}
					%>
				</div>



				<script>
             function joinByAjax0(num,maxUser){
         		var act_num = num
         		var maxUser = maxUser
         		var userID=	"<%=userID%>"
         		propage ='activityJoinPro.jsp?i=0';
         		 $.post( // 보내기 방식
         			   propage,  // 받는 페이지
         			   { //보내줄 데이터
         			      act_num : act_num,
         			      userID : userID,
         			      maxUser : maxUser
         			   },
         			   function(data){ //결과받아서
         			      $('.joinrs0').empty().append(data); //rs class로 보내주기
         			   },
         			   'html'
         		);
         	}
             function joinByAjax1(num, maxUser){
          		var act_num = num
          		var maxUser = maxUser
          		var userID=	"<%=userID%>"
          		propage ='activityJoinPro.jsp?i=1';
          		 $.post( // 보내기 방식
          			   propage,  // 받는 페이지
          			   { //보내줄 데이터
          			      act_num : act_num,
          			      userID : userID,
          			      maxUser : maxUser
          			   },
          			   function(data){ //결과받아서
          			      $('.joinrs1').empty().append(data); //rs class로 보내주기
          			   },
          			   'html'
          		);
          	}
             function joinByAjax2(num,maxUser){
          		var act_num = num
          		var maxUser = maxUser
          		var userID=	"<%=userID%>"
          		propage ='activityJoinPro.jsp?i=2';
          		 $.post( // 보내기 방식
          			   propage,  // 받는 페이지
          			   { //보내줄 데이터
          			      act_num : act_num,
          			      userID : userID,
          			   	  maxUser : maxUser
          			   },
          			   function(data){ //결과받아서
          			      $('.joinrs2').empty().append(data); //rs class로 보내주기
          			   },
          			   'html'
          		);
          	}
             
             </script>

				<!-- 활동 페이지 넘버 부분  -->
				<div class="gc-actnum">
					<%
					if (actCount > 0) {
						int actPageBlock = 3; //보여줄 페이지 숫자 1, 2, 3
						int actPageCount = actCount / actPageSize + (actCount % actPageSize == 0 ? 0 : 1);
						int actStartPage = (int) ((currentActPage - 1) / actPageBlock) * actPageBlock + 1;
						int actEndPage = actStartPage + actPageBlock - 1;
						if (actEndPage > actPageCount)
							actEndPage = actPageCount;
						if (actStartPage > actPageBlock) {
					%>
					<a
						href="groupContent.jsp?actPageNum=<%=actStartPage - actPageBlock%>&group_num=<%=group_num%>&pageNum=<%=pageNum%>">&lt;</a>
					<%
					}
					for (int i = actStartPage; i <= actEndPage; i++) {
					%>
					<a
						href="groupContent.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>&actPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;
					</a>
					<%
					}
					if (actEndPage < actPageCount) {
					%>
					<a
						href="groupContent.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>&actPageNum=<%=actStartPage + actPageBlock%>">&gt;</a>
					<%
					}
					}
					%>
				</div>
				<!-- 후기  -->

				<div class="gc-re">
					<h3>후기</h3>
					<div class="gc-rebutton">
						<%
						if (userID == null) {
						%>
						<input type="button" value="추가"
							onclick="window.location='/ecopang/ecoProject/group_activity_review/reviewWriteForm.jsp?group_num=<%=group_num%>'" />
						<%
						} else {
						%>
						<input type="button" value="추가"
							onclick="window.location='/ecopang/ecoProject/group_activity_review/reviewWriteForm.jsp?group_num=<%=group_num%>'" />
						<%
						}
						%>
					</div>
				</div>

				<div class="gc-rebox">
					<%
					// 후기 목록 불러오기
					if (revList != null) {
						for (int i = 0; i < revList.size(); i++) {
							if (revList.get(i) != null) {
						revdto = (ReviewDTO) revList.get(i);
						int rev_num = revdto.getRev_num();
					%>
					<div class="gc-rebox1">
						내용 :
						<%=revdto.getRev_content()%>
						
					</div>

						<%
						}
						%>

						<%
						}
						%>

						<%
						}
						%>
						<input type="button" value="더보기"
							onclick="window.location='/ecopang/ecoProject/group_activity_review/reviewAll.jsp?group_num=<%=group_num%>'" />
					

				</div>
				<!-- 내용끝 -->

			</div>
			<!-- content-area -->
		</div>
		<!-- site content -->


		
	</div><!-- #page -->
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
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"
		integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"
		integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"
		crossorigin="anonymous"></script>
</body>
</html>