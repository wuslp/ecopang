//package ecopang.model;
//
//import java.io.IOException;
//import java.net.URLDecoder;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//@WebServlet("/ChatSubmitServlet")
//public class ChatSubmitServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//
//	// post 형식으로 실행될 경우
//	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		request.setCharacterEncoding("UTF-8");
//		response.setContentType("text/html;charset=UTF-8");
//		int act_num = Integer.parseInt(request.getParameter("act_num"));
//		String fromID = request.getParameter("fromID");
//		String chat_content = request.getParameter("chat_content");
//		if(fromID == null || fromID.equals("") || chat_content == null || chat_content.equals("")) {
//			response.getWriter().write("0");
//		} else {
//			fromID = URLDecoder.decode(fromID, "UTF-8");
//			chat_content = URLDecoder.decode(chat_content, "UTF-8");
//			response.getWriter().write(new ChatDAO().submit(act_num, fromID, chat_content) + ""); // 아이디가 있을 경우 ChatDAO에 있는 submit() 함수 실행
//		}
//	}
//
//}
