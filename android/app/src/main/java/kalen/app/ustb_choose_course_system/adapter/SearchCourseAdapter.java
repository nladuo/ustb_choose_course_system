package kalen.app.ustb_choose_course_system.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ClassBean;

/**
 * Created by kalen on 15-8-17.
 */
public class SearchCourseAdapter extends BaseExpandableListAdapter {
    private Context context;
    private List<String> mHeaders; // header titles
    // child data in format of header title, child title
    private HashMap<String, List<ClassBean>> mDataChild;

    public void setDataChild(HashMap<String, List<ClassBean>> dataChild){
        this.mDataChild = dataChild;
        notifyDataSetChanged();
    }

    public SearchCourseAdapter(Context context, List<String> headers,
                                 HashMap<String, List<ClassBean>> childData) {
        this.context = context;
        this.mHeaders = headers;
        this.mDataChild = childData;
    }

    @Override
    public ClassBean getChild(int groupPosition, int childPosititon) {
        return this.mDataChild.get(this.mHeaders.get(groupPosition))
                .get(childPosititon);
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public View getChildView(int groupPosition, final int childPosition,
                             boolean isLastChild, View convertView, ViewGroup parent) {

        ClassBean bean = getChild(groupPosition, childPosition);

        final String className = bean.getClassName();
        final String teacher = bean.getTeacher();
        final String credit = bean.getCredit() + "学分";
        String time_and_position_or_score = "";
        if(groupPosition == 2){
            time_and_position_or_score = "得分：" + bean.getScore();
        }else{
            time_and_position_or_score = bean.getTime_and_postion();
        }


        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this.context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.item_search_course, null);
        }

        TextView classNameTv = (TextView) convertView
                .findViewById(R.id.item_search_classname);
        TextView teacherTv = (TextView) convertView
                .findViewById(R.id.item_search_teacher);
        TextView creditTv = (TextView) convertView
                .findViewById(R.id.item_search_credit);
        TextView timeAndPositionOrScoreTv = (TextView) convertView
                .findViewById(R.id.item_search_time_and_position_or_score);

        classNameTv.setText(className);
        teacherTv.setText(teacher);
        creditTv.setText(credit);
        timeAndPositionOrScoreTv.setText(time_and_position_or_score);

        return convertView;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return this.mDataChild.get(this.mHeaders.get(groupPosition))
                .size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return this.mHeaders.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        return this.mHeaders.size();
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded,
                             View convertView, ViewGroup parent) {
        String headerTitle = (String) getGroup(groupPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this.context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.item_header_search_course, null);
        }

        TextView lblListHeader = (TextView) convertView
                .findViewById(R.id.item_search_header);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(headerTitle);

        return convertView;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}
