<%@page import="ecopang.model.ReviewLikesDAO"%>
<%@page import="ecopang.model.TopicLikeDAO"%>
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

 <!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="/ecopang/ecoProject/stylee.css" rel="stylesheet" type="text/css" >
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	String userID = request.getParameter("userID");
	int i = Integer.parseInt(request.getParameter("i"));
	int rev_num = Integer.parseInt(request.getParameter("rev_num"));
	int group_num = Integer.parseInt(request.getParameter("group_num"));
	ReviewLikesDAO revlike = new ReviewLikesDAO();
	revlike.userLikesReview(userID, rev_num);
	revlike.reviewLikeClick(userID, rev_num);
	boolean userLikeRev = revlike.userLikesReview(userID, rev_num);
	int count = revlike.reviewLikeCount(rev_num);
%>
<body>
		<%if(userLikeRev==true){ %>
 			<button onclick="callByAjax<%=i %>(<%=rev_num%>)" class="likeBtn">♣</button>
  			x&nbsp;<%=count %>
	 	<%}else{ %>
 			<button onclick="callByAjax<%=i %>(<%=rev_num%>)" class="likeBtn">♧</button>
  			x&nbsp;<%=count %>
		<%} %>
</body>
</html>