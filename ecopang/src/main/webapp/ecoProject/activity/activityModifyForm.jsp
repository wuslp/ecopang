<%@page import="ecopang.model.GroupDTO"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@page import="ecopang.model.ActDTO"%>
<%@page import="ecopang.model.ActDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>활동 수정</title>
</head>
<script>
	function closePopup() {
	  self.close();
	}
	
	function deleteActivity() {
	    var answer;
	    answer = confirm("삭제하시겠습니까?");
	    if(answer == true){
	   		location.replace('activityDeletePro.jsp'); 	
		}else{
			self.close();	
		} 
	}
</script>
<%
	request.setCharacterEncoding("UTF-8");
	int act_num = Integer.parseInt(request.getParameter("act_num"));
	ActDAO adao = new ActDAO();
	ActDTO adto = adao.getActivityNum(act_num);
	GroupDAO gdao = new GroupDAO();
	GroupDTO gdto = gdao.getGroup(adto.getGroup_num());
%>
<body>
	<form action="activityModifyPro.jsp" method="post">
		<input type="hidden" name="group_num" value="<%= gdto.getGroup_num() %>" />
		<input type="hidden" name="user_nickname" value="<%= adto.getUser_nickname() %>" />
		<input type="hidden" name="userID" value="<%= adto.getUserID() %>" />
		
		
		<div class="actForm">
			<h2><%=gdto.getGroup_title() %></h2>
			<table class="table4">
				<tr>
					<td class="reportMessage">활동 제목</td>
				</tr>
					<td>
						<input type="text" name="act_title" class="text" value="<%= adto.getAct_title() %>"/> 
					</td>
				</tr>
				<tr>
					<td class="reportMessage">장소</td>
				</tr>	
				<tr>
					<td>
						<input type="text" name="place"  class="text" value="<%= adto.getPlace() %>"/> 
					</td>
				</tr>
				<tr>
					<td class="reportMessage">날짜</td>
				</tr>	
				<tr>
					<td>
						<input type="date" name="act_date" class="text" value="<%= adto.getAct_date() %>"/>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">시간</td>
				</tr>
				<tr>
					<td>
						<input type="time" name="act_time" value="<%= adto.getAct_time() %>" min="00:00" max="24:00" class="text"/>
					</td>
				</tr>
				<tr>
					<td class="reportMessage">인원</td>
				</tr>	
				<tr>
					<td>
						<select name="max_user" class="select">
							<%for(int i=0; i<11; i++){ 
								if(i == adto.getMax_user()) {%>
									<option value="<%=i%>" selected><%=i%>명</option>
								<% } else { %>
									<option value="<%=i%>"><%=i%>명</option>
								<% } %>
						</select>
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
	<% } %>
</body>

</html>