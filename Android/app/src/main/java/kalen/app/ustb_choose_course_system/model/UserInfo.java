package kalen.app.ustb_choose_course_system.model;

import org.apache.http.client.CookieStore;

/**
 * Created by kalen on 15-8-11.
 *  用户单例
 */
public class UserInfo {

    public static UserInfo getInstance(){
        if(userInfo == null){
            userInfo = new UserInfo();
        }

        return userInfo;
    }

    private static UserInfo userInfo = null;
    private String username;
    private String password;
    private CookieStore cookieStore;

    public CookieStore getCookieStore() {
        return cookieStore;
    }

    public void setCookieStore(CookieStore cookieStore) {
        this.cookieStore = cookieStore;
    }

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
