package com.example.myappdemo.httptools;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import android.util.Log;

public class libsearch {
	// http://lib.ustb.edu.cn:8080/opac/openlink.php?strSearchType=title&match_flag=forward
	// &historyCount=1&strText=Java&doctype=ALL&displaypg=20&
	// showmode=list&sort=CATA_DATE&orderby=desc&dept=ALL
	public final String libraryurl = "http://lib.ustb.edu.cn:8080";
	static HttpClient httpclient;
	private HttpResponse httpresponse;

	/**
	 * 进行图书目录检索
	 * 
	 * @param strText
	 *            要搜索的关键字
	 * @return 包含图书列表的页面源码
	 */
	public String getbooklist(String strText, int page) {
		String result = "";
		final String url;
		if (page == 1) {
			url = libraryurl
					+ "/opac/openlink.php?strSearchType="
					+ "title"
					+ "&match_flag="
					+ "forward"
					+ "&historyCount=1&strText="
					+ strText
					+ "&doctype=ALL&displaypg=20&showmode=list&sort=CATA_DATE&orderby=desc&dept=ALL";
		} else {
			// http://lib.ustb.edu.cn:8080/opac/openlink.php?dept=ALL&title=Photoshop&doctype=ALL&lang_code=ALL&match_flag=forward&displaypg=20&showmode=list&orderby=DESC&sort=CATA_DATE&onlylendable=no&count=1360&with_ebook=&page=2
			url = libraryurl
					+ "/opac/openlink.php?dept=ALL&title="
					+ strText
					+ "&doctype=ALL&lang_code=ALL&match_flag=forward&displaypg=20"
					+ "&showmode=list&orderby=DESC&sort=CATA_DATE&onlylendable=no&count=1360&with_ebook=&page="
					+ page;
		}
		final HttpGet httpget = new HttpGet(url);
		try {
			httpclient = new DefaultHttpClient();
			httpresponse = httpclient.execute(httpget);
			// if (httpresponse.getStatusLine().getStatusCode() == 200) {
			// result = EntityUtils.toString(httpresponse.getEntity());
			result = EntityUtils.toString(httpresponse.getEntity(), "utf-8");
			// }
		} catch (final ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (final IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println(result + "--result---");
		//System.out.println(url + "--url---");
		return result;
	}

	/**
	 * 将html源码进行解析
	 * 
	 * @param html
	 *            要进行解析的html源码
	 * @param operation
	 * @return 解析结果
	 * @throws UnsupportedEncodingException
	 */
	public List<Map<String, Object>> Parsebooklist(final String html,
			final int operation) {
		Document localDocument = Jsoup.parse(html);
		Elements localElements1 = localDocument.select(".book_list_info");
		ArrayList<Map<String, Object>> localArrayList = new ArrayList();
		for (int j = 0; j < localElements1.size(); j++) {
			HashMap<String, Object> localHashMap1 = new HashMap<String, Object>();
			Element localElement = localElements1.get(j);
			localHashMap1.put("book_name", localElement.select("a:eq(1)")
					.text());
			String str2 = localElement.select("a").attr("href");
			localHashMap1.put("book_searchno",
					str2.substring(1 + str2.lastIndexOf('=')));
//			Log.e("book_searchno",str2.substring(1 + str2.lastIndexOf('=')));
			localElement.select("a").remove();
			localHashMap1.put("book_location",
					new String(localElement.select("h3").text()));
			localHashMap1.put("book_num", new String(localElement.select("p")
					.select("span").text()));
			localElement.select("p").select("span").remove();
			localHashMap1.put("book_from", localElement.select("p").text());
			localHashMap1.put("isCollected", Boolean.valueOf(false));
			localArrayList.add(localHashMap1);
		}
		return localArrayList;
	}

	/**
	 * 
	 * @param strText
	 *            要查找的书号
	 * @return 查询结果
	 */
	public String getbookdetail(String book_searchno) {
		String result = "";
		final String url = libraryurl + "/opac/item.php?marc_no="
				+ book_searchno;
		Log.i("url", url);
		final HttpGet httpget = new HttpGet(url);
		try {
			httpclient = new DefaultHttpClient();
			httpresponse = httpclient.execute(httpget);
			// if (httpresponse.getStatusLine().getStatusCode() == 200) {
			// result = EntityUtils.toString(httpresponse.getEntity());
			result = EntityUtils.toString(httpresponse.getEntity(), "utf-8");
			// }
		} catch (final ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (final IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println(result + "--result---");

		return result;
	}

	/**
	 * 
	 * @param html
	 *            图书详情页面
	 * @return 解析结果
	 */
	public ArrayList<String> Parsebookdetail(final String html) {
		Document Document = Jsoup.parse(html);
		ArrayList<String> list = new ArrayList<String>();
		Elements Elements1 = Document.select("div[id=item_detail] dt");
		Elements Elements2 = Document.select("div[id=item_detail] dd");
		for (int i = 0; i < Elements1.size() - 3; i++) {
			Log.i(i + "", Elements1.get(i).text());
			Log.i(i + "", Elements2.get(i).text());
			list.add(Elements1.get(i).text());
			list.add(Elements2.get(i).text() + "\n");
		}
		Elements Elements3 = Document.select("tr[align=left]");
		for (int i = 0; i < 5; i++) {
			list.add(Elements3.get(0).select("td").get(i).text());
			String s = "";
			for(int j = 1; j < Elements3.size(); j++){
				s = s + Elements3.get(j).select("td").get(i).text() + "\n";
			}
			list.add(s);
		}
		Log.i("tag", "finish");
		return list;
	}

}
