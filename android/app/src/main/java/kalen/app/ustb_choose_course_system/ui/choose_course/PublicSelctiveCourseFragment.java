package kalen.app.ustb_choose_course_system.ui.choose_course;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.adapter.SearchCourseAdapter;
import kalen.app.ustb_choose_course_system.model.ClassBean;
import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.model.UserInfo;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

/**
 * Created by kalen on 15-8-16.
 */
public class PublicSelctiveCourseFragment extends Fragment {
    View view;
    SearchCourseAdapter mAdapter;
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

    private void initViews() {
        // get the listview
        expListView = (ExpandableListView) view.findViewById(
                R.id.public_selective_expand_lv);

        mAdapter = new SearchCourseAdapter(this.getActivity(),
                mHeaders, mDataChild);

        // setting list adapter
        expListView.setAdapter(mAdapter);

    }

    class GetDataAsyncTask extends AsyncTask<Void, Void, Boolean>{

        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(getActivity(),
                    "Loading...", "Please wait...", true, false);
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
                Toast.makeText(getActivity(), "failed", Toast.LENGTH_SHORT).show();
            }
        }
    }

}
