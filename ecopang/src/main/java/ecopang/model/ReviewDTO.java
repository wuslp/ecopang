package ecopang.model;

import java.sql.Timestamp;

public class ReviewDTO {

	private int rev_num;
	private int group_num;
	private String userID;
	private String rev_content;
	private String rev_img;
	private Timestamp rev_reg;
	private int likesCount; // 좋아요 카운트수 
	
	public int getLikesCount() {
		return likesCount;
	}

	public void setLikesCount(int likesCount) {
		this.likesCount = likesCount;
	}

	public void setRev_num(int rev_num) {
		this.rev_num = rev_num;
	}

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

	public String getRev_content() {
		return rev_content;
	}

	public void setRev_content(String rev_content) {
		this.rev_content = rev_content;
	}

	public String getRev_img() {
		return rev_img;
	}

	public void setRev_img(String rev_img) {
		this.rev_img = rev_img;
	}

	public Timestamp getRev_reg() {
		return rev_reg;
	}

	public void setRev_reg(Timestamp rev_reg) {
		this.rev_reg = rev_reg;
	}

	public int getRev_num() {
		return rev_num;
	}
	
	
}
