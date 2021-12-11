<%@page import="ecopang.model.UsersDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="ecopang.model.TopicDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap  -->

    
</head>
<%   request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto" class="ecopang.model.TopicDTO"/>
<jsp:setProperty property="*" name="dto" />
<%
   //String path = request.getRealPath("imgs");
   //int max = 1024 * 1024 * 5;
   //String enc = "UTF-8";
   //DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
   //MultipartRequest mr = new MultipartRequest(request,path,max,enc,dp);
   
   //dto.setCategory(getParameter("category"));   //카테고리 받아오기
   //dto.setUserID((String)session.getAttribute("memId")); //멤버 아이디 받아오기
   //dto.setTpc_title(mr.getParameter("tpc_title"));
   //dto.setTpc_content(mr.getParameter("tpc_content"));
   //dto.setTpc_imgs(mr.getFilesystemName("tpc_imgs"));
   
   //넘어오는 데이터 제외하고 나머지 채울 부분 채워주기
   dto.setUserID((String)session.getAttribute("memId"));
   dto.setTpc_reg(new Timestamp(System.currentTimeMillis())); //timstamp객체로 시간 Set
   dto.setTpc_hit(0); //조회수 0으로 set
   
   response.sendRedirect("topicList.jsp");
   TopicDAO dao = new TopicDAO(); 
   UsersDAO udao = new UsersDAO();
   String nickname = udao.getUser((String)session.getAttribute("memId")).getNickname();
   dto.setNickname(nickname);
   dao.insertTopic(dto); //insertTopic메서드 실행 dto객체 넣어줌!
   
   
   int pageNum = 1;   //페이지 넘버 
   if(request.getParameter("pageNum")!= null){   //페이지넘버 받아와서 이미 있으면
      pageNum = Integer.parseInt(request.getParameter("pageNum"));   //페이지번호=받아온 번호
   }
%>
<!-- 설정한 페이지 번호로 가라고 js태그 실행 -->
<script> 
   window.location='topicList.jsp?pageNum=<%= pageNum %>';   
</script>
<body>

</body>
</html>