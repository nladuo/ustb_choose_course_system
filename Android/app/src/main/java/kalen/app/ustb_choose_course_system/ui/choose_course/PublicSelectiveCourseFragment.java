package kalen.app.ustb_choose_course_system.ui.choose_course;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.PublicCourseAdapter;
import kalen.app.ustb_choose_course_system.model.ClassBean;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-16.
 */
public class PublicSelectiveCourseFragment extends Fragment implements ExpandableListView.OnChildClickListener{
    View view;
    PublicCourseAdapter mAdapter;
    ExpandableListView expListView;
    List<String> mHeaders;
    HashMap<String, List<ClassBean>> mDataChild;
    List<ClassBean> mAlternativeCourses;
    List<ClassBean> mLearnedCourses;
    List<ClassBean> mSelectedCourses;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        view = inflater.inflate(R.layout.fragment_public_selective_course, null);
        initDatas();
        initViews();
        GetDataAsyncTask task = new GetDataAsyncTask();
        task.execute();
        return view;
    }


    private void initDatas() {
        mHeaders = new ArrayList<>();
        mDataChild = new HashMap<>();
        mAlternativeCourses = new ArrayList<>();
        mSelectedCourses = new ArrayList<>();
        mLearnedCourses = new ArrayList<>();

        // Adding child data
        mHeaders.add("未满公选课");
        mHeaders.add("已选课程");
        mHeaders.add("已修公选课");

        mDataChild.put(mHeaders.get(0), mAlternativeCourses); // Header, Child data
        mDataChild.put(mHeaders.get(1), mSelectedCourses);
        mDataChild.put(mHeaders.get(2), mLearnedCourses);
    }

    /**
     * init the views and events
     */
    private void initViews() {
        // get the listview
        expListView = (ExpandableListView) view.findViewById(
                R.id.public_selective_expand_lv);

        mAdapter = new PublicCourseAdapter(this.getActivity(),
                mHeaders, mDataChild);

        // setting list adapter
        expListView.setAdapter(mAdapter);
        expListView.setOnChildClickListener(this);

        expandAllGroups();
    }



    /**
     * to expand every group
     */
    private void expandAllGroups(){
        for(int i = 0; i < mAdapter.getGroupCount(); i++){
            expListView.expandGroup(i);
        }
    }

    @Override
    public boolean onChildClick(ExpandableListView expandableListView
            , View view, int groupId, int childId, long l) {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        if(groupId == 0){ //alternative course
            ClassBean bean = mAlternativeCourses.get(childId);
            final String courseId = bean.getId();
            builder.setTitle("课程详情")
                    .setMessage("课程名称:" + bean.getClassName()
                            + "\n老师:" + bean.getTeacher()
                            + "\n学分:" + bean.getCredit()
                            + "\n上课时间和地点:" + bean.getTime_and_postion())
                    .setNegativeButton("确定", null)
                    .setPositiveButton("添加此课程", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            new AddCourseAsyncTask(courseId).execute();
//                            Toast.makeText(getActivity(), courseId,
//                                    Toast.LENGTH_SHORT).show();
                        }
                    })
                    .create();
        }else if (groupId == 1){ // selected course
            final ClassBean bean = mSelectedCourses.get(childId);

            builder.setTitle("课程详情")
                    .setMessage("课程名称:" + bean.getClassName()
                            + "\n老师:" + bean.getTeacher()
                            + "\n学分:" + bean.getCredit()
                            + "\n上课时间和地点:" + bean.getTime_and_postion())
                    .setNegativeButton("确定", null)
                    .setPositiveButton("退选此课程", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            new AlertDialog.Builder(getActivity())
                                    .setTitle("注意")
                                    .setMessage("你确定要退选:"
                                            + bean.getClassName() + "?")
                                    .setNegativeButton("取消", null)
                                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialogInterface, int i) {
                                            new RemoveCourseAsyncTask(bean).execute();
                                        }
                                    }).create().show();
                        }
                    });

        }else if (groupId == 2){
            ClassBean bean = mLearnedCourses.get(childId);

            final String courseId = bean.getId();

            builder.setTitle("课程详情")
                    .setMessage("课程名称:" + bean.getClassName()
                            + "\n老师:" + bean.getTeacher()
                            + "\n学分:" + bean.getCredit()
                            + "\n得分:" + bean.getScore())
                    .setNegativeButton("确定", null);

        }


        AlertDialog dialog = builder.create();
        dialog.show();
        TextView messageView = (TextView)dialog.findViewById(android.R.id.message);
        messageView.setGravity(Gravity.CENTER);
        TextView titleView = (TextView)dialog.findViewById(view.getContext()
                .getResources().getIdentifier("alertTitle", "id", "android"));
        if (titleView != null) {
            titleView.setGravity(Gravity.CENTER);
        }

        return false;
    }

    class GetDataAsyncTask extends AsyncTask<Void, Void, Boolean>{

        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(getActivity(),
                    "请等待...", "正在抓取数据...", true, false);
        }

        @Override
        protected Boolean doInBackground(Void... voids) {

            try {
                String data = HttpUtils.get(ConstVal.
                                SEARCH_NOT_FULL_PUBLIC_SELECTIVE_COURSE_URL,
                        UserInfo.getInstance().getCookieStore());
                JsonParser parser = new JsonParser(data);
                mAlternativeCourses = parser.getAlternativeCourses();
                mSelectedCourses = parser.getSelectedCourses();
                mLearnedCourses = parser.getLearnedPublicCourses();

            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }

            return true;
        }

        @Override
        protected void onPostExecute(Boolean aBoolean) {
            super.onPostExecute(aBoolean);
            progressDialog.dismiss();
            if(aBoolean){
                mDataChild.clear();
                mDataChild.put(mHeaders.get(0), mAlternativeCourses); // Header, Child data
                mDataChild.put(mHeaders.get(1), mSelectedCourses);
                mDataChild.put(mHeaders.get(2), mLearnedCourses);
                mAdapter.setDataChild(mDataChild);
            }else {
                Toast.makeText(getActivity(), "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
            }
        }
    }

    class AddCourseAsyncTask extends AsyncTask<Void, Void, String>{
        String courseId = "";
        ProgressDialog progressDialog;

        public AddCourseAsyncTask(String courseId){
            this.courseId = courseId;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(getActivity(),
                    "请等待...", "正在抓取数据...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            String msg;
            Map<String, String> map = new HashMap<>();
            map.put("id", this.courseId);
            map.put("uid", UserInfo.getInstance().getUsername());
            try {
                String data = HttpUtils.post(ConstVal.ADD_PUBLIC_COURSE_URL, map,
                        UserInfo.getInstance().getCookieStore());
                JsonParser parser = new JsonParser(data);
                msg = parser.getResultMsg();

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
                Toast.makeText(getActivity(), "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
                return;
            }
            new AlertDialog.Builder(getActivity())
                    .setTitle("选课结果")
                    .setMessage(s)
                    .setNegativeButton("确定", null)
                    .create()
                    .show();
            new GetDataAsyncTask().execute();
        }
    }

    class RemoveCourseAsyncTask extends AsyncTask<Void, Void, String>{

        ClassBean bean;
        ProgressDialog progressDialog;

        public RemoveCourseAsyncTask(ClassBean bean){
            this.bean = bean;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(getActivity(),
                    "请等待...", "正在抓取数据...", true, false);
        }

        @Override
        protected String doInBackground(Void... voids) {
            String msg;
            Map<String, String> map = new HashMap<>();
            map.put("kch", this.bean.getDYKCH());
            map.put("xh", "");
            map.put("kxh", this.bean.getKXH());
            map.put("uid", UserInfo.getInstance().getUsername());
            try {
                String data = HttpUtils.post(ConstVal.REMOVE_COURSE_URL, map,
                        UserInfo.getInstance().getCookieStore());
                msg = data.split("g")[1]
                        .split(":")[1]
                        .split(" ")[0]
                        .split("\'")[1];
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
                Toast.makeText(getActivity(), "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
                return;
            }
            new AlertDialog.Builder(getActivity())
                    .setTitle("退课结果")
                    .setMessage(s)
                    .setNegativeButton("确定", null)
                    .create()
                    .show();
            new GetDataAsyncTask().execute();
        }
    }

}
