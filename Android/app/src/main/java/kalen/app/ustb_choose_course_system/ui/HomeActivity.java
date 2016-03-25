package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.IBinder;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.service.DownLoadService;
import kalen.app.ustb_choose_course_system.ui.choose_course.ChooseCourseActivity;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-12.
 */
public class HomeActivity extends AppCompatActivity implements View.OnClickListener{


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        initViews();
    }

    private void initViews() {
        findViewById(R.id.home_rl_after_choose_course).setOnClickListener(this);
        findViewById(R.id.home_rl_checkout_update).setOnClickListener(this);
        findViewById(R.id.home_rl_pre_choose_course).setOnClickListener(this);
        findViewById(R.id.home_rl_search_class_table).setOnClickListener(this);
        findViewById(R.id.home_rl_search_exam_alignment).setOnClickListener(this);
        findViewById(R.id.home_rl_logout).setOnClickListener(this);
        findViewById(R.id.home_rl_search_innovate_credit).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.home_rl_after_choose_course:
                Intent i1 = new Intent(HomeActivity.this, ChooseCourseActivity.class);
                UserInfo.getInstance().setChooseCourseType(ConstVal.AfterChooseCourse);
                startActivity(i1);
                break;

            case R.id.home_rl_search_class_table:
                GetSemesterAsyncTask task = new GetSemesterAsyncTask(
                        new Intent(HomeActivity.this, ClassTableActivity.class));
                task.execute();
                break;

            case R.id.home_rl_checkout_update:
                new CheckUpdateAsyncTask().execute();
                break;

            case R.id.home_rl_search_innovate_credit:
                startActivity(new Intent(this, InnovateCreditActivity.class));
                break;

            case R.id.home_rl_search_exam_alignment:
                GetSemesterAsyncTask task2 = new GetSemesterAsyncTask(
                        new Intent(HomeActivity.this, ExamListActivity.class));
                task2.execute();
                break;

            case R.id.home_rl_pre_choose_course:
                Intent i2 = new Intent(HomeActivity.this, ChooseCourseActivity.class);
                UserInfo.getInstance().setChooseCourseType(ConstVal.PreChooseCourse);
                startActivity(i2);
                break;
            case R.id.home_rl_logout:
                AlertDialog.Builder builder2 = new AlertDialog.Builder(HomeActivity.this);
                builder2.setTitle("提示");
                builder2.setMessage("你确定要退出账户吗？");
                builder2.setNegativeButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        //reset the userInfo
                        UserInfo userInfo = UserInfo.getInstance();
                        userInfo.setCookieStore(null);
                        userInfo.setPassword("");
                        userInfo.setUsername("");
                        startActivity(new Intent(HomeActivity.this,
                                LoginActivity.class));
                        finish();

                    }
                });
                builder2.setPositiveButton("取消", null);
                AlertDialog alertDialog2 = builder2.create();
                alertDialog2.show();

        }
    }

    class GetSemesterAsyncTask extends AsyncTask<Void, Void, String>{
        ProgressDialog progressDialog;
        Intent startIntent;

        public GetSemesterAsyncTask(Intent intent){
            this.startIntent = intent;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(HomeActivity.this,
                    "请等待...", "正在加载中...", true, false);
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

                startIntent.putExtra("semester", result);
                startActivity(startIntent);
            }else {
                Toast.makeText(HomeActivity.this,
                        "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
            }
        }
    }

    class CheckUpdateAsyncTask extends AsyncTask<Void, Void, String>{
        ProgressDialog progressDialog;
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(HomeActivity.this,
                    "请等待...", "正在加载中...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            String jsonData;
            try {
                jsonData = HttpUtils.get(ConstVal.APP_UPDATE_CHECK_URL,null);
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
            return jsonData;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            progressDialog.dismiss();
            if (s == null){
                Toast.makeText(HomeActivity.this,
                        "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
                return;
            }
            try {
                JsonParser parser = new JsonParser(s);
                JSONObject object = parser.getJsonObject();
                double version = object.getDouble("version");
                //Check whether need to update
                if ((version - ConstVal.VERSION) > 0.001){
                    // need to update
                    String releasedNote = object.getString("update_note");
                    final String appName = object.getString("app_name");
                    AlertDialog dialog = new AlertDialog
                            .Builder(HomeActivity.this)
                            .setTitle("提示")
                            .setMessage("当前版本号:" + ConstVal.VERSION
                                    + "\n最新版本号:" + version
                                    + "\n更新说明:" + releasedNote)
                            .setNegativeButton("确定", null)
                            .setPositiveButton("下载更新", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    Toast.makeText(HomeActivity.this, "开始下载...", Toast.LENGTH_SHORT).show();
                                    startDownload(appName,
                                            ConstVal.APP_DOWNLOAD_URL);
                                }
                            })
                            .create();
                    dialog.show();


                }else{
                    AlertDialog dialog = new AlertDialog
                            .Builder(HomeActivity.this)
                            .setTitle("提示")
                            .setMessage("已经是最新版本")
                            .setNegativeButton("确定", null)
                            .create();
                    dialog.show();

                }

            } catch (JSONException e) {
                e.printStackTrace();
                Toast.makeText(HomeActivity.this,
                        "内部解析错误", Toast.LENGTH_SHORT).show();
            }
        }
    }

    void startDownload(String filename, String url){

        final String downloadFilename = filename;
        final String downloadUrl = url;


        Intent intent=new Intent(this,DownLoadService.class);
        bindService(intent, new ServiceConnection(){
            @Override
            public void onServiceConnected(ComponentName componentName,
                                           IBinder binder) {

                DownLoadService downLoadService=((DownLoadService.MyBinder)binder)
                        .getService();
                downLoadService.getTask().execute(downloadFilename,
                        downloadUrl);
            }

            @Override
            public void onServiceDisconnected(ComponentName componentName) {}
        }, Context.BIND_AUTO_CREATE);

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        new MenuInflater(getApplication())
                .inflate(R.menu.menu_login, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.action_about:
                startActivity(new Intent(this, AboutActivity.class));
                return true;
        }

        return super.onOptionsItemSelected(item);
    }

}
