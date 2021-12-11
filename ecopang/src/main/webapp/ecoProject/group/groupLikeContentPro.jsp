<%@page import="ecopang.model.GroupLikeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<% 
	int group_num = Integer.parseInt(request.getParameter("group_num"));
	String userID = request.getParameter("userID");
	GroupLikeDAO grouplike = new GroupLikeDAO();
	grouplike.groupLikeClick(userID, group_num); //클릭하면 유저 있나없나에 따라서 insert/ delete
	boolean userLikeGroups = grouplike.userLikesGroup(userID, group_num); //테이블에 유저가 있는지 없는지 확인해주는 메서드
	int groupLikecount = grouplike.groupLikeCount(group_num); //그룹에 좋아요 누른 수 카운트해주는 메서드
	
	System.out.println(userLikeGroups);
	System.out.println(groupLikecount);
 %>
<body>
	<%if(userLikeGroups==true){ %>
		<button onclick="callByAjax()" class="likeBtn">♣</button> 
		x&nbsp;<%=groupLikecount%>
	<%}else{ %>
		<button onclick="callByAjax()" class="likeBtn">♧</button>
		x&nbsp;<%=groupLikecount%>
	<%}%>
</body>
</html>
