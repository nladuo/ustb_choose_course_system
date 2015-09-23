package kalen.app.ustb_choose_course_system.ui;


import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.ClassTableAdapter;
import kalen.app.ustb_choose_course_system.db.DBManager;
import kalen.app.ustb_choose_course_system.model.ClassBean;
import kalen.app.ustb_choose_course_system.model.ClassTableBean;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-12.
 */
public class ClassTableActivity extends ActionBarActivity{

    DBManager dbManager;
    private String[] mDatas;
    RecyclerView recyclerView;
    ClassTableAdapter mAdapter;
    EditText semesterEdit;

    private String metaJsonData;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_class_table);
        dbManager = new DBManager(this);
        initDatas();
        initViews();
        initToolBar();

        semesterEdit.setText(getIntent().getStringExtra("semester"));

        //search class table from internet
        GetClassItemAsyncTask task = new GetClassItemAsyncTask(
                semesterEdit.getText().toString());
        task.execute();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        dbManager.close();
    }

    private void initToolBar() {
        Toolbar mToolbar = (Toolbar) findViewById(R.id.top_bar);
        TextView mToolBarTextView = (TextView) findViewById(R.id.top_bar_title);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        mToolbar.setNavigationIcon(R.mipmap.btn_back);
        mToolbar.setNavigationOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View view) {
                finish();
            }
        });
        mToolBarTextView.setText(R.string.app_name);
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
                    "请等待...", "正在获取数据...", true, false);
        }

        @Override
        protected Boolean doInBackground(Void... voids) {
            Map<String, String> map = new HashMap<>();
            map.put("listXnxq", semester);
            map.put("uid", UserInfo.getInstance().getUsername());
            try {
                metaJsonData = HttpUtils.post(ConstVal.FETCH_CLASS_TABLE_PAGE_URL, map,
                        UserInfo.getInstance().getCookieStore());
                JsonParser parser = new JsonParser(metaJsonData);
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
                Toast.makeText( ClassTableActivity.this, "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
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

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        new MenuInflater(getApplication())
                .inflate(R.menu.menu_class_table, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.action_add_to_desktop_shortcut:
                addShortCut();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    private void addShortCut(){
        insertDataToDb();

        // 自定义action
        Intent intent = new Intent("kalen.classtable.intent.action.SHORTCUT");
        // 创建桌面快捷方式
        Intent shortcutIntent = new Intent("com.android.launcher.action.INSTALL_SHORTCUT");
        // 是否允许重复创建
        shortcutIntent.putExtra("duplicate", false);
        // 需要显示的名称
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME,
                "USTB课表");
        // 快捷图片
        Parcelable icon = Intent.ShortcutIconResource.fromContext(
                getApplicationContext(), R.mipmap.ic_launcher);
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, icon);
        // 点击快捷图片，运行的程序主入口
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, intent);
        // 发送广播执行操作
        sendBroadcast(shortcutIntent);

    }

    private void insertDataToDb(){
        dbManager.insertClassTableIfNotExist(new ClassTableBean(
                UserInfo.getInstance().getUsername(),
                UserInfo.getInstance().getPassword(),
                semesterEdit.getText().toString(),
                metaJsonData));

    }
}
