<%@page import="ecopang.model.GroupLike"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ecopang.model.GroupDAO"%>
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
	<!-- * summernote의 스타일시트와 자바스크립트을 사용하기 위한 선언 */ -->
	<link href="/ecopang/ecoProject/summernote/summernote.css" rel="stylesheet">
	<script src="/ecopang/ecoProject/summernote/summernote.js"></script>
<head>
<meta charset="UTF-8">
<title>소모임 메인 페이지</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<link href="/ecopang/ecoProject/style.css" rel="stylesheet" type="text/css" >

<!-- 제이쿼리 src -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script> 
	function likebtn()
	{ alert('로그인 후 이용 가능한 기능입니다.'); }
	
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

</head>
<%
 	//가져올 변수 세팅 먼저
 	String userID = (String)session.getAttribute("memId");
	
 	
	//한 페이지에 보여줄 소모임의 개수
	int pageSize=6;
	//현재 페이지 번호
	int pageNum = 1; //페이지 넘버 1로 세팅하되
	if(request.getParameter("pageNum") != null) //받아온 번호 잇으면
		pageNum = Integer.parseInt(request.getParameter("pageNum")); //그걸로 세팅해라
	
	// 현재 페이지에 보여줄 소모임과 끝 정보를 세팅 
	int currentPage=pageNum;
	int startRow=(currentPage-1)*pageSize+1;
	int endRow=currentPage*pageSize;
	
	// 소모임에서 그룹들 가져오기 
	GroupDAO dao=new GroupDAO();
	List groupList=null;
	
	// 검색어 작성해서 list 요청, 아래 sel/search 변수에 파라미터가 들어감
	String sel= request.getParameter("sel");
	if(sel == null) {
		sel = "group_title";
	}
	String search=request.getParameter("search");
	if(search == null) {
		search = "";
	}
	
	String sort = "0";
	if(request.getParameter("sort")!=null) {
		sort = request.getParameter("sort");
	}
	// 전체 그룹 담아줄 변수
	int count=0;
	int number=0;
		
    count = dao.getSearchGroupCount(sel, search); // 검색된 글의 총 개수 가져오기 
    System.out.println("검색 count : " + count);
    // 검색한 글이 하나라도 있으면 검색한 글 가져오기 
    if(count > 0){
       groupList = dao.getSearchGroups(startRow, endRow, sel, search,sort); 
    }
	    
	   number = count - (currentPage-1)*pageSize;    // 게시판 목록에 뿌려줄 가상의 글 번호  

		UsersDAO udao = new UsersDAO(); 
	    UsersDTO udto = null;
		GroupLike like = new GroupLike();

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
			<div class="groupMainBody">
				<form action="groupMain.jsp">
					<div class="search">
	                        <select name = "sel">
	                            <option value = "group_title">제목</option> 
	                            <option value = "userID">주최자</option> 
	                            <option value = "group_content">내용</option>               
	                        </select>
	                        <input type="text" name="search">
	                        <input type = "submit" value = "검색" class="form-control">
	                        <% if(udto != null) {%>
	                        	<input type="button" value="추가" onclick="window.location='groupCreatForm.jsp?pageNum=<%=pageNum%>'"/>
	                        <% } %>                
	                </div>  
                </form>	      
				<br/>
				<div class="sort">		
					<a href="groupMain.jsp?pageNum=<%=pageNum%>&sel=<%=sel%>&search=<%=search%>&sort=1">인기순</a>
					<a href="groupMain.jsp?pageNum=<%=pageNum%>&sel=<%=sel%>&search=<%=search%>&sort=2">최신순</a>
	      			<a href="groupMain.jsp?pageNum=<%=pageNum%>&sel=<%=sel%>&search=<%=search%>&sort=3">후기순</a>
	      		</div>
	            <br/>  
	            <div class="groupMainItems">
	            <%	GroupDTO dto = null;
	            	if(groupList !=null){ 
	         		 for(int i=0;i<groupList.size();i++){
	         		   		dto=(GroupDTO)groupList.get(i);
	         		   		boolean userLikeGroups = like.userLikesGroup(userID, dto.getGroup_num());
							int groupLikecount = like.groupLikeCount(dto.getGroup_num());
							int group_num = dto.getGroup_num(); %>
							<div class="groupMainItem">
							<div class="item">
        		   			<a href="groupContent.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum %>">
        		   			<%=dto.getGroup_reg().toString().substring(0, 10) %>
        		   			<% if(dto.getGroup_img() == null) { %>
        		   			<img src="/ecopang/ecoProject/imgs/groupDefault.png"></a>
        		   			<% } else {%>
        		   			<img src="/ecopang/ecoProject/imgs/<%=dto.getGroup_img()%>"></a>	
        		   			<% } %>
							<br/>
							<h3><%=dto.getGroup_title() %></h3>
	         		   		<%=dto.getUserID() %>
	         				<br/>
	         				
	         				<%if(userID == null){ %>
								<button onclick="javascript:likebtn()" class="likeBtn">♧</button>
								 x&nbsp;<%=groupLikecount%>
							<%}else{%>
								<div class="rs<%=i%>">
									<%if(userLikeGroups == true){ %>
							 			<button onclick="callByAjax<%=i%>(<%=group_num%>)" class="likeBtn">♣</button>
							 			x&nbsp;<%=groupLikecount %>
							 		<%}else{ %>
							 			<button onclick="callByAjax<%=i%>(<%=group_num%>)" class="likeBtn">♧</button>
							 			x&nbsp;<%=groupLikecount  %>
									<%} %>
			         		   	</div>
							<%} %>
							
		        		 </div>
		        		 </div>
	         			<%} %>
	         		<%} else { %>
	         			소모임이 없습니다.
	         		 <% }%>
         		   </div>
	       		 	<%--<%  for(int i = 0; i < groupList.size(); i++){
	       		 			
						   GroupDTO dto = (GroupDTO)groupList.get(i);
						   System.out.println(dto);
						 
						    No.<%= dto.getGroup_num()%><br/>
						     <img src ="ecoProject/imgs"><%=dto.getGroup_img()%>" width = "100"><br/>
						    <%=dto.getGroup_title() %> <br/>
						    <%=dto.getGroup_reg() %><br/>
						    <%= dto.getGroup_content() %><br/>
						    
						    <% }%>  <br/>
	          		  --%>
	
				
		<br/><br/>
		<%--페이지 번호 --%>
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
						<a href="groupMain.jsp?pageNum=<%=startPage-pageBlock %>&sel=<%=sel%>&search=<%=search%>"> &lt;</a>			
				<% }
					// 페이지 번호 뿌리기
					for(int i=startPage; i<=endPage; i++){ %>
						<a href="groupMain.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; <%= i %> &nbsp; </a>
				<%} 		
					// 오른쪽 꺽쇄
					if(endPage<pageCount){ %>
						 &nbsp; <a href="groupMain.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel%>&search=<%=search%>"> &gt; </a>
				<%}
				}else{//검색 안했을때
					//왼쪽 꺽쇄
					if(startPage>pageBlock){ %>
						<a href="groupMain.jsp?pageNum=<%=startPage-pageBlock %>" class="pageNums"> &lt; </a>
				<% 	}		
					// 페이지 번호 뿌리기 
					for(int i=startPage; i<=endPage;i++){ %>
						<a href="groupMain.jsp?pageNum=<%=i%>"> &nbsp; <%= i %> &nbsp; </a>
				<% 	}	
					// 오른쪽 꺽쇄
					if(endPage<pageCount){ %>
					 	  <a href="groupMain.jsp?pageNum=<%=startPage+pageBlock%>"> &gt; </a>
		      <%  } 
					
				}// else
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
</div><!-- #page -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
<script>
	function callByAjax0(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=0';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs0').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
	function callByAjax1(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=1';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs1').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
	function callByAjax2(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=2';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs2').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
	function callByAjax3(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=3';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs3').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
	function callByAjax4(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=4';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs4').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
	function callByAjax5(num){
		var group_num = num
		var userID=	"<%=userID%>"
		propage ='/ecopang/ecoProject/group/groupLikePro.jsp?i=5';
		 $.post( // 보내기 방식
			   propage,  // 받는 페이지
			   { //보내줄 데이터
			      group_num : group_num,
			      userID : userID,
			   },
			   function(data){ //결과받아서
			      $('.rs5').empty().append(data); //rs class로 보내주기
			   },
			   'html'
		);
	}
</script>
</html>