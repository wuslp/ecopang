<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.TopicLikeDAO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.TopicCommentDTO"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.TopicDTO"%>
<%@page import="ecopang.model.TopicDAO"%>
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
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시글 내용</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script> 
	   function likebtn()
	   { alert('로그인 후 이용 가능한 기능입니다.'); }
</script>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int tpc_num = 0;
	if(request.getParameter("tpc_num") != null)
		tpc_num = Integer.parseInt(request.getParameter("tpc_num"));
	int pageNum = 1;
	if(request.getParameter("pageNum") != null)
		pageNum = Integer.parseInt(request.getParameter("pageNum"));
	
	String userID = null;
	if(session.getAttribute("memId") != null) {
		userID = (String)session.getAttribute("memId");
	}
	
	TopicDAO dao = new TopicDAO();
	TopicDTO dto = dao.getTopic(tpc_num);
	UsersDAO udao = new UsersDAO();
	UsersDTO udto = udao.getUser(userID);

	int commentPage = 1;
	if(request.getParameter("commentPage") != null)
		commentPage = Integer.parseInt(request.getParameter("commentPage"));
	
	int pageSize = 5;
	
	int currentPage = commentPage; 
	int startRow = (currentPage - 1) * pageSize + 1; 
	int endRow = currentPage * pageSize; 
	
	List topicCommentList = null;	
	int count = dao.getTopicCommentCount(tpc_num); ;	

	System.out.println("count : " + count);
	
	if(count > 0) {
		topicCommentList = dao.getTopicComments(tpc_num,startRow, endRow);
	}
	int number = count - (currentPage - 1) * pageSize; 
	
	//좋아요
	 TopicLikeDAO like = new TopicLikeDAO();  
   	 boolean userLikesTpcRs = like.userLikesTpc(userID, tpc_num);
   	 int likecount = like.tpcLikeCount(tpc_num);
	
  
	
 %>
 	<script>
		function report(inputForm) {
			var url = "/ecopang/ecoProject/mypage/reportForm.jsp?category="+inputForm.category.value+"&num="+inputForm.num.value+"&userID="+inputForm.userID.value;
			open(
					url,
					"reportForm",
					"toolbar=no, location=no, status=no, menubar=no, scrollbars=no resizeable=no, width=500, height=400");
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
 
	<script>
	
	function callByAjax(){
	   var tpc_num = <%=tpc_num%>
	   var userID="<%=userID%>"
	   propage ='topicLikePro.jsp';
	   $.post( // 보내기 방식
	      propage,  // 받는 페이지
	      { //보내줄 데이터
	         tpc_num : tpc_num,
	         userID : userID
	      },
	      function(data){ //결과받아서
	         $('.rs').empty().append(data); //rs class로 보내주기
	      },
	      'html'
	   );
	}

</script>	
	
<body class="topicList">
	<div id="page" class="site-header cf">
		<header class="header-wrap">
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
						<% if(session.getAttribute("memId") == null) { %>
				            <a href="/ecopang/ecoProject/main/loginForm.jsp">로그인</a>
				            <a href="/ecopang/ecoProject/main/singupForm.jsp">회원가입</a>
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
					<li><a class="active" href="/ecopang/ecoProject/topic/topicList.jsp">커뮤니티</a></li>
				</ul>
			</nav>
		</div><!-- header-wrap -->
	</header> <!-- 헤더 끝 -->
	<!---------------- 헤더 -------------------->	
		<div class="topicContentMain">
			<table class="topicContentTable">
				<tr>
					<td class="topicContentTitle">
						<%= dto.getTpc_title() %>
					</td>
					<td class="topicContentUserBtn">
						<% String userID2 = (String)session.getAttribute("memId");
						if(dto.getUserID().equals(userID2)) {%>
							<button onclick="window.location='topicModifyForm.jsp?tpc_num=<%=tpc_num%>&pageNum=<%=pageNum%>'">수정</button>
							&nbsp;
							<button onclick="window.location='topicDeletePro.jsp?tpc_num=<%=tpc_num%>&pageNum=<%=pageNum%>'">삭제</button>
							&nbsp;
							<button onclick="window.location='topicList.jsp?&pageNum=<%=pageNum%>'">목록</button>
							
						<% }else if(userID2 != null && userID2.equals("admin")) { %>
							<button onclick="window.location='topicModifyForm.jsp?tpc_num=<%=tpc_num%>&pageNum=<%=pageNum%>'">수정</button>
							&nbsp;
							<button onclick="window.location='topicList.jsp?&pageNum=<%=pageNum%>'">목록</button>
						<% }else{ %>
							<button onclick="window.location='topicList.jsp?&pageNum=<%=pageNum%>'">목록</button>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="topicContentCategory">
						<%= dto.getCategory() %>
					</td>
					<td class="topicContentReg">
						<%= dto.getTpc_reg() %>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="topicContent">
						<%= dto.getTpc_content() %>
					</td>
				</tr>
			</table>
			<table class="topicLikeReportTable">
				<tr><td><br/></td></tr>			
				<tr>
					<td class="topicLikeBtn">
						<%if(userID == null){ %>
		         			<button onclick="javascript:likebtn()"  class="likeBtn">♧</button>
		          			x&nbsp;<%=likecount%>
		      			<%}else{%>
		         			<div class="rs">
		           			 <%if(userLikesTpcRs==true){ %>
		             			<button onclick="callByAjax()" class="likeBtn">♣</button>
		              			x&nbsp;<%=likecount %>
		          			 <%}else{ %>
		             			<button onclick="callByAjax()" class="likeBtn">♧</button>
		              			x&nbsp;<%=likecount %>
		      				<%} %>
		      				</div>
		   				<%} %>
		   			</td>
					<form name="inputForm">
						<td class="topicReportBtn">
							<button type="button" onclick="report(this.form)" class="reportBtn">신고하기</button>
							<input type="hidden" name="category" value="<%= dto.getCategory() %>"/> 
							<input type="hidden" name="num" value="<%= dto.getTpc_num()%>"/> 
							<input type="hidden" name="userID" value="<%= dto.getUserID()%>"/> 
						</td>
					</tr>
				</table>						
			</form>		
			<div class="topicCommentDiv">
				<!-- 댓글 -->
				<% if(topicCommentList != null) { 
					
					for(int i = 0; i < topicCommentList.size(); i++) { 
						TopicCommentDTO cdto = (TopicCommentDTO)topicCommentList.get(i);
						String img = udao.getUser_img(cdto.getUserID());%>
						<div class="topicCommentRow">							
							<div class="commentImg">
								<img src=/ecopang/ecoProject/imgs/<%= img %> />
							</div>
							<div class="commentContent">
								<div class="commentTop">
									<div class="commentNickname">
										<%= cdto.getNickname() %>
									</div>
									<div class="commentDeleteBtn">
										<form action="topicCommentPro.jsp?tpc_num=<%=cdto.getTpc_com_num() %>" method="post">
											<% if(cdto.getUserID().equals((String)session.getAttribute("memId"))) {  %>
												<input type="hidden" name="select" value="0" />
												<button onclick="submit">삭제</button>
											<% } %>
										</form>
									</div>
								</div>
								<div class="comment">
									<%= cdto.getTpc_com_content() %>
								</div>
							</div>
						</div>
					<% } 
					}%>
				</div>
				<form action="topicCommentPro.jsp?tpc_num=<%=tpc_num %>" method="post">
					<% if(session.getAttribute("memId") != null) { %>
						<div class="commentInput">
							<input type="text" name="topicComment"/>
							<button onclick="submit">댓글작성</button>
							<input type="hidden" name="select" value="1" />
							<input type="hidden" name="reload" value="1" />
						</div>
					<% } %>
				</form>
				
			<div class="topicCommentPaging">
				<% if(count > 0) { 
					int pageBlock = 5;
					int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
					int startPage = (int)((currentPage - 1) / pageBlock) * pageBlock + 1;
					int endPage = startPage + pageBlock - 1;
					if(endPage > pageCount) endPage = pageCount;
					if(startPage > pageBlock) {%>
							<a href="topicContent.jsp?commentPage=<%= startPage - pageBlock%>&pageNum=<%=pageNum%>&tpc_num=<%=tpc_num%>">&lt;</a>
					<% 	}
					for(int i = startPage; i <= endPage; i++) { %>
							<a href="topicContent.jsp?commentPage=<%=i%>&pageNum=<%=pageNum%>&tpc_num=<%=tpc_num%>">&nbsp;<%= i %>&nbsp;</a>	
					<%	}
					if(endPage < pageCount) { %>
							<a href="topicContent.jsp?commentPage=<%= startPage + pageBlock %>&pageNum=<%=pageNum%>&tpc_num=<%=tpc_num%>">&gt;</a>
					<%	}
				} %>
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
	</div>
</body>
</html>