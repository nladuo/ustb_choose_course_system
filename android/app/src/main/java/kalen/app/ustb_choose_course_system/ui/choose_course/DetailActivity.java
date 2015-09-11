package kalen.app.ustb_choose_course_system.ui.choose_course;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.DetailAdpater;
import kalen.app.ustb_choose_course_system.model.ClassBean;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-9-9.
 */
public class DetailActivity extends Activity
        implements AdapterView.OnItemClickListener{

    List<ClassBean> mDatas;
    DetailAdpater mAdapter;
    ListView mLview;
    String classType;
    String addUrl;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_course_detail);
        addUrl = getIntent().getStringExtra("addUrl");
        classType = getIntent().getStringExtra("classType");
        System.out.println(addUrl + "\n\n" + classType);

        initListView();
    }

    private void initListView() {
        mLview = (ListView) findViewById(R.id.detail_lv);
        mDatas = (List<ClassBean>) getIntent().getSerializableExtra("classes");
        mAdapter = new DetailAdpater(this, mDatas);
        mLview.setAdapter(mAdapter);
        mLview.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        ClassBean bean = mDatas.get(i);

        final String courseId = bean.getId();
        final String credit = bean.getCredit();
        builder.setTitle("课程详情")
                .setMessage("课程名称:" + bean.getClassName()
                        + "\n老师:" + bean.getTeacher()
                        + "\n学分:" + bean.getCredit()
                        + "\n上课时间和地点:" + bean.getTime_and_postion())
                .setNegativeButton("确定", null)
                .setPositiveButton("添加此课程", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        new AddCourseAsyncTask(courseId, credit).execute();
                    }
                })
                .create();
        AlertDialog dialog = builder.create();
        dialog.show();
        TextView messageView = (TextView)dialog.findViewById(android.R.id.message);
        messageView.setGravity(Gravity.CENTER);
        TextView titleView = (TextView)dialog.findViewById(view.getContext()
                .getResources().getIdentifier("alertTitle", "id", "android"));
        if (titleView != null) {
            titleView.setGravity(Gravity.CENTER);
        }
    }

    class AddCourseAsyncTask extends AsyncTask<Void, Void, String> {
        String courseId = "";
        String credit = "";
        ProgressDialog progressDialog;

        public AddCourseAsyncTask(String courseId, String credit){
            this.credit = credit;
            this.courseId = courseId;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(DetailActivity.this,
                    "请等待...", "正在抓取数据...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            String msg;
            Map<String, String> map = new HashMap<>();
            map.put("id", this.courseId);
            map.put("uid", UserInfo.getInstance().getUsername());
            map.put("xkfs", classType);
            map.put("xf", this.credit);
            map.put("xh", "");
            map.put("NJ", "");
            map.put("ZYH", "");
            try {
                String data = HttpUtils.post(addUrl, map,
                        UserInfo.getInstance().getCookieStore());

                JsonParser parser = new JsonParser(data);
                msg = parser.getResultMsg();
                //System.out.println(data);
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
            return msg;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            progressDialog.dismiss();
            if(s == null){
                Toast.makeText(DetailActivity.this, "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
                return;
            }
            new AlertDialog.Builder(DetailActivity.this)
                    .setTitle("选课结果")
                    .setMessage(s)
                    .setNegativeButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            finish();
                        }
                    })
                    .create()
                    .show();
        }
    }
}
