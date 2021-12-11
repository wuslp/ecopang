package ecopang.model;

import java.sql.Timestamp;

public class TopicCommentDTO {
	private int tpc_com_num;
	private int tpc_num;
	private String userID;
	private String nickname;
	private String tpc_com_content;
	private Timestamp tpc_com_reg;
	
	public int getTpc_com_num() {
		return tpc_com_num;
	}
	public void setTpc_com_num(int tpc_com_num) {
		this.tpc_com_num = tpc_com_num;
	}
	public int getTpc_num() {
		return tpc_num;
	}
	public void setTpc_num(int tpc_num) {
		this.tpc_num = tpc_num;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getTpc_com_content() {
		return tpc_com_content;
	}
	public void setTpc_com_content(String tpc_com_content) {
		this.tpc_com_content = tpc_com_content;
	}
	public Timestamp getTpc_com_reg() {
		return tpc_com_reg;
	}
	public void setTpc_com_reg(Timestamp tpc_com_reg) {
		this.tpc_com_reg = tpc_com_reg;
	}
	
}
