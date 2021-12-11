<%@page import="ecopang.model.TopicLike"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.TopicDTO"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.TopicDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- 글씨체  -->
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<!-- 글씨체  -->
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 게시글 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >
<script> 
	   function likebtn()
	   { alert('로그인 후 이용 가능한 기능입니다.'); }
</script>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int pageSize = 10;
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) { 
		pageNum = "1";
	}
	
	int currentPage = Integer.parseInt(pageNum); 
	int startRow = (currentPage - 1) * pageSize + 1; 
	int endRow = currentPage * pageSize; 
	
	TopicDAO dao = new TopicDAO();
	UsersDAO udao = new UsersDAO();
	UsersDTO udto = null;
	TopicLike like = new TopicLike();
	
	String sel = "tpc_title";
	if(request.getParameter("sel") != null) {
		sel = request.getParameter("sel");
	}
	String search = "";
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	List topicList = null;	
	int count = 0;				
	
	String category = "";
	if(request.getParameter("category") != null) {
		category = request.getParameter("category");
	}
	String orderBy = "tpc_reg desc"; 
	if(request.getParameter("orderBy") != null) {
		orderBy = request.getParameter("orderBy");
	}
	count = dao.searchTopicCount(sel, search,category);
	System.out.println(count);
	if(count > 0) {
		topicList = dao.getSearchTopics(startRow, endRow, sel, search,category,orderBy);
	}
	
	int number = count - (currentPage - 1) * pageSize; 
	
	//쿠키
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
<script>
	function orderByChange() {
		var orderBy = document.getElementById("orderBy").options[document.getElementById("orderBy").selectedIndex].value;
			window.location='topicList.jsp?orderBy=' + orderBy + '&category=<%=category%>&sel=<%=sel%>&search=<%=search%>&pageNum=<%=pageNum%>';
	}
	function categoryChange(){    
		var category = document.getElementById("category").options[document.getElementById("category").selectedIndex].value;
		  	window.location='topicList.jsp?category=' + category  + '&orderBy=<%=orderBy%>&sel=<%=sel%>&search=<%=search%>&pageNum=<%=pageNum%>';
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

/*로그인 후 이용 가능 알림*/
function loginAlert(){
	alert("로그인 후 이용 가능합니다.")
	window.location='/ecopang/ecoProject/main/loginForm.jsp?pageNum=<%= pageNum %>';
}
 
</script>
<body class="topicList">   
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
<div id="topic" class="site-content">
<div id="topic_main" class="topic_content_area">
		<div class="topic_top">	
			<div class="two_select">
				<div class="select_category">
					<select id="category" name="category" value="<%= category %>" onchange="categoryChange()">
						<option value="">선택</option>
						<option value="">전체</option>
						<option value="꿀팁">꿀팁</option>
						<option value="기사/이슈">기사/이슈</option>
						<option value="착한가게">착한가게</option>
						<option value="제품 추천">제품 추천</option>
						<option value="자유게시판">자유게시판</option>
					</select>
					<select id="orderBy" name="orderBy" onchange="orderByChange()">
						<option>선택</option>
						<option value="likes">인기순</option>
						<option value="tpc_reg desc">최신순</option>
						<option value="tpc_hit desc">조회순</option>
					</select>
				</div>
			</div> <!-- two_select -->
		</div><!-- topic_top -->	
				<div class="write">		
				<%if(session.getAttribute("memId") !=null) { %>		
					<button onclick="window.location='topicWriteForm.jsp?pageNum=<%= pageNum %>'">글쓰기</button>
				<%}else{ %>
					<button onclick="loginAlert()">글쓰기</button>
				<%}
				%>
				</div>	
			<!-- 전체 선택 글쓰기 -->
			<div class="table_content">
				<table>
					<tr class="table_top">
						<td>주제</td>
						<td>제목</td>
						<td>작성자</td>
						<td>조회수</td>
						<td>추천수</td>
						<td>작성일</td>
					</tr>
					<% if(topicList != null) {
                      for(int i = 0; i < topicList.size(); i++) { 
                        TopicDTO dto = (TopicDTO)topicList.get(i);
                        System.out.println(dto);
                       
                        int likeCount = like.tpcLikeCount(dto.getTpc_num()); %>
                        <tr class="table_middle">
                           <td><%= dto.getCategory() %></td>
                           <td align="left">
                              <a href="/ecopang/ecoProject/topic/topicContent.jsp?tpc_num=<%= dto.getTpc_num()%>&pageNum=<%=pageNum%>"><%= dto.getTpc_title()%></a>
                           </td>
                           <td><%= dto.getNickname()%></td>
                           <td><%= dto.getTpc_hit()%></td>
                           <td><%= likeCount %></td>
                           <td><%= dto.getTpc_reg().toString().substring(0,10) %></td>
                        </tr>
                  <%   }
                   }%>
				</table>
			</div><!--table content -->
			<br/>
			
			<div class="count"> <!-- 하단 숫자 -->
				<% if(count > 0) { 
					int pageBlock = 5;
					int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
					int  startPage = (int)((currentPage - 1) / pageBlock) * pageBlock + 1;
					int endPage = startPage + pageBlock - 1;
					if(endPage > pageCount) endPage = pageCount;
					
					
					if(startPage > pageBlock) {%>
						<a href="topicList.jsp?pageNum=<%= startPage - pageBlock%>&sel=<%=sel%>&search=<%=search%>">&lt;</a>
				<% 	}
					for(int i = startPage; i <= endPage; i++) { %>
						<a href="topicList.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>">&nbsp;<%= i %>&nbsp;</a>	
				<%	}
					if(endPage < pageCount) { %>
						<a href="topicList.jsp?pageNum=<%= startPage + pageBlock %>&sel=<%=sel%>&search=<%=search%>">&gt;</a>
				<%	}
				} %>
				<br/>
			</div>
			<br/>
			
			<!-- 하단 제목 검색 -->
		<div class="bottom">	
			<form action="topicList.jsp" >
				<select name="sel">
					<option value="tpc_title">제목</option>
					<option value="nickname">작성자</option>
					<option value="tpc_content">내용</option>
				</select>
				<input class="text" type="text" name="search" />
				<input class="search" type="submit" value="검색" />
			</form>
		</div>	
			<br/>
			
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
</html>				
				