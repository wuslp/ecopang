<%@page import="ecopang.model.GroupLike"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script> 
	function likebtn()
	{ alert('로그인 후 이용 가능한 기능입니다.'); }
</script>
<head>
<meta charset="UTF-8">
<title> 소모임 </title>
</head>

<%
	String userID = "별이";
	int groupNum = 1;
	
	GroupLike grouplike = new GroupLike();
	boolean userLikesGroupRs = grouplike.userLikesGroup(userID, groupNum);
	int likecount = grouplike.groupLikeCount(groupNum);
%>

<body>
	<%if(userID == null){ %>
	<button onclick="javascript:likebtn()"> 좋아요 </button><br/>
			그룹 좋아요 수 : <%=likecount%>
	<%}else{%>
		<%if(userLikesGroupRs){ %>
			<button onclick="window.location='groupLikePro.jsp?groupNum=<%=groupNum%>&userID=<%=userID%>'"> 좋아요 취소 </button><br/>
			그룹 좋아요 수 : <%=likecount%>
		<% }else{ %>
			<button onclick="window.location='groupLikePro.jsp?groupNum=<%=groupNum%>&userID=<%=userID%>'"> 좋아요  </button><br/>
			그룹 좋아요 수  : <%=likecount%>
			<%} %>
	<%} %>
</body>
</html>