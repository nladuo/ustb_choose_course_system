package com.example.myappdemo.Activity;

import java.util.ArrayList;
import java.util.Map;

import com.example.myappdemo.R;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.ProgressBar;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;

import com.example.myappdemo.httptools.libsearch;

;

public class BookDetails extends Activity {

	private libsearch libsearch;
	private ProgressBar pb;
	private TableLayout tablelayout;
	public BookDetails() {
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_bookdetails);
		pb = (ProgressBar)findViewById(R.id.pb);
		tablelayout = (TableLayout)findViewById(R.id.tablelayout);
		new MyTask().execute(getIntent().getStringExtra("book_searchno"));
	}

	public class MyTask extends AsyncTask<String, Integer, ArrayList<String>> {

		@Override
		protected ArrayList<String> doInBackground(String... params) {
			// TODO Auto-generated method stub
			libsearch = new libsearch();
			String result = libsearch.getbookdetail(params[0]);
			publishProgress(20);
			if (result.equals("")) {
				return null;
			} else {
				ArrayList<String> list = libsearch.Parsebookdetail(result);
				publishProgress(50);
				return list;
			}
		}

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			pb.setProgress(0);
		}

		@Override
		protected void onProgressUpdate(Integer... values) {
			// TODO Auto-generated method stub
			super.onProgressUpdate(values);
			pb.setProgress(values[0]);
		}

		@Override
		protected void onPostExecute(ArrayList<String> result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			if (result == null) {
				Toast toast = Toast.makeText(BookDetails.this, "Õ¯¬Á¡¨Ω” ß∞‹",
						Toast.LENGTH_SHORT);
				toast.show();
				publishProgress(100);
			} else {
//				TextView tv = (TextView) BookDetails.this
//						.findViewById(R.id.textview);
//				String s = "";
//				for(int i = 0; i < result.size(); i++){
//					s = s + result.get(i);
//					publishProgress(50+(i/(result.size()-1))*50);
//				}
//				tv.setText(s);
				for(int i = 0 ; i<result.size();i += 2){
					TableRow tablerow = new TableRow(BookDetails.this);
					TextView tv1 = new TextView(BookDetails.this);
					tv1.setTextColor(BookDetails.this.getResources().getColor(R.color.black));
					tv1.setText(result.get(i));
					tablerow.addView(tv1);
					TextView tv2 = new TextView(BookDetails.this);
					tv2.setTextColor(BookDetails.this.getResources().getColor(R.color.black));
					tv2.setText(result.get(i+1));
					tablerow.addView(tv2);
					tablelayout.addView(tablerow);
					publishProgress(50+(i/(result.size()-2))*50);
				}
				
			}
		}

	}
}
