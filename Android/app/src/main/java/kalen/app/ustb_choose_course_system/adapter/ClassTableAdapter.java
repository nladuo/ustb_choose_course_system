package kalen.app.ustb_choose_course_system.adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-8-16.
 */
public class ClassTableAdapter extends RecyclerView.Adapter<MyViewHolder> {

    public static final int NORMAL_CLASS = 0;
    public static final int OTHER_CLASS = 1;

    private LayoutInflater mInflater;
    private String[] mDatas;

    public void setDatas(String[] datas){
        this.mDatas = datas;
        notifyDataSetChanged();
    }

    public ClassTableAdapter(Context context, String[] datas) {
        this.mDatas = datas;
        mInflater = LayoutInflater.from(context);

    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView;
        if(viewType == NORMAL_CLASS){
            itemView = mInflater.inflate(R.layout.item_normal_class_table, parent, false);
        }else{
            itemView = mInflater.inflate(R.layout.item_other_class_table, parent, false);
        }
        MyViewHolder viewHolder = new MyViewHolder(itemView, viewType);
        return viewHolder;

    }


    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {

        //holder.tView.setTextColor(Color.BLUE);
        if(isLessOrEqualThanThreeLines(mDatas[position]) ){
            holder.tView.setText(mDatas[position]);
            holder.tView.setTextColor(Color.BLACK);
            if(holder.iView != null) {
                holder.iView.setVisibility(View.GONE);
            }
        }else{
            holder.tView.setText(getFirstThreeLines(mDatas[position]));
            holder.tView.setTextColor(Color.argb(255, 0x03, 0xA9, 0xF4));
            if(holder.iView != null) {
                holder.iView.setVisibility(View.VISIBLE);
            }
        }
        holder.setViewText(mDatas[position]);
    }

    private boolean isLessOrEqualThanThreeLines(String data) {
        if(data == null){
            return true;
        }
        return data.split("\n").length <= 3;
    }

    private String getFirstThreeLines(String data){
        String datas[] = data.split("\n");
        return datas[0] + "\n" + datas[1] + "\n" + datas[2];
    }

    @Override
    public int getItemCount() {
        return mDatas.length;
    }

    @Override
    public int getItemViewType(int position) {
        if (position == 15){
            return OTHER_CLASS;
        }else{
            return NORMAL_CLASS;
        }
    }
}

class MyViewHolder extends RecyclerView.ViewHolder {

    public TextView tView;
    public ImageView iView;
    private String tViewText;

    public void setViewText(String text){
        tViewText =text;
    }

    public MyViewHolder(View itemView, int viewType) {
        super(itemView);
        if(viewType == ClassTableAdapter.NORMAL_CLASS){
            tView = (TextView) itemView.findViewById(R.id.item_normal_class);
            iView = (ImageView) itemView.findViewById(R.id.item_normal_class_tag);
        }else{
            tView = (TextView) itemView.findViewById(R.id.item_other_class);
            iView = null;
        }
        tView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //String tvStr = ((TextView) view).getText().toString();
                if(tViewText != null){
                    if (tViewText.split("\\(").length > 1){
                        AlertDialog.Builder builder = new AlertDialog.
                                Builder(view.getContext());
                        builder.setTitle("课程详细");
                        builder.setMessage(tViewText);
                        builder.setNegativeButton("确定", null);
                        AlertDialog dialog = builder.create();
                        dialog.show();
                        TextView messageView = (TextView)dialog.findViewById(android.R.id.message);
                        messageView.setGravity(Gravity.CENTER);
                        TextView titleView = (TextView)dialog.findViewById(view.getContext()
                                .getResources().getIdentifier("alertTitle", "id", "android"));
                        if (titleView != null) {
                            titleView.setGravity(Gravity.CENTER);
                        }
                    }
                }

            }
        });


    }

}