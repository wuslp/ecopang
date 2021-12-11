package ecopang.model;

import java.sql.Timestamp;

public class ChatDTO {
	private int act_num;
	private String fromID;
	private String chat_content;
	private Timestamp chat_reg;
	public int getAct_num() {
		return act_num;
	}
	public void setAct_num(int act_num) {
		this.act_num = act_num;
	}
	public String getFromID() {
		return fromID;
	}
	public void setFromID(String fromID) {
		this.fromID = fromID;
	}
	public String getChat_content() {
		return chat_content;
	}
	public void setChat_content(String chat_content) {
		this.chat_content = chat_content;
	}
	public Timestamp getChat_reg() {
		return chat_reg;
	}
	public void setChat_reg(Timestamp chat_reg) {
		this.chat_reg = chat_reg;
	}
}
