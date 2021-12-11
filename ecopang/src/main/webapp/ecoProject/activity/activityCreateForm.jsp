<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<link rel="preconnect" href="https://fonts.googleapis.com"> 
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&family=Sunflower:wght@500&display=swap" rel="stylesheet">
<link href="/ecopang/ecoProject/popupstyle.css" rel="stylesheet" type="text/css" >
<head>
<meta charset="UTF-8">
<title>활동 개설</title>
</head>
<script language="javascript">
	function closePopup() {
	 	self.close();
	}
</script>
<% 
	request.setCharacterEncoding("UTF-8");
	GroupDAO gdao = new GroupDAO();
	GroupDTO gdto = gdao.getGroup(Integer.parseInt(request.getParameter("group_num")));
	UsersDAO udao = new UsersDAO();
	UsersDTO udto = udao.getUser((String)session.getAttribute("memId"));
%>
<body>
	<form action="activityCreatePro.jsp" method="post">
		<input type="hidden" name="group_num" value="<%= gdto.getGroup_num() %>" />
		<input type="hidden" name="user_nickname" value="<%= udto.getNickname() %>" />
		<input type="hidden" name="userID" value="<%= udto.getUserID() %>" />
		
		
		<div class="actForm">
			<h2><%=gdto.getGroup_title() %></h2>
			<table class="table4">
				<tr>
					<td class="reportMessage">활동 제목</td>
				</tr>
					<td>
						<input type="text" name="act_title" class="text"/> 
					</td>
				</tr>
				<tr>
					<td class="reportMessage">장소</td>
				</tr>	
				<tr>
					<td>
						<input type="text" name="place"  class="text"/> 
					</td>
				</tr>
				<tr>
					<td class="reportMessage">날짜</td>
				</tr>	
				<tr>
					<td>
						<input type="date" name="act_date" class="text"/>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">시간</td>
				</tr>
				<tr>
					<td>
						<input type="time" name="act_time" value="00:00" min="00:00" max="24:00" class="text"/>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">인원</td>
				</tr>	
				<tr>
					<td>
						<select name="max_user" class="select">
							<%for(int i=0; i<11; i++){ %>
							<option value="<%=i%>"><%=i%>명</option><%} %></select>
					</td>
				</tr>
				<tr>
					<td class="submitBtn"> 
						<input type="submit" value="작성" class="btn"/> 
						<input type="button" value="취소" onclick="closePopup(); " class="btn" /> 
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>