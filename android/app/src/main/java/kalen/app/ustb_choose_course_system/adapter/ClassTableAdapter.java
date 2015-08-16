package kalen.app.ustb_choose_course_system.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-8-16.
 */
public class ClassTableAdapter extends RecyclerView.Adapter<MyViewHolder>{
    private LayoutInflater mInflater;
    private List<String> mDatas;


    public ClassTableAdapter(Context context, List<String> datas) {
        this.mDatas = datas;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int pos) {
        holder.tView.setText(mDatas.get(pos));
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup arg0, int arg1) {
//        View itemView = mInflater.inflate(R.layout.item_simple_textview,arg0, false);
//        MyViewHolder viewHolder = new MyViewHolder(itemView);
//        return viewHolder;

        return null;
    }
}


class MyViewHolder extends RecyclerView.ViewHolder {

    TextView tView;
    public MyViewHolder(View itemView) {
        super(itemView);
        //tView = (TextView) itemView.findViewById(R.id.id_tv);
    }

}
