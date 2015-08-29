package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Toast;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.ui.choose_course.ChooseCourseActivity;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-12.
 */
public class HomeActivity extends Activity implements View.OnClickListener{

    //RelativeLayout

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_ACTION_BAR);
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
                GetSemesterAsyncTask task = new GetSemesterAsyncTask();
                task.execute();
//                startActivity(new Intent(HomeActivity.this,
//                        ClassTableActivity.class));
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

    class GetSemesterAsyncTask extends AsyncTask<Void, Void, String>{
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(HomeActivity.this,
                    "Loading...", "Please wait...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            try {
                String data = HttpUtils.get(ConstVal.SEARCH_NOT_FULL_PUBLIC_SELECTIVE_COURSE_URL,
                        UserInfo.getInstance().getCookieStore());
                return new JsonParser(data).getSemester();
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }

        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            progressDialog.dismiss();
            if (result != null){
                Intent intent = new Intent(HomeActivity.this, ClassTableActivity.class);
                intent.putExtra("semester", result);
                startActivity(intent);
            }else {
                Toast.makeText(HomeActivity.this,
                        "failed", Toast.LENGTH_SHORT).show();
            }
        }
    }

}
