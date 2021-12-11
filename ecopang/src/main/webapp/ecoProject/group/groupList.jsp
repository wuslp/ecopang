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
	
	// 현재 페이지에 보여줄 시작과 끝 정보 세팅 
	int currentPage=Integer.parseInt(pageNum);
	int startRow=(currentPage-1)*pageSize+1;
	int endRow=currentPage*pageSize;
	
	// 소모임에서 그룹들 가져오기 
	GroupDAO dao=new GroupDAO();
	
	// 검색어 작성해서 list 요청, 아래 sel/search 변수에 파라미터가 들어감
	String sel= request.getParameter("sel");
	String search=request.getParameter("search");
	String sort = request.getParameter("sort");
	// 전체 그룹 담아줄 변수
	List groupList=null;
	int count=0;
	int number=0;
	
	if(sel != null && search != null) { // 검색 한 경우 
	      count = dao.getSearchGroupCount(sel, search); // 검색된 글의 총 개수 가져오기 
	      System.out.println("검색 count : " + count);
	      // 검색한 글이 하나라도 있으면 검색한 글 가져오기 
	      if(count > 0){
	         groupList = dao.getSearchGroups(startRow, endRow, sel, search, sort); 
	      }
	       
	   }else{ //검색 안함. 전체 게시판 요청 
	      // 전체 글의 개수 가져오기 
	      count = dao.getGroupCount();   // DB에 저장되어있는 전체 글의 개수를 가져와 담기
	      System.out.println("count : " + count);
	      // 글이 하나라도 있으면 글들을 다시 가져오기 
	      if(count > 0){
	         groupList = dao.getGroups(startRow, endRow); 
	      }
	   }
	   
	   number = count - (currentPage-1)*pageSize;    // 게시판 목록에 뿌려줄 가상의 글 번호  

	//날짜 출력 
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
%>

<body>
	<div>
	</div>
	<br/>
	<%if(session.getAttribute("memId")==null){%>

	<h1 align="left">활동 목록</h1>
	<div>
		<select name="list">
			<option>전체</option>
			<option>제목</option>
			<option>주최자</option>
			<option>내용</option>
		</select>

	</div>
	<%if(count==0){%>
	<table>		
		<tr>
			<td><button onclick="window.location='groupCreatForm.jsp?pageNum=<%=pageNum%>'">작성하기</button></td>
		</tr>
		<tr>
			<td align="center">소모임이 존재하지 않습니다.</td>
		</tr>
	</table>
	<%}else{ %>
	<table>
		<tr>			
			<td colspan="6" align="right">
			<button onclick="window.location='groupCreatForm.jsp'">작성하기</button></td>
		</tr>
		<tr>
			<td>No.</td>
			<td>userID</td>
			<td>제목</td>
			<td>조회수 </td>
			<td>작성날짜</td>
		</tr>
	
		<tr>
			<td><%=number-- %></td>
			<td align="left"></td>	
		</tr>
	</table>
	<table>		
		<%}//for %>
	</table>
	<%}//else %>
	<br/><br/>
	<%--페이지 번호 --%>
  	<div align="center">
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
				<a href="groupList.jsp?pageNum=<%=startPage-pageBlock %>&sel=<%=sel%>&search=<%=search%>" class="pageNums"> &lt; &nbsp;</a>			
		<% }
		
			// 페이지 번호 뿌리기
			for(int i=startPage; i<=endPage; i++){ %>
				<a href="groupList.jsp?pageNum=<%=i %>&sel=<%=sel%>&search=<%=search%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
		<%} 		
		
			// 오른쪽 꺽쇄
			if(endPage<pageCount){ %>
				 &nbsp; <a href="groupList.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel%>&search=<%=search%>" class="pageNums"> &gt; </a>
		<%}
			
		}else{//검색 안했을때
			
			//왼쪽 꺽쇄
			if(startPage>pageBlock){ %>
				<a href="groupList.jsp?pageNum=<%=startPage-pageBlock %>" class="pageNums"> &lt; &nbsp;</a>
		<% 	}
				
			// 페이지 번호 뿌리기 
			for(int i=startPage; i<=endPage;i++){ %>
				<a href="groupList.jsp?pageNum=<%=i %>"class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
		<% 	}
			
			// 오른쪽 꺽쇄
			if(endPage<pageCount){ %>
			 	 &nbsp; <a href="list.jsp?pageNum=<%=startPage+pageBlock%>" class="pageNums"> &gt; </a>
      <%   }
			
		}// else
	}// if(count>0) %>		
	
	<br/><br/>
	<%--주최자/내용 검색 --%>
		<form action="groupList.jsp">
			<select name="sel">
				<option value="group_title">제목</option>
				<option value="userID">주최자</option>
				<option value="group_content">내용</option>
			</select>
				<input type="text" name="search"/>
				<input type="submit" value="검색"/>		
		</form>		
	<br/>
		<h3	style="color:grey"> 현재페이지 : <%=pageNum %></h3>
	<br/>
	<%if(sel !=null && search !=null){ %>
		<button onclick="window.location='groupList.jsp'">전체 소모임 보기</button>
		
		<button onclick="window.location='/ecopang/ecoProject/group/groupMain.jsp'">메인으로</button>
	<%} %>
	</div>
					 

</body>	
</html>