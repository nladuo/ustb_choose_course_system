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
public class DetailAdpater extends BaseAdapter {

    List<ClassBean> mDatas;
    LayoutInflater mInflater;

    public DetailAdpater(Context context, List<ClassBean> datas){
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
        if(convertView == null)
        {
            holder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.item_search_course, null);
            holder.classNameTv = (TextView)convertView
                    .findViewById(R.id.item_search_classname);
            holder.teacherTv = (TextView)convertView
                    .findViewById(R.id.item_search_teacher);
            holder.creditTv = (TextView) convertView
                    .findViewById(R.id.item_search_credit);
            holder.timeAndPositionOrScoreTv = (TextView) convertView
                    .findViewById(R.id.item_search_time_and_position_or_score);
            holder.ratioTv = (TextView) convertView
                    .findViewById(R.id.item_search_ratio);
            convertView.setTag(holder);
        }else
        {
            holder = (ViewHolder)convertView.getTag();
        }

        ClassBean bean = mDatas.get(i);

        holder.classNameTv.setText(bean.getClassName());
        holder.teacherTv.setText(bean.getTeacher());
        holder.creditTv.setText(bean.getCredit() + "学分");
        holder.timeAndPositionOrScoreTv.setText(bean.getTime_and_postion());
        holder.ratioTv.setText(bean.getRatio());

        return convertView;
    }

    class ViewHolder
    {
        public TextView classNameTv;
        public TextView teacherTv;
        public TextView creditTv;
        public TextView timeAndPositionOrScoreTv;
        public TextView ratioTv;
    }
}
