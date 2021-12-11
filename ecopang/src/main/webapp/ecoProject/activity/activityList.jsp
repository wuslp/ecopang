<%@page import="java.util.Date"%>
<%@page import="ecopang.model.ActDTO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.ActDAO"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>소모임 활동 목록</title>

</head>
<%

	int pageSize=5;

	String pageNum=request.getParameter("pageNum");
	if(pageNum==null){ // pageNum 파라미터가 안넘어왔을때
		pageNum="1";
	}
	int group_num = 0;
	if(request.getParameter("group_num") != null) {
		group_num = Integer.parseInt(request.getParameter("group_num"));
	}
	
	// 현재 페이지에 보여줄 시작과 끝 정보 세팅 
	int currentPage=Integer.parseInt(pageNum);
	int startRow=(currentPage-1)*pageSize+1;
	int endRow=currentPage*pageSize;
	
	// 소모임에서 그룹들 가져오기 
	ActDAO dao=new ActDAO();
	
	// 검색어 작성해서 list 요청, 아래 sel/search 변수에 파라미터가 들어감
	String sel= request.getParameter("sel");
	if(sel == null) {
		sel = "act_title";
	}
	String search=request.getParameter("search");
	if(search == null) {
		search = "";
	}
	// 전체 그룹 담아줄 변수
	List actList=null;
	int count=0;
	int number=0;
	
	
    count = dao.getSearchActCount(sel, search, group_num); // 검색된 글의 총 개수 가져오기 
    // 검색한 글이 하나라도 있으면 검색한 글 가져오기 
    if(count > 0){
       actList = dao.getSearchActivities(startRow, endRow, sel, search, group_num); 
    }
	number = count - (currentPage-1)*pageSize;    // 게시판 목록에 뿌려줄 가상의 글 번호  
	
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
	
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String today = df.format(new Date());
	Date date = df.parse(today);
	
%>
<script>
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
	<div class="actListbody">
		<div class="actTop">
			<form action="activityList.jsp">
				<input type="hidden" name="group_num" value="<%=group_num%>" />
				<input type="hidden" name="pageNum" value="<%=pageNum%>" />
				<select name="sel">
					<option value="act_title">제목</option>
					<option value="place">장소</option>
				</select>
					<input type="text" name="search"/>
					<input type="submit" value="검색" class="btn"/>
			</form>
					<button onclick="window.location='/ecopang/ecoProject/group/groupContent.jsp?group_num=<%=group_num %>&pageNum=<%=pageNum%>'" class="btn">목록</button>		
		</div>
		<div class="activityTable">
			<table>
				<th>제목</th>		
				<th>장소</th>		
				<th>인원</th>		
				<th>날짜</th>
				<th>현황</th>		
				<% if(actList != null) {
					for(int i = 0; i < actList.size(); i++) { 
						ActDTO actdto = (ActDTO)actList.get(i);
						String act_date = actdto.getAct_date(); 
						Date date2 = df.parse(act_date);%>
						<tr>
							<td><%= actdto.getAct_title() %></td>
							<td><%= actdto.getPlace() %></td>
							<td><%= actdto.getMax_user() %></td>
							<td><%= actdto.getAct_date() %></td>
							<td>
								<% if(date.compareTo(date2) <= 0) { %>
									활동중
								<% } else { %>
									종료
								<% } %>
							</td>
						</tr>
				<% } 
				} else { %>
					<tr>
						<td colspan="5"> 활동 기록이 없습니다.</td>
					</tr>
				<% } %>
			</table>
		</div>
		<%--페이지 번호 --%>
	  	<div align="center">
		<% if(count > 0){
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
			
			//왼쪽 꺽쇄
			if(startPage>pageBlock){ %>
				<a href="activityList.jsp?pageNum=<%=startPage-pageBlock %>&group_num=<%=group_num %>&sel=<%= sel %>&search=<%=search %>"" class="pageNums"> &lt; &nbsp;</a>
		<% 	}
			// 페이지 번호 뿌리기 
			for(int i=startPage; i<=endPage;i++){ %>
				<a href="activityList.jsp?pageNum=<%=i%>&group_num=<%=group_num %>&sel=<%= sel %>&search=<%=search %>""class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
		<% 	}
			// 오른쪽 꺽쇄
			if(endPage<pageCount){ %>
			 	 &nbsp; <a href="activityList.jsp?pageNum=<%=startPage+pageBlock%>&group_num=<%=group_num %>&sel=<%= sel %>&search=<%=search %>" class="pageNums"> &gt; </a>
      <%   }
		}// if(count>0) %>		
		
		<br/><br/>
		<%--제목/내용 검색 --%>
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
</html>