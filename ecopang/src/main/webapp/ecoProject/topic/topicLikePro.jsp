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
	int tpc_num = Integer.parseInt(request.getParameter("tpc_num"));
	TopicLikeDAO topiclike = new TopicLikeDAO();
	topiclike.userLikesTpc(userID, tpc_num);
	topiclike.tpcLikeClick(userID, tpc_num);
	boolean ultRs = topiclike.userLikesTpc(userID, tpc_num);
	int count = topiclike.tpcLikeCount(tpc_num);
%>
<body>
		<%if(ultRs==true){ %>
 				<input onclick="callByAjax()" type="button" value="♣" class="likeBtn" /> 
 				 x&nbsp;<%=count %>
 			<%}else{ %>
 				<input onclick="callByAjax()" type="button" value="♧" class="likeBtn"/>
 				 x&nbsp;<%=count %>
 			<%} %>
</body>
</html>