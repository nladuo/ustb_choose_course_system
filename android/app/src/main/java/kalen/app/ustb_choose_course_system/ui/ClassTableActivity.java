package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.ClassTableAdapter;
import kalen.app.ustb_choose_course_system.model.ClassBean;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-12.
 */
public class ClassTableActivity extends Activity{

    //List<ClassBean> classes;
    private String[] mDatas;
    RecyclerView recyclerView;
    ClassTableAdapter mAdapter;
    EditText semesterEdit;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_class_table);
        initDatas();
        initViews();
        semesterEdit.setText(getIntent().getStringExtra("semester"));

        //search class table from internet
        GetClassItemAsyncTask task = new GetClassItemAsyncTask(
                semesterEdit.getText().toString());
        task.execute();
    }

    private void initViews() {
        recyclerView = (RecyclerView) findViewById(R.id.class_table_recyclerview);
        mAdapter = new ClassTableAdapter(this, mDatas);
        recyclerView.setAdapter(mAdapter);
        recyclerView.setLayoutManager(new StaggeredGridLayoutManager(8,
                StaggeredGridLayoutManager.HORIZONTAL));
        semesterEdit = (EditText) findViewById(R.id.class_table_semester_et);
        findViewById(R.id.class_table_search_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GetClassItemAsyncTask task = new GetClassItemAsyncTask(
                        semesterEdit.getText().toString());
                task.execute();
            }
        });
    }

    private void initDatas(){
        mDatas = new String[58];
        String title[] = {"\\", "第一节", "第二节",
                "第三节",  "第四节", "第五节",
                "第六节", "未知时间课程", "星期一",  "星期二",
                "星期三",  "星期四",
                "星期五", "星期六", "星期日"};

        for(int i = 0; i < 15; i++){
            if (i < 9) {
                mDatas[i] = title[i];
            }else{
                mDatas[9 + (i - 8) * 7] = title[i];
            }
        }

    }

    class GetClassItemAsyncTask extends AsyncTask<Void, Void, Boolean>{

        String semester;
        ProgressDialog progressDialog;

        public GetClassItemAsyncTask(String semester){
            this.semester = semester;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(ClassTableActivity.this,
                    "Loading...", "Please wait...", true, false);
        }

        @Override
        protected Boolean doInBackground(Void... voids) {
            Map<String, String> map = new HashMap<>();
            map.put("listXnxq", semester);
            map.put("uid", UserInfo.getInstance().getUsername());
            try {
                String data = HttpUtils.post(ConstVal.FETCH_CLASS_TABLE_PAGE_URL, map,
                        UserInfo.getInstance().getCookieStore());
                JsonParser parser = new JsonParser(data);
                List<ClassBean> classes = parser.getClassTableItems();
                handleClasses(classes);
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }

            return true;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);
            progressDialog.dismiss();
            if (result){
                mAdapter.setDatas(mDatas);
            }else {
                Toast.makeText( ClassTableActivity.this, "failed", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private void handleClasses(List<ClassBean> classes){
        String classStrs[] = new String[42];
        String unkownClassStr = "";
        for(int i = 0; i < classStrs.length; i++ ){
            classStrs[i] = "";
        }
        for(ClassBean bean : classes){
            int where = bean.getWhere();
            if(where == -1){
                System.out.println("where == -1" + bean.getClassName());
                String classInfo = bean.getClassName()
                        + "("
                        + bean.getTeacher()
                        + ")";
                if(!unkownClassStr.isEmpty()){
                    unkownClassStr += "  、";
                }
                unkownClassStr += classInfo;
                continue;
            }

            String classInfo = bean.getClassName()
                    + "\n"
                    + bean.getTeacher()
                    + "\n("
                    + bean.getTime()
                    + "   "
                    + bean.getPosition()
                    + ")";
            if (classStrs[where].equals("")){
                classStrs[where] = classInfo;
            }else {
                classStrs[where] += "\n\n---------------------------------\n\n" + classInfo;
            }
            //change my datas
            mDatas[15] = unkownClassStr;

            for (int i = 0; i < 42; i++){
                int x = i / 6;
                //int y = i % 6;
                //System.out.println(i + "--->" + classStrs[i]);
                if (x == 0){
                    mDatas[i + 9] = classStrs[i];
                }else{
                    mDatas[i + (x + 10)] = classStrs[i];
                }
            }


        }

    }


}
