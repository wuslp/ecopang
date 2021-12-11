<%@page import="java.util.List"%>
<%@page import="ecopang.model.EventDTO"%>
<%@page import="java.io.File"%>
<%@page import="ecopang.model.EventDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Event 작성 PRO 페이지</title>

    
</head>

<%
	request.setCharacterEncoding("UTF-8");

	//서버에 파일 저장
	String path = request.getRealPath("ecoProject/imgs");
	System.out.println("경로 : "+ path);

	int max = 1024*1024*5;	// 업로드 할 파일 최대 크기 지정 5M
	String enc = "UTF-8";// 인코딩 
	
	//덮어주기 방지 객체 : 중복이름으로 파일 저장시 파일 이름뒤에 숫자를 덧붙여줌
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	// MultipartRequest 객체 생성
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	int eve_num = Integer.parseInt(mr.getParameter("eve_num"));
	int pageNum = Integer.parseInt(mr.getParameter("pageNum")); 
	
	EventDAO dao = new EventDAO();
	EventDTO dto = dao.getEventContent(eve_num);
	/*	넘어온 데이터는 MultipartRequest 객체를 이용해 꺼낸다.
		MultipartRequest 객체 생성시, 필요한 인자들
		1. request 내부객체
		2. 업로드 될 파일 저장 경로 => 사용자가 업로드한 파일을 서버PC에 저장하는것
		3. 업로드 할 파일 최대 크기
		4. 인코딩 타입 UTF-8
		5. 업로드된 파일 이름이 같을 경우, 덮어씌우기 방지 객체
	*/
	// 로컬(pc)에 저장 (웹상에서 해당 이미지 서비스 불가능 -> 서버에 저장)
	//String path = "c:\\test\\";  // 로컬(pc)에 저장 
	

	
	
	// 넘어온 파라미터 꺼내기
	System.out.println(eve_num);
	String eve_title = mr.getParameter("eve_title");
	String eve_startdate = mr.getParameter("eve_startdate");
	String eve_enddate = mr.getParameter("eve_enddate");
	String eve_content = mr.getParameter("eve_content");
	String getimg = mr.getFilesystemName("eve_img"); // 업로드해서 저장된 파일 이름
	
	String eve_img = null;
	if(getimg == null){
		eve_img = dto.getEve_img();
	}else{
		eve_img = mr.getFilesystemName("eve_img");
	}
	String orgName = mr.getOriginalFileName("eve_img"); // 파일 원본이름
	String contentType = mr.getContentType("eve_img"); // 파일 종류
	int eve_hit = 0;
	
	// 사진만 파일 올릴 수 있게 하기 => 컨텐트타입을 확인해서 이미지가 아니라면 삭제 처리를 해줘야함
	// "image/jpeg:
//	String[] type = contentType.split("/"); //컨텐트타입에 들어있는 값을 / 기준으로 나누어 결과를 배열에 담아준다
	//if(!(type != null && type[0].equals("image"))) { //만약, 타입에 값이 있고 그 값이 image가 아니면!
		//File f = mr.getFile("eve_img"); // 해당 업로드된 파일은 File 객체로 가져와 // 이거 img파일아니고 뭐 html이나 이상한거면 스스로 지우라고만든 메서드요!
		//f.delete(); // 파일 삭제하세요	
		//System.out.println("파일삭제됨");
	//}
	
	// DB에 저장 => 파일 이름만 저장 함 
	dto.setEve_title(eve_title);
	dto.setEve_startdate(eve_startdate);
	dto.setEve_enddate(eve_enddate);
	dto.setEve_content(eve_content);
	dto.setEve_img(eve_img);
	dto.setEve_hit(eve_hit);
	
	/* 또는
	UploadDTO dto = new UploadDTO();
	dto.setWriter(writer);
	dto.setImg(sysName);
	dto.uploadImg(dto);
	*/

	// DB에서 꺼내와서 보여줄 때는 => 파일명만 가져와서 웹상의 경로에 파일이름 넣어줌
	//String path = request.getRealPath("imgs");
	//int max = 1024 * 1024 * 5;
	//String enc = "UTF-8";
	//DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	//MultipartRequest mr = new MultipartRequest(request,path,max,enc,dp);
	//dto.setCategory(getParameter("category"));	//카테고리 받아오기
	//dto.setUserID((String)session.getAttribute("memId")); //멤버 아이디 받아오기
	//dto.setTpc_title(mr.getParameter("tpc_title"));
	//dto.setTpc_content(mr.getParameter("tpc_content"));
	//dto.setTpc_imgs(mr.getFilesystemName("tpc_imgs"));
	
	dao.updateEvent(dto); //eventInsert메서드 실행 dto객체 넣어줌!
	
	pageNum = 1;	//페이지 넘버 
	if(request.getParameter("pageNum")!= null){	//페이지넘버 받아와서 이미 있으면
		pageNum = Integer.parseInt(request.getParameter("pageNum"));	//페이지번호=받아온 번호
	}
%>

<script>
	alert("이벤트 수정이 완료되었습니다.")
	window.location='eventContent.jsp?pageNum=<%=pageNum%>&eve_num=<%=eve_num%>';
</script>

<body>

</body>
</html>