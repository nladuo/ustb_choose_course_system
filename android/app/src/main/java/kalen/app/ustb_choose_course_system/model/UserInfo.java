package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-8-11.
 *  用户单例
 */
public class UserInfo {
    static UserInfo userInfo = null;
    static UserInfo getInstance(){
        if(userInfo == null){
            userInfo = new UserInfo();
        }

        return userInfo;
    }

    private String username;
    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

}
