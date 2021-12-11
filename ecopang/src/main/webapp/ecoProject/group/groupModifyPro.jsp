<%@page import="ecopang.model.GroupDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>

<%	
	request.setCharacterEncoding("UTF-8");

	String path=request.getRealPath("ecoProject/imgs"); // 파일이 저장되는 경로
	System.out.println(path); 
		
	int max=1024*1024*5; // 파일 최대 크기 
	String enc="UTF-8";
	// 덮어쓰기 방지 객체
	DefaultFileRenamePolicy dp=new DefaultFileRenamePolicy();
	//MultipartRequest 객체 생성
	MultipartRequest mr=new MultipartRequest(request,path,max,enc,dp);

	int group_num=Integer.parseInt(mr.getParameter("group_num"));
	int pageNum= 1;
	if(mr.getParameter("pageNum") != null) {
		pageNum = Integer.parseInt(mr.getParameter("pageNum"));
	}
	
	GroupDAO dao=new GroupDAO();
	GroupDTO dto=dao.getUpdateGroup(group_num);
	
	//DB에 저장 => 파일 이름만 저장		
	dto.setGroup_title( mr.getParameter("group_title"));
	dto.setCity( mr.getParameter("city"));
	dto.setLocation( mr.getParameter("location"));
	dto.setGroup_img(mr.getFilesystemName("group_img"));
	dto.setGroup_content( mr.getParameter("group_content"));
	
	
	// dto 에 다 담으면 아래 dao 실행,  userID session에서 뽑아서 체워주기
	String userID=(String)session.getAttribute("memId");
	dto.setUserID(userID);
	
	int res=dao.updateGroup(dto); 
	
	pageNum = 1;	//페이지 넘버 
	if(request.getParameter("pageNum")!= null){	//페이지넘버 받아와서 이미 있으면
		pageNum = Integer.parseInt(request.getParameter("pageNum"));	//페이지번호=받아온 번호
	}
	
	if(res == 1) {	
%>	
 		
<body>
	<script> 
		alert("소모임 수정이 완료되었습니다");
		window.location='groupContent.jsp?group_num=<%=group_num%>&pageNum=<%=pageNum%>';
	</script>
	
</body>
<% } %>
</html>