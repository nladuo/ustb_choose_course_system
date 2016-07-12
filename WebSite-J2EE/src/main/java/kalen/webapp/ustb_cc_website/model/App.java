package kalen.webapp.ustb_cc_website.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name="apps")
public class App {
	
	@Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    @Column(name="id")
	private Integer id;
	
	@Column(name="type_name", length=30)
	private String type_name;
	
	@Column(name="app_name", length=30)
	private String app_name;
	
	@Column(name="version")
	private Double version;
	
	@Column(name="note", length=255)
	private String note;
	
	@Column(name="update_note", length=255)
	private String update_note;
	
	
	public Integer getId() {
		return id;
	}
	
	
	public void setId(Integer id) {
		this.id = id;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getApp_name() {
		return app_name;
	}
	public void setApp_name(String app_name) {
		this.app_name = app_name;
	}
	public Double getVersion() {
		return version;
	}
	public void setVersion(Double version) {
		this.version = version;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getUpdate_note() {
		return update_note;
	}
	public void setUpdate_note(String update_note) {
		this.update_note = update_note;
	}
	

}
