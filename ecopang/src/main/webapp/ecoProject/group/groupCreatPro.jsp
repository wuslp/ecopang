<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="ecopang.model.GroupDTO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="ecopang.model.GroupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>CreatPro</title>
</head>
<% request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="dto" class="ecopang.model.GroupDTO" />
<%

// DB테이블 드롭 시키고 새로 생성 
// DTO 수정 
// 파일업로드 수업했던 거 펴놓고 

	/* MultipartRequest mr = ...객체 생성 
		1. request 내부 객체
		2. 업로드 될 파일 저장 경로 
		3. 업로드 할 파일 최대 크기
		4. 인코딩 타입 UTF-8
		5. 업로드된 파일 이름이 같을 경우, 덮어씌우기 방지해주는 객체 	
	*/
	
	//서버에 파일 저장하기 
	String path=request.getRealPath("ecoProject/imgs"); // 파일이 저장되는 경로
	System.out.println(path); 
	
	int max=1024*1024*5; // 파일 최대 크기 
	String enc="UTF-8";
	// 덮어쓰기 방지 객체
	DefaultFileRenamePolicy dp=new DefaultFileRenamePolicy();
	//MultipartRequest 객체 생성
	MultipartRequest mr=new MultipartRequest(request,path,max,enc,dp);
	
	// mr 객체에서 넘어온 파라미터 꺼내기
	dto.setGroup_title( mr.getParameter("group_title"));
	dto.setCity( mr.getParameter("city"));
	dto.setLocation( mr.getParameter("location"));
	dto.setGroup_img(mr.getFilesystemName("group_img"));
	dto.setGroup_content( mr.getParameter("group_content"));
	
	String userID = (String)session.getAttribute("memId");
	dto.setUserID(userID);
	
	//DB에 저장-> 파일명
	GroupDAO dao=new GroupDAO();    
	// 작성한거 저장한거 dao에서 불러오기
	dao.insertGroup(dto); 
	
	int pageNum=1;
	if(request.getParameter("pageNum")!=null){
		pageNum=Integer.parseInt(request.getParameter("pageNum"));
	}
	
	// dto 에 다 담으면 아래 dao 실행,  userID session에서 뽑아서 체워주기

	
	
	
	
	
	// 작성하고 바로 상세페이지로 이동시키기
	response.sendRedirect("groupMain.jsp");
%>

<body>
	<script>
		alert("소모임 작성이 완료되었습니다.");
		window.location='groupContent.jsp';
	</script>



</body>
</html>