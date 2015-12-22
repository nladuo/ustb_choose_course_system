package kalen.app.ustb_choose_course_system.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.List;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ClassBean;

/**
 * Created by kalen on 15-9-9.
 */
public class PrerequisiteAndSpecifiedCourseAdapter extends BaseAdapter{

    List<ClassBean> mDatas;
    LayoutInflater mInflater;

    public PrerequisiteAndSpecifiedCourseAdapter(Context context, List<ClassBean> datas){
        this.mDatas = datas;
        mInflater = LayoutInflater.from(context);
    }

    public void setDatas(List<ClassBean> datas){
        this.mDatas = datas;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return mDatas.size();
    }

    @Override
    public ClassBean getItem(int i) {
        return mDatas.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {

        ViewHolder holder = null;
        //如果缓存convertView为空，则需要创建View
        if(convertView == null)
        {
            holder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.item_prerequisite_and_specified_course, null);
            holder.classNameTv = (TextView)convertView.findViewById(R.id.item_pre_classname);
            holder.scoreTv = (TextView)convertView.findViewById(R.id.item_pre_score);
            convertView.setTag(holder);
        }else
        {
            holder = (ViewHolder)convertView.getTag();
        }
        holder.scoreTv.setText(mDatas.get(i).getScore().equals("null") ? "" : mDatas.get(i).getScore() + "   ");
        holder.classNameTv.setText(mDatas.get(i).getClassName());
        return convertView;
    }

    class ViewHolder
    {
        public TextView classNameTv;
        public TextView scoreTv;
    }
}
