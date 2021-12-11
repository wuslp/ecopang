//package ecopang.model;
//
//import java.io.IOException;
//import java.net.URLDecoder;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//
//@WebServlet("/ChatListServlet")
//public class ChatListServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//
//	// post 형식으로 실행될 경우
//	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		request.setCharacterEncoding("UTF-8");
//		response.setContentType("text/html;charset=UTF-8");
//		int act_num = Integer.parseInt(request.getParameter("act_num"));
//		String last = request.getParameter("last");
//		String fromID = request.getParameter("fromID");
//		if(fromID == null || fromID.equals("")) {
//			response.getWriter().write("");
//		} else {
//			try {
//				response.getWriter().write(getList(act_num, last)); // 아이디가 있을 경우 getList() 실행
//			} catch(Exception e) {
//				response.getWriter().write("");
//			}
//		}
//	}
//
//	public String getList(int act_num, String last) { // 활동 번호에 맞는 채팅 기록 JSON 형식으로 전달 / 이미 출력한 시간 외 채팅만 전달
//		StringBuffer result = new StringBuffer("");
//		result.append("{\"result\":[");
//		ChatDAO dao = new ChatDAO();
//		ArrayList<ChatDTO> chatList = dao.getChatListByNum(act_num, last);
//		if(chatList.size() == 0) return"";
//		for(int i = 0; i < chatList.size(); i++) {
//			result.append("[{\"value\": \"" + chatList.get(i).getAct_num() + "\"},");
//			result.append("{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
//			result.append("{\"value\": \"" + chatList.get(i).getChat_content() + "\"},");
//			result.append("{\"value\": \"" + chatList.get(i).getChat_reg() + "\"}]");
//			if(i != chatList.size() - 1) result.append(",");
//		}
//		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChat_reg() + "\"}");
//		return result.toString();
//	}
//}
