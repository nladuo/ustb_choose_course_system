package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.os.Bundle;

import org.apache.http.client.CookieStore;

/**
 * Created by kalen on 15-8-12.
 */
public class HomeActivity extends Activity{

    private CookieStore cookieStore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public void setCookieStore(CookieStore cookieStore) {
        this.cookieStore = cookieStore;
    }

}
