package ecopang.model;

import java.sql.Date;

public class UsersDTO {

	private String userID;
	private String pw;
	private String name;
	private String nickname;
	private String user_img;
	private String birth;
	private String user_city1;
	private String user_district1;
	private String user_city2;
	private String user_district2;
	private String user_city3;
	private String user_district3;
	private int user_level;
	private int reportCount;
	private int warning;
	private String del_reason;
	private String complaints;
	private String user_state;
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getUser_img() {
		return user_img;
	}
	public void setUser_img(String user_img) {
		this.user_img = user_img;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getUser_city1() {
		return user_city1;
	}
	public void setUser_city1(String user_city1) {
		this.user_city1 = user_city1;
	}
	public String getUser_district1() {
		return user_district1;
	}
	public void setUser_district1(String user_district1) {
		this.user_district1 = user_district1;
	}
	public String getUser_city2() {
		return user_city2;
	}
	public void setUser_city2(String user_city2) {
		this.user_city2 = user_city2;
	}
	public String getUser_district2() {
		return user_district2;
	}
	public void setUser_district2(String user_district2) {
		this.user_district2 = user_district2;
	}
	public String getUser_city3() {
		return user_city3;
	}
	public void setUser_city3(String user_city3) {
		this.user_city3 = user_city3;
	}
	public String getUser_district3() {
		return user_district3;
	}
	public void setUser_district3(String user_district3) {
		this.user_district3 = user_district3;
	}
	public int getUser_level() {
		return user_level;
	}
	public void setUser_level(int user_level) {
		this.user_level = user_level;
	}
	public int getReportCount() {
		return reportCount;
	}
	public void setReportCount(int reportCount) {
		this.reportCount = reportCount;
	}
	public int getWarning() {
		return warning;
	}
	public void setWarning(int warning) {
		this.warning = warning;
	}
	public String getDel_reason() {
		return del_reason;
	}
	public void setDel_reason(String del_reason) {
		this.del_reason = del_reason;
	}
	public String getComplaints() {
		return complaints;
	}
	public void setComplaints(String complaints) {
		this.complaints = complaints;
	}
	public String getUser_state() {
		return user_state;
	}
	public void setUser_state(String user_state) {
		this.user_state = user_state;
	}
	
}