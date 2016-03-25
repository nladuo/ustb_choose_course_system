package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.ExamInfoAdapter;
import kalen.app.ustb_choose_course_system.adapter.InnovateCreditAdapter;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.ExamInfo;
import kalen.app.ustb_choose_course_system.model.InnovateCredit;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HtmlParser;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;

/**
 * Created by kalen on 15-11-24.
 */
public class ExamListActivity extends AppCompatActivity {

    private String semester;
    private ExamInfoAdapter mAdapter;
    private ListView mListView;
    private List<ExamInfo> mDatas;
    private EditText semesterEdit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_examinfo);

        try {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }catch (Exception e){}

        this.semester = getIntent().getStringExtra("semester");
        semesterEdit = (EditText) findViewById(R.id.exam_info_semester_et);
        semesterEdit.setText(this.semester);
        findViewById(R.id.exam_info_search_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                semester = semesterEdit.getText().toString();
                mDatas.clear();
                new GetExamListAsyncTask().execute();
            }
        });
        initListView();
        new GetExamListAsyncTask().execute();
    }

    private void initListView() {
        mDatas = new ArrayList<>();
        mAdapter = new ExamInfoAdapter(ExamListActivity.this
                , mDatas);
        mListView = (ListView) findViewById(R.id.examinfos_lv);
        mListView.setAdapter(mAdapter);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch(item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    class GetExamListAsyncTask extends AsyncTask<Void, Void, String> {
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(ExamListActivity.this,
                    "请等待...", "正在抓取数据...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            try {
                Map<String, String> map = new HashMap<>();
                map.put("listXnxq", ExamListActivity.this.semester);
                map.put("winName", "examListPanel");
                map.put("uid", UserInfo.getInstance().getUsername());
                String data = HttpUtils.post(ConstVal.EXAMLIST_URL,
                        map, UserInfo.getInstance().getCookieStore());
                System.out.println(data);
                mDatas = HtmlParser.getExamLists(data);
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
            return "";
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            progressDialog.dismiss();
            if (s == null) {
                Toast.makeText(ExamListActivity.this, "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
                return;
            }
            mAdapter.setDatas(mDatas);
        }
    }
}
