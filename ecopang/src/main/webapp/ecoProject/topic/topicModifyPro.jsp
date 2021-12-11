<%@page import="ecopang.model.UsersDAO"%>
<%@page import="ecopang.model.TopicDAO"%>
<%@page import="ecopang.model.TopicDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
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

	int tpc_num = Integer.parseInt(request.getParameter("tpc_num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum")); 
	TopicDAO dao = new TopicDAO();
	TopicDTO dto = dao.getTopic(tpc_num);
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
	
	//서버에 파일 저장
	String path = request.getRealPath("ecoProject/imgs");
	System.out.println("경로 : "+ path);
	
	int max = 1024*1024*5;	// 업로드 할 파일 최대 크기 지정 5M
	String enc = "UTF-8";// 인코딩 
	
	//덮어주기 방지 객체 : 중복이름으로 파일 저장시 파일 이름뒤에 숫자를 덧붙여줌
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	// MultipartRequest 객체 생성
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	// 넘어온 파라미터 꺼내기
	String tpc_title = mr.getParameter("tpc_title");
	String category = mr.getParameter("category");
	String tpc_content = mr.getParameter("tpc_content");

	
	// 사진만 파일 올릴 수 있게 하기 => 컨텐트타입을 확인해서 이미지가 아니라면 삭제 처리를 해줘야함
	// "image/jpeg:
//	String[] type = contentType.split("/"); //컨텐트타입에 들어있는 값을 / 기준으로 나누어 결과를 배열에 담아준다
	//if(!(type != null && type[0].equals("image"))) { //만약, 타입에 값이 있고 그 값이 image가 아니면!
		//File f = mr.getFile("eve_img"); // 해당 업로드된 파일은 File 객체로 가져와 // 이거 img파일아니고 뭐 html이나 이상한거면 스스로 지우라고만든 메서드요!
		//f.delete(); // 파일 삭제하세요	
		//System.out.println("파일삭제됨");
	//}
	
	// DB에 저장 => 파일 이름만 저장 함 
	dto.setTpc_num(tpc_num);
	dto.setCategory(category);
	dto.setTpc_title(tpc_title);
	dto.setTpc_content(tpc_content);
	dto.setNickname(dto.getNickname());
	dto.setTpc_hit(dto.getTpc_hit());
	dto.setTpc_reg(dto.getTpc_reg());
	dto.setUserID(dto.getUserID());
	
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
	
	dao.updateTopic(dto); //eventInsert메서드 실행 dto객체 넣어줌!
	
	pageNum = 1;	//페이지 넘버 
	if(request.getParameter("pageNum")!= null){	//페이지넘버 받아와서 이미 있으면
		pageNum = Integer.parseInt(request.getParameter("pageNum"));	//페이지번호=받아온 번호
	}
%>

<script>
	alert("이벤트 수정이 완료되었습니다.")
	window.location='topicContent.jsp?tpc_num=<%=tpc_num%>&pageNum=<%=pageNum%>';
</script>

<body>

</body>
</html>