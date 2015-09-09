package kalen.app.ustb_choose_course_system.service;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Binder;
import android.os.Environment;
import android.os.IBinder;
import android.widget.RemoteViews;
import android.widget.Toast;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-8-29.
 */
public class DownLoadService extends Service{

    NotificationManager manager;
    Notification notification=new Notification();
    static DownLoadAsyncTask task;
    private RemoteViews view=null;

    @Override
    public void onCreate() {
        super.onCreate();

        view = new RemoteViews(getPackageName(),R.layout.notification_download);
        manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        notification.icon = R.mipmap.ic_launcher;
        view.setImageViewResource(R.id.download_noti_image, R.mipmap.ic_launcher);
    }

    /**
     * excute -->
     *              params[0]--->download filename
     *              params[1]--->download url
     * @return
     */
    public DownLoadAsyncTask getTask(){
        if(task == null){
            task = new DownLoadAsyncTask();
        }
        return task;
    }

    private IBinder binder = new MyBinder();


    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    public class MyBinder extends Binder {

        public DownLoadService getService(){
            return DownLoadService.this;
        }
    }



    public class DownLoadAsyncTask extends AsyncTask<String, Integer, String>{


        @Override
        protected void onPostExecute(String str) {
            super.onPostExecute(str);
            if (str != null)
            {
                Toast.makeText(getApplicationContext(), "下载完成",
                        Toast.LENGTH_SHORT).show();

                //the result is the filepath
                String fileName = str;
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setDataAndType(Uri.fromFile(new File(fileName)),
                        "application/vnd.android.package-archive");
                startActivity(intent);

            }else{
                Toast.makeText(getApplicationContext(),"下载失败", Toast.LENGTH_SHORT).show();
            }
        }

        @Override
        protected void onProgressUpdate(Integer... values) {
            super.onProgressUpdate(values);
            System.out.println("progress ---> " + values[0]);

            view.setProgressBar(R.id.download_noti_pb, 100, values[0], false);
            view.setTextViewText(R.id.download_noti_tv, "下载"+values[0]+"%");//关键部分，如果你不重新更新通知，进度条是不会更新的
            notification.contentView=view;
            manager.notify(0, notification);
        }

        @Override
        protected String doInBackground(String... strings) {
            String filename = strings[0];
            String downloadUrl = strings[1];
            HttpClient client = new DefaultHttpClient();
            HttpGet get = new HttpGet(downloadUrl);
            try
            {
                HttpResponse resp = client.execute(get);
                if(resp.getStatusLine().getStatusCode() == 200)
                {
                    HttpEntity entity = resp.getEntity();
                    if(entity == null)
                    {
                        return null;
                    }
                    long total_length = entity.getContentLength();//获取文件总长
                    InputStream is = entity.getContent();
                    String path = Environment.getExternalStorageDirectory()
                            + File.separator + filename;
                    FileOutputStream out = new FileOutputStream(new File(path));
                    int len = 0;
                    byte[] buf = new byte[1024];
                    int current_len = 0;
                    int progress = 0;//当前下载进度
                    int lastProgress = 0;
                    while((len = is.read(buf))!= -1)
                    {
                        current_len+=len;
                        out.write(buf, 0 ,len);
                        //bous.write(buf, 0, len);
                        progress = (int) ((current_len/(float)total_length)*100);
                        if (progress != lastProgress){
                            this.publishProgress(progress);
                        }
                        lastProgress = progress;
                    }
                    is.close();
                    out.close();
                    return path;

                }
            } catch (Exception e)
            {
                e.printStackTrace();
            }
            return null;
        }
    }






}
