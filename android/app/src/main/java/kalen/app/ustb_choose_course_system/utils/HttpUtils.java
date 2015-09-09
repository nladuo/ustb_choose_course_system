package kalen.app.ustb_choose_course_system.utils;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.CookieStore;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HTTP;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by kalen on 15-8-11.
 */
public class HttpUtils {

    public static String post(String url, Map<String, String> map,
                              CookieStore cookieStore) throws Exception{

        //POST的URL
        HttpPost httppost=new HttpPost(url);
        //建立HttpPost对象
        List<NameValuePair> params= new ArrayList<>();
        //建立一个NameValuePair数组，用于存储欲传送的参数
        for (Map.Entry<String, String> entry : map.entrySet()){
            params.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
        }

        HttpContext context = new BasicHttpContext();
        context.setAttribute(ClientContext.COOKIE_STORE, cookieStore);

        //添加参数
        httppost.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));
        //设置编码
        HttpResponse response=new DefaultHttpClient().execute(httppost, context);
        if(response.getStatusLine().getStatusCode() == 200){
            //如果状态码为200,就是得到Json

            String result1 = EntityUtils.toString(response.getEntity(), "utf-8");
            String utf8Result = URLDecoder.decode(result1, "utf-8");
            return  utf8Result;
        }else{
            throw new Exception();
        }

    }

    public static String get(String url, CookieStore cookieStore)
            throws Exception{

        HttpContext context = new BasicHttpContext();
        context.setAttribute(ClientContext.COOKIE_STORE, cookieStore);

        HttpGet httpget=new HttpGet(url);
        HttpResponse response=new DefaultHttpClient().execute(httpget,context);
        if(response.getStatusLine().getStatusCode() == 200){
            //如果状态码为200,就是得到Json
            return  EntityUtils.toString(response.getEntity());
        }else{
            throw new Exception();
        }
    }

    public static CookieStore postWithCookies(String url, Map<String, String> map)
            throws Exception{
        //POST的URL
        HttpPost httppost=new HttpPost(url);
        //建立HttpPost对象
        List<NameValuePair> params= new ArrayList<>();
        //建立一个NameValuePair数组，用于存储欲传送的参数
        for (Map.Entry<String, String> entry : map.entrySet()){
            params.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
        }

        HttpContext context = new BasicHttpContext();
        CookieStore cookieStore = new BasicCookieStore();

        context.setAttribute(ClientContext.COOKIE_STORE, cookieStore);

        //添加参数
        httppost.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));
        //设置编码
        HttpResponse response=new DefaultHttpClient().execute(httppost, context);

        //System.out.println(EntityUtils.toString(response.getEntity()));
        if(response.getStatusLine().getStatusCode() == 200){
            //如果状态码为200,就是得到了cookie
            return  cookieStore;
        }else{
            throw new Exception();
        }
    }
}
