package ecopang.model;

import java.sql.Timestamp;

public class GroupLikeDTO {
	private int group_num; 
	private String userID;
	private String group_title;
	private String city;
	private String location;
	private String group_content;
	private String group_img;
	private Timestamp group_reg;
	
	public int getGroup_num() {
		return group_num;
	}
	public void setGroup_num(int group_num) {
		this.group_num = group_num;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getGroup_title() {
		return group_title;
	}
	public void setGroup_title(String group_title) {
		this.group_title = group_title;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}	
	public String getGroup_content() {
		return group_content;
	}
	public void setGroup_content(String group_content) {
		this.group_content = group_content;
	}
	public String getGroup_img() {
		return group_img;
	}
	public void setGroup_img(String group_img) {
		this.group_img = group_img;
	}
	public Timestamp getGroup_reg() {
		return group_reg;
	}
	public void setGroup_reg(Timestamp group_reg) {
		this.group_reg = group_reg;
	}
}


