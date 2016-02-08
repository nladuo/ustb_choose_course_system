package com.example.myappdemo.fragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.myappdemo.R;
import com.example.myappdemo.R.color;
import com.example.myappdemo.Activity.BookDetails;
import com.example.myappdemo.httptools.libsearch;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView.FindListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.ListView;
import android.widget.Toast;

public class LibSearchFragment extends Fragment {

	private View currentview;
	private Button searchbtn,more;
	private EditText wordtv;
	private String CurrentKey = "";
	private ProgressBar pb;
	private libsearch libsearch;
	private RelativeLayout linearlayout;
	private ListView list;
	private ArrayList<Map<String, Object>> mData = new ArrayList<Map<String, Object>>();;
	private String booklist = "";
	private SimpleAdapter adapter;
	final private String[] s1 = new String[] { "bookname", "bookclass", "bookauthor",
			"booknum" };
	final private int[] s2 = new int[] { R.id.bookname, R.id.bookclass,
			R.id.bookauthor, R.id.booknum };

	private int currentPage = 0;
	
	public View getCurrentview() {
		return currentview;
	}

	public LibSearchFragment() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		currentview = inflater.inflate(R.layout.libsearch, container, false);
		searchbtn = (Button) currentview.findViewById(R.id.searchbtn);
		wordtv = (EditText) currentview.findViewById(R.id.keyword);
		list = (ListView) currentview.findViewById(R.id.listView1);
		pb = (ProgressBar)currentview.findViewById(R.id.pb);
		more = (Button) currentview.findViewById(R.id.more);
		more.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				new MoreTask().execute(++currentPage);
			}
		});
		linearlayout = (RelativeLayout) currentview
				.findViewById(R.id.linearlayout);
		searchbtn.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				CurrentKey = wordtv.getText().toString();
				new MyTask().execute(CurrentKey);
				InputMethodManager imm = (InputMethodManager) getActivity()
						.getSystemService(Context.INPUT_METHOD_SERVICE);
				wordtv.setCursorVisible(false);// 失去光标
				imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
			}
		});

		linearlayout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (v.getId() == R.id.linearlayout) {
					InputMethodManager imm = (InputMethodManager) getActivity()
							.getSystemService(Context.INPUT_METHOD_SERVICE);
					wordtv.setCursorVisible(false);// 失去光标
					imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
				}
			}
		});

		list.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				InputMethodManager imm = (InputMethodManager) getActivity()
						.getSystemService(Context.INPUT_METHOD_SERVICE);
				wordtv.setCursorVisible(false);// 失去光标
				imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
				return false;
			}
		});
		return currentview;
	}

	public class MyTask extends
			AsyncTask<String, Integer, List<Map<String, Object>>> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			pb.setProgress(0);
		}

		@Override
		protected void onPostExecute(final List<Map<String, Object>> result) {
			// TODO Auto-generated method stub

			if (result == null) {
				if (booklist.equals("")) {
					Toast toast = Toast.makeText(getActivity(), "网络连接失败",
							Toast.LENGTH_SHORT);
					toast.show();
				} else {

				}
			} else {
				if (list.getChildCount() != 0) {
					list.invalidateViews();
					Log.i("list.invalidateViews()", "list.invalidateViews()");
				}
				if (result.size() == 0) {
					Toast toast = Toast.makeText(getActivity(), "没有找到您要检索的图书",
							Toast.LENGTH_SHORT);
					toast.show();
				} else {
					mData.clear();
					for (int i = 0; i < result.size(); i++) {
						Map<String, Object> item = new HashMap<String, Object>();
						item.put("bookname", result.get(i).get("book_name"));
						item.put("bookclass", result.get(i)
								.get("book_location"));
						item.put("bookauthor", result.get(i).get("book_from"));
						item.put("booknum", result.get(i).get("book_num"));
						item.put("book_searchno", result.get(i).get("book_searchno"));
						mData.add(item);
						publishProgress(40+(i/result.size())*40);
					}
					adapter = new SimpleAdapter(getActivity(), mData,
							R.layout.booklistitem, s1, s2);
					list.setAdapter(adapter);
					adapter.notifyDataSetChanged();
					list.setOnItemClickListener(new OnItemClickListener() {
						@Override
						public void onItemClick(AdapterView<?> adapterView,
								View view, int position, long id) {
							Intent intent = new Intent(getActivity(),
									BookDetails.class);
							intent.putExtra("book_searchno", (String) mData
									.get(position).get("book_searchno"));
							Log.i("book_searchno", (String) mData
									.get(position).get("book_searchno"));
							getActivity().startActivity(intent);
						}
					});
				}
			}
			more.setVisibility(View.VISIBLE);
			currentPage = 1;
			publishProgress(100);
		}

		@Override
		protected List<Map<String, Object>> doInBackground(String... params) {
			// TODO Auto-generated method stub
			if(libsearch == null){
				libsearch = new libsearch();		
			}
			booklist = libsearch.getbooklist(params[0], 1);
			publishProgress(20);
			if (booklist.equals("") || booklist == null) {
				publishProgress(40);
				return null;
			} else {
				List<Map<String, Object>> list = libsearch.Parsebooklist(
						booklist, 0);
				publishProgress(40);
				return list;
			}
		}

		@Override
		protected void onProgressUpdate(Integer... values) {
			// TODO Auto-generated method stub
			super.onProgressUpdate(values);
			pb.setProgress(values[0]);
		}

	}
	
	/**
	 * 加载下一页
	 * @author tr
	 *
	 */
	
	public class MoreTask extends AsyncTask<Integer,Integer,List<Map<String, Object>>>{

		
		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			pb.setProgress(0);
		}
		
		
		@Override
		protected List<Map<String, Object>> doInBackground(Integer... params) {
			// TODO Auto-generated method stub
			if(libsearch == null){
				return null;
			}
			booklist = libsearch.getbooklist(CurrentKey, params[0]);
			if (booklist.equals("") || booklist == null) {
				publishProgress(40);
				return null;
			} else {
				List<Map<String, Object>> list = libsearch.Parsebooklist(
						booklist, 0);
				publishProgress(40);
				return list;
			}
		}
		
		@Override
		protected void onPostExecute(final List<Map<String, Object>> result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			if (result == null) {
				if (booklist.equals("")) {
					Toast toast = Toast.makeText(getActivity(), "网络连接失败",
							Toast.LENGTH_SHORT);
					toast.show();
				} else {

				}
			} else {
				if (list.getChildCount() != 0) {
					list.invalidateViews();
					Log.i("list.invalidateViews()", "list.invalidateViews()");
				}
				if (result.size() == 0) {
					Toast toast = Toast.makeText(getActivity(), "已经加载完毕",
							Toast.LENGTH_SHORT);
					toast.show();
					more.setVisibility(View.GONE);
				} else {
					for (int i = 0; i < result.size(); i++) {
						Map<String, Object> item = new HashMap<String, Object>();
						item.put("bookname", result.get(i).get("book_name"));
						item.put("bookclass", result.get(i)
								.get("book_location"));
						item.put("bookauthor", result.get(i).get("book_from"));
						item.put("booknum", result.get(i).get("book_num"));
						item.put("book_searchno", result.get(i).get("book_searchno"));
						mData.add(item);
						publishProgress(40+(i/result.size())*40);
					}
					adapter = new SimpleAdapter(getActivity(), mData,
							R.layout.booklistitem, s1, s2);
					adapter.notifyDataSetChanged();
					Log.i("mdatasize",mData.size()+"");
					list.setOnItemClickListener(new OnItemClickListener() {
						@Override
						public void onItemClick(AdapterView<?> adapterView,
								View view, int position, long id) {
							Intent intent = new Intent(getActivity(),
									BookDetails.class);
							intent.putExtra("book_searchno", (String) mData
									.get(position).get("book_searchno"));
							Log.i("book_searchno123", (String) mData
									.get(position).get("book_searchno"));
							getActivity().startActivity(intent);
						}
					});
				}
			}
			publishProgress(100);
		}
		
		
		@Override
		protected void onProgressUpdate(Integer... values) {
			// TODO Auto-generated method stub
			super.onProgressUpdate(values);
			pb.setProgress(values[0]);
		}

	}
	
	
}
