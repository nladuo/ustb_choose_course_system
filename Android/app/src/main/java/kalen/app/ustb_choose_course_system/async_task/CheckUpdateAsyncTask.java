package kalen.app.ustb_choose_course_system.async_task;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.AsyncTask;
import android.os.IBinder;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import kalen.app.ustb_choose_course_system.model.ConstVal;
import kalen.app.ustb_choose_course_system.service.DownLoadService;
import kalen.app.ustb_choose_course_system.utils.HttpUtils;
import kalen.app.ustb_choose_course_system.utils.JsonParser;

public class CheckUpdateAsyncTask extends AsyncTask<Void, Void, String> {
    ProgressDialog progressDialog;
    Context context;
    boolean isForeGround;

    public CheckUpdateAsyncTask(Context context, boolean isForeGround){
        this.context = context;
        this.isForeGround = isForeGround;

    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        if (isForeGround){
            progressDialog = ProgressDialog.show(context,
                    "请等待...", "正在加载中...", true, false);
        }

    }

    @Override
    protected String doInBackground(Void... voids) {
        String jsonData;
        try {
            jsonData = HttpUtils.get(ConstVal.APP_UPDATE_CHECK_URL, null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return jsonData;
    }

    @Override
    protected void onPostExecute(String s) {
        super.onPostExecute(s);
        if (isForeGround){
            progressDialog.dismiss();
        }

        if (s == null){
            if (isForeGround){
                Toast.makeText(context,
                        "加载失败，请检查网络配置", Toast.LENGTH_SHORT).show();
            }
            return;
        }
        try {
            JsonParser parser = new JsonParser(s);
            JSONObject object = parser.getJsonObject();
            double version = object.getDouble("version");
            //Check whether need to update
            System.out.println("Newest Version->" + version);
            System.out.println("Now Version->" + ConstVal.VERSION);
            if ((version - ConstVal.VERSION) > 0.001){
                // need to update
                String releasedNote = object.getString("update_note");
                final String appName = object.getString("app_name");
                AlertDialog dialog = new AlertDialog
                        .Builder(context)
                        .setTitle("检测到新的版本")
                        .setMessage("当前版本号:" + ConstVal.VERSION
                                + "\n最新版本号:" + version
                                + "\n更新说明:" + releasedNote)
                        .setNegativeButton("确定", null)
                        .setPositiveButton("下载更新", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                Toast.makeText(context, "开始下载...", Toast.LENGTH_SHORT).show();
                                startDownload(appName,
                                        ConstVal.APP_DOWNLOAD_URL);
                            }
                        })
                        .create();
                dialog.show();
            }else{
                if (isForeGround){
                    AlertDialog dialog = new AlertDialog
                            .Builder(context)
                            .setTitle("提示")
                            .setMessage("已经是最新版本")
                            .setNegativeButton("确定", null)
                            .create();
                    dialog.show();
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
            if (isForeGround){
                Toast.makeText(context,
                        "内部解析错误", Toast.LENGTH_SHORT).show();
            }

        }
    }

    private void startDownload(String filename, String url){

        final String downloadFilename = filename;
        final String downloadUrl = url;


        Intent intent=new Intent(context, DownLoadService.class);
        context.bindService(intent, new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName componentName,
                                           IBinder binder) {

                DownLoadService downLoadService = ((DownLoadService.MyBinder) binder)
                        .getService();
                downLoadService.getTask().execute(downloadFilename,
                        downloadUrl);
            }

            @Override
            public void onServiceDisconnected(ComponentName componentName) {
            }
        }, Context.BIND_AUTO_CREATE);

    }
}

