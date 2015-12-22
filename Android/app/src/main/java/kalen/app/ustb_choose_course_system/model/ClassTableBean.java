package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-9-23.
 */
public class ClassTableBean {

    private int id;
    private String username;
    private String password;
    private String semester;
    private String meta_json_data;

    public ClassTableBean(int id, String username, String password, String semester, String meta_json_data) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.semester = semester;
        this.meta_json_data = meta_json_data;
    }

    public ClassTableBean(String username, String password, String semester, String meta_json_data) {
        this.username = username;
        this.password = password;
        this.semester = semester;
        this.meta_json_data = meta_json_data;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMeta_json_data() {
        return meta_json_data;
    }

    public void setMeta_json_data(String meta_json_data) {
        this.meta_json_data = meta_json_data;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
