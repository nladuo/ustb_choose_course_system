package kalen.webapp.ustb_cc_website.model;


import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name="message_boards")
public class MessageBoard {
	
	@Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="id")
	private Integer id;
	
	@Column(name="parent_id")
	private Integer parent_id;
	
	@Column(name="nickname", length=30)
	private String nickname;
	
	@Column(name="replyer_name", length=30)
	private String replyer_name;
	
	@Column(name="content", length=255)
	private String content;
	
	@Column(name="time")
	private String time;
	
	

	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getParent_id() {
		return parent_id;
	}
	public void setParent_id(Integer parent_id) {
		this.parent_id = parent_id;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getReplyer_name() {
		return replyer_name;
	}
	public void setReplyer_name(String replyer_name) {
		this.replyer_name = replyer_name;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	@Override
	public String toString() {
		return "MessageBoard [id=" + id + ", parent_id=" + parent_id + ", nickname=" + nickname + ", replyer_name="
				+ replyer_name + ", content=" + content + ", time=" + time + "]";
	}
	
	
	
	

}
