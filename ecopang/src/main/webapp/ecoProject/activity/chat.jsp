<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.UsersDTO"%>
<%@page import="ecopang.model.ActivityJoin"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="ecopang.model.ActDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>채팅</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<link href="chatstyle.css" rel="stylesheet" type="text/css" >
<%
	request.setCharacterEncoding("UTF-8");
	String fromID = (String)session.getAttribute("memId");
	int num = 0; // 테스트용
	if(request.getParameter("act_num") != null)
			num = Integer.parseInt(request.getParameter("act_num"));
	UsersDAO udao = new UsersDAO();
	ActDAO adao = new ActDAO();
	ActivityJoin actjoin = new ActivityJoin(); 
	List memberList = actjoin.getActMembers(num);
	String master = adao.getActMaster(num);
%>
<script>
	
	// 경로 구하기
	var path = "${pageContext.request.contextPath}";
	let time;
	
	var today = new Date();
	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var dateString = year + '-' + month  + '-' + day; // 날짜 형식에 맞게 수정
	
	function submitFunction() { // 채팅 입력시 실행
		var fromID = '<%=fromID %>';
		var act_num = <%= num %>;
		var chat_content = $('#chat_content').val();
		
		$.ajax({
				type: "POST",
				url: path + "/chatSubmitServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					act_num: act_num,
					chat_content: encodeURIComponent(chat_content),
				},
				success: function() {
					
				},
				error: function() {
					alert("실패");
				}
		});
		$('#chat_content').val('');
	}
	var last;
	function chatListFunction(date) { // 채팅 기록 불러오기
		var fromID = '<%=fromID %>';
		var act_num = <%= num %>;
		last = date;
		$.ajax({
				type: "POST",
				url: path +  "/chatListServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					act_num: act_num,
					last: last,
				},
				success: function(data) {
					if(data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					last = parsed.last;
					var today;
					for(var i = 0; i < result.length; i++) {
						if(dateString == result[i][3].value.substr(0,10)) {
							if(parseInt(result[i][3].value.substr(11,2)) > 12) { // 입력 날짜가 오늘일 경우 날짜 형식을 오전(오후) 시간:분 으로 표현
								today = "오후 " + (parseInt(result[i][3].value.substr(11,2)) - 12) + ":" + result[i][3].value.substr(14,2);
							} else {
								today = "오전 " + result[i][3].value.substr(11,2) + ":" + result[i][3].value.substr(14,2);
							}
							if(fromID == result[i][1].value){ 
								addChat1(result[i][1].value, result[i][2].value, today);
							} else {
								addChat2(result[i][1].value, result[i][2].value, today);
							}
						} else { //오늘이 아닐경우 년.월.일 로 표현
							today = result[i][3].value.substr(2,2) + "." + result[i][3].value.substr(5,2)  + "." + result[i][3].value.substr(8,2);
							if(fromID == result[i][1].value){
								addChat1(result[i][1].value, result[i][2].value, today);
							} else {
								addChat2(result[i][1].value, result[i][2].value, today);
							}
						}
						
					}
				}
		});
	}
	function addChat1(chatName, chatContent, chatTime) { // 내가 입력한 채팅일때 실행
		$('#chatList').append(
				'<div class="outchat">' + 
                '<div class="details">' +
                    '<div class="time">' + chatTime +'</div>' +
                    '<div class="chatContent">' + chatContent + '</div>' + 
                '</div>' +  
  			'</div>'
				); 	
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
	}
	function addChat2(chatName, chatContent, chatTime) { // 다른 사람이 입력한 채팅일때 실행
		$('#chatList').append(
				'<div class="inchat">' + 
                '<div class="fromid">' + chatName + '</div>' + 
              	'<div class="details">' + 
                   '<div class="chatContent">' + chatContent + '</div>' +
                   '<div class="time">' + chatTime + '</div>' +
                '</div>' +
  			'</div>'
				);
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
	}
	
	function getInfiniteChat() { // 1초마다 채팅 기록 불러오기 설정
		time = setInterval(function() {
			chatListFunction(last);
		},1000);
	}
</script>
<body>
	<div class="all">
	  	<div class="chat">
		  	<form method="post">
		  		<div id="chatTitle" class="chatTitle">
		  			<% //adao.getActTitle(num) %>
		  			테스트 활동 제목 
		  		</div>
		  		<div id="chatList" class="chatBox">
		  		</div>
		  		<div id="chatInput" class="chatBottom">
		  			<input type="text" id="chat_content" class="chatInput"/>
		  			<button onclick="submitFunction();" class="chatBtn">입력</button>
		  		</div>
	  		</form>
	  	</div>
	  	<div class="member">
	  		<div class="memberTitle">
	  			회원 목록
	  		</div>
	  		<div class="memberList">
	  			<% if(memberList != null) {
	  				for(int i = 0; i < memberList.size(); i++) {  // 가입된 멤버 전부 불러오기
		  				if(memberList.get(i) != null) {
		  				UsersDTO member = udao.getUser((String)memberList.get(i)); %>
		  				<div class="memberRow">
			                  <div class="memberImg">
			                  <% if(member.getUser_img() != null) { // 이미지가 있을 경우 출력해주기%> 
			                      	<img src="/ecopang/imgs/<%= member.getUser_img() %>" />
		                      <% } else { %>
		                      		<img src="/ecopang/imgs/default.png" />
		                      <% } %>
			                  </div> 
			                  <div class="memberID">
			                      <%= member.getNickname() %>
			                  </div>
		  				<% if(master.equals(member.getUserID())) { // 활동 주최자일 경우 추가 이미지%>
			                  <div class="memberKing">
			                      <img src="/ecopang/imgs/circle.png" />
			                  </div>
		  				<% } %>
			            </div>
		  			<%}}	
		  			}%>
	  		</div>
	  	</div>
  	</div>
  	<script>
  		$(document).ready(function() { // 페이지에 들어오면 가장먼저 실행
  			chatListFunction("1990-01-01 00:00:00");
  			document.getElementById('chat_content').focus();
  			getInfiniteChat();
  		})
  	</script>
</body>
</html>