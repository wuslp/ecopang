package ecopang.model;

import java.sql.Timestamp;

public class InfoDTO {
	private int info_num; // 게시글 번호
	private String info_title; // 제목
	private String info_content; // 내용
	private Timestamp info_reg; // 작성날짜
	public int getInfo_num() {
		return info_num;
	}
	public void setInfo_num(int info_num) {
		this.info_num = info_num;
	}
	public String getInfo_title() {
		return info_title;
	}
	public void setInfo_title(String info_title) {
		this.info_title = info_title;
	}
	public String getInfo_content() {
		return info_content;
	}
	public void setInfo_content(String info_content) {
		this.info_content = info_content;
	}
	public Timestamp getInfo_reg() {
		return info_reg;
	}
	public void setInfo_reg(Timestamp info_reg) {
		this.info_reg = info_reg;
	}
	
	
}
