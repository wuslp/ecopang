package ecopang.model;

import java.sql.Timestamp;

public class TopicDTO {
	private int tpc_num;
	private String category;
	private String userID;
	private String nickname;
	private String tpc_title;
	private String tpc_content;
	private int tpc_hit;
	private Timestamp tpc_reg;
	public int getTpc_num() {
		return tpc_num;
	}
	public void setTpc_num(int tpc_num) {
		this.tpc_num = tpc_num;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
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
	public String getTpc_title() {
		return tpc_title;
	}
	public void setTpc_title(String tpc_title) {
		this.tpc_title = tpc_title;
	}
	public String getTpc_content() {
		return tpc_content;
	}
	public void setTpc_content(String tpc_content) {
		this.tpc_content = tpc_content;
	}
	
	public int getTpc_hit() {
		return tpc_hit;
	}
	public void setTpc_hit(int tpc_hit) {
		this.tpc_hit = tpc_hit;
	}
	public Timestamp getTpc_reg() {
		return tpc_reg;
	}
	public void setTpc_reg(Timestamp tpc_reg) {
		this.tpc_reg = tpc_reg;
	}
	
}
