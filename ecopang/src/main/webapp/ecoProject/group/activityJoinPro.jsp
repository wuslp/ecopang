<%@page import="ecopang.model.ActivityJoinDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<%
	String userID=request.getParameter("userID");
	int act_num=Integer.parseInt(request.getParameter("act_num"));
	int maxUser = Integer.parseInt(request.getParameter("maxUser"));
	int i = Integer.parseInt(request.getParameter("i"));
	ActivityJoinDAO actJoin=new ActivityJoinDAO();
	// 클릭할때마다 db에 데이터 업데이트해주는 메서드 
	actJoin.actJoinClick(userID,act_num); 
	// 해당 유저가 참여중인지 아닌지 처리하는
	boolean user=actJoin.userAct(userID,act_num);
	// 활동에 참여중인 멤버 수 보여주는 메서드
	int count=actJoin.actJoinCount(act_num); 
%> 

<body>
	<%if(user==true){ %>
		<input onclick="joinByAjax<%=i%>(<%=act_num%>,<%=maxUser%>)" type="button" value="참가중"/>
		 <%=count %> / <%=maxUser%>
		 </br><input type="button" onclick="popup(<%=act_num%>)" value="채팅하기" />
 			<%}else{ %>
 				<input onclick="joinByAjax<%=i%>(<%=act_num%>,<%=maxUser%>)" type="button" value="참가"/>
 				<%=count %> / <%=maxUser%>
 			<%} %>

</body>
</html>