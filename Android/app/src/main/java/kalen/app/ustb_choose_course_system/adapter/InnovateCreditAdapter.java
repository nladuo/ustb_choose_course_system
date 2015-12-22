package kalen.app.ustb_choose_course_system.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import java.util.List;
import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.InnovateCredit;

/**
 * Created by kalen on 15-11-24.
 */
public class InnovateCreditAdapter extends BaseAdapter {

    List<InnovateCredit> mDatas;
    LayoutInflater mInflater;

    public InnovateCreditAdapter(Context context, List<InnovateCredit> datas){
        this.mDatas = datas;
        mInflater = LayoutInflater.from(context);
    }

    public void setDatas(List<InnovateCredit> datas){
        this.mDatas = datas;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return mDatas.size();
    }

    @Override
    public InnovateCredit getItem(int i) {
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
            convertView = mInflater.inflate(R.layout.item_innovate_credit, null);
            holder.type = (TextView)convertView.findViewById(R.id.item_credit_type);
            holder.name = (TextView)convertView.findViewById(R.id.item_credit_name);
            holder.credit = (TextView)convertView.findViewById(R.id.item_credit_credit);
            convertView.setTag(holder);
        }else
        {
            holder = (ViewHolder)convertView.getTag();
        }
        holder.name.setText(mDatas.get(i).getName());
        holder.type.setText(mDatas.get(i).getType());
        holder.credit.setText(mDatas.get(i).getCredit());

        return convertView;
    }

    class ViewHolder
    {
        public TextView type;
        public TextView name;
        public TextView credit;
    }
}
