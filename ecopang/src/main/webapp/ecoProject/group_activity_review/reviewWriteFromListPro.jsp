<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="ecopang.model.ReviewDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 writePro</title>
</head>
<%
	request.getParameter("utf-8");
	String userID=(String)request.getAttribute("memId");

%>
	<jsp:useBean id="revdto" class="ecopang.model.ReviewDTO"></jsp:useBean>
<%
	//setProperty 안됨
	//multipart 객체생성
	//
	//String userID = request.getParameter("userID");

	String path = request.getRealPath("ecoProject/imgs");
	int max = 1024*1024*5;
	String enc ="utf-8";
	System.out.println(path);
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	//dto에 값 셋팅
	revdto.setGroup_num(Integer.parseInt(mr.getParameter("group_num")));
	revdto.setUserID(mr.getParameter("userID"));
	revdto.setRev_content(mr.getParameter("rev_content"));
	revdto.setRev_img(mr.getFilesystemName("rev_img"));//주의
	revdto.setRev_reg(new Timestamp(System.currentTimeMillis()));//DAO insert sysdate
	revdto.setLikesCount(0);//++++
	ReviewDAO revdao = new ReviewDAO();
	revdao.insertReview(revdto);
	int group_num = Integer.parseInt(mr.getParameter("group_num"));
	System.out.println(group_num);
	
%>
<body>
</body>
	<script>
		alert("리뷰 작성이 완료되었습니다.");
		window.location='reviewAll.jsp?group_num=<%=group_num%>';
	</script>
</html>