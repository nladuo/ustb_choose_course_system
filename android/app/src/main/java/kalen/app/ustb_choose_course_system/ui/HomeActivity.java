package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.ui.choose_course.ChooseCourseActivity;

/**
 * Created by kalen on 15-8-12.
 */
public class HomeActivity extends Activity implements View.OnClickListener{

    //RelativeLayout

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        initViews();
    }

    private void initViews() {
        findViewById(R.id.home_rl_about_soft).setOnClickListener(this);
        findViewById(R.id.home_rl_after_choose_course).setOnClickListener(this);
        findViewById(R.id.home_rl_checkout_update).setOnClickListener(this);
        findViewById(R.id.home_rl_pre_choose_course).setOnClickListener(this);
        findViewById(R.id.home_rl_search_class_table).setOnClickListener(this);
        findViewById(R.id.home_rl_search_exam_alignment).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.home_rl_after_choose_course:
                startActivity(new Intent(HomeActivity.this,
                        ChooseCourseActivity.class));
                break;

            case R.id.home_rl_search_class_table:
                startActivity(new Intent(HomeActivity.this,
                        ClassTableActivity.class));
                break;

            case R.id.home_rl_about_soft:
                break;

            case R.id.home_rl_checkout_update:
                break;

            case R.id.home_rl_pre_choose_course:
            case R.id.home_rl_search_exam_alignment:
                AlertDialog.Builder builder = new AlertDialog.Builder(HomeActivity.this);
                builder.setTitle("提示");
                builder.setMessage("此功能会在选课系统更新后添加");
                builder.setNegativeButton("确定", null);
                AlertDialog alertDialog = builder.create();
                alertDialog.show();
                break;
        }
    }
}
