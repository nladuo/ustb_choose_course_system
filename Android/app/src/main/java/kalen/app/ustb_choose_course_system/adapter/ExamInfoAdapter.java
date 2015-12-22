package kalen.app.ustb_choose_course_system.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.List;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ExamInfo;
import kalen.app.ustb_choose_course_system.model.InnovateCredit;

/**
 * Created by kalen on 15-11-24.
 */
public class ExamInfoAdapter extends BaseAdapter {

    List<ExamInfo> mDatas;
    LayoutInflater mInflater;

    public ExamInfoAdapter(Context context, List<ExamInfo> datas){
        this.mDatas = datas;
        mInflater = LayoutInflater.from(context);
    }

    public void setDatas(List<ExamInfo> datas){
        this.mDatas = datas;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return mDatas.size();
    }

    @Override
    public ExamInfo getItem(int i) {
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
            convertView = mInflater.inflate(R.layout.item_examinfo, null);
            holder.className = (TextView)convertView.findViewById(R.id.item_exam_name);
            holder.examTime = (TextView)convertView.findViewById(R.id.item_exam_time);
            holder.examLocation = (TextView)convertView.findViewById(R.id.item_exam_location);
            convertView.setTag(holder);
        }else
        {
            holder = (ViewHolder)convertView.getTag();
        }
        holder.className.setText(mDatas.get(i).getClassName());
        holder.examTime.setText(mDatas.get(i).getExamTime());
        holder.examLocation.setText(mDatas.get(i).getExamLocation());

        return convertView;
    }

    class ViewHolder
    {
        public TextView className;
        public TextView examTime;
        public TextView examLocation;
    }
}
