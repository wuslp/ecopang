<%@page import="ecopang.model.ActivityJoinDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script>
		function joinbtn(){
			alert('');
		}
	</script>
	
	<script>
	function callByAjax(){
		propage ='./activityJoinPro.jsp';
		$.post( // 보내기 방식
			propage,  // 받는 페이지
			{ //보내줄 데이터
				actNum : 1, 
				userID : "test1"
			},
			function(data){ //결과받아서
				$('.rs').empty().append(data); //rs class로 보내주기
			},
			'html'
		);
	}
	
	
	</script>
	
</head>
<%
	String userID="test3";
	int actNum=1;
	// DAO 객체 생성
	ActivityJoinDAO actJoin=new ActivityJoinDAO();
	boolean userAct=actJoin.userAct(userID,actNum);
	
	//해당 활동에 참여중인 멤버 볼수있는 메서드
	int joincount=actJoin.actJoinCount(actNum); 
%>  


<body>
	<%if(userID==null){ %>
		<h3>관악산 14:00</h3>
		<button onclick="javascript:joinbtn()">참가</button>
		<br/>
			<%=joincount %>
	<%}else{ %>	
		<h3>관악산 14:00</h3>	
		<div class="rs">
			<%if(userAct==true){ %>
				<input onclick="callByAjax()" type="button" value="참가중"/>
				<%=joincount %>
			<%}else{ %>
				<input onclick="callByAjax()" type="button"	value="참가"/>
				<%=joincount %>
			<%} %>	
		</div>
	<%} %>	
	




</body>
</html>