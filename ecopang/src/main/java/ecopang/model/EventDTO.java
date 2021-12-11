package ecopang.model;

import java.sql.Date;

public class EventDTO {
	private int eve_num;
	private String eve_title;
	private String eve_startdate;
	private String eve_enddate;
	private String eve_content;
	private String eve_img;
	private int eve_hit;
	
	public int getEve_num() {
		return eve_num;
	}
	public void setEve_num(int eve_num) {
		this.eve_num = eve_num;
	}
	public String getEve_title() {
		return eve_title;
	}
	public void setEve_title(String eve_title) {
		this.eve_title = eve_title;
	}
	public String getEve_startdate() {
		return eve_startdate;
	}
	public void setEve_startdate(String eve_startdate) {
		this.eve_startdate = eve_startdate;
	}
	public String getEve_enddate() {
		return eve_enddate;
	}
	public void setEve_enddate(String eve_enddate) {
		this.eve_enddate = eve_enddate;
	}
	public String getEve_content() {
		return eve_content;
	}
	public void setEve_content(String eve_content) {
		this.eve_content = eve_content;
	}
	public String getEve_img() {
		return eve_img;
	}
	public void setEve_img(String eve_img) {
		this.eve_img = eve_img;
	}
	public int getEve_hit() {
		return eve_hit;
	}
	public void setEve_hit(int eve_hit) {
		this.eve_hit = eve_hit;
	}
	
	
}
