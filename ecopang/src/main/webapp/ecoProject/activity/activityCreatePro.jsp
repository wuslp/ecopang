<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="ecopang.model.ActDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="ACT" class="ecopang.model.ActDTO" />
<jsp:setProperty property="*" name="ACT"/>
<%
	ActDAO dao = new ActDAO(); 
	dao.insertAct(ACT); 	
%>

<body>
      <script type="text/javascript">
         alert("활동 등록이 완료되었습니다.");
         opener.location.reload(true);  
         self.close();
      </script>
</body>
</html>