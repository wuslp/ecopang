package ecopang.model;

import java.sql.Date;
import java.sql.Timestamp;

public class EventCommentDTO {
	private int eve_com_num;
	private int eve_num;
	private String userID;
	private String nickname;
	private String eve_comment;
	private Timestamp eve_reg;
	public int getEve_com_num() {
		return eve_com_num;
	}
	public void setEve_com_num(int eve_com_num) {
		this.eve_com_num = eve_com_num;
	}
	public int getEve_num() {
		return eve_num;
	}
	public void setEve_num(int eve_num) {
		this.eve_num = eve_num;
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
	public String getEve_comment() {
		return eve_comment;
	}
	public void setEve_comment(String eve_comment) {
		this.eve_comment = eve_comment;
	}
	public Timestamp getEve_reg() {
		return eve_reg;
	}
	public void setEve_reg(Timestamp eve_reg) {
		this.eve_reg = eve_reg;
	}

}
