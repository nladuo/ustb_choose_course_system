package kalen.app.ustb_choose_course_system.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DBHelper extends SQLiteOpenHelper {
	public static final String DB_NAME = "gre_app.db";
	
	/**
	 * 用作测试
	 * @param context
	 */
	public DBHelper(Context context){
		super(context, DB_NAME, null, 1);
	}
	
	public DBHelper(Context context,int version){
		super(context, DB_NAME, null, version);
	}

	/**
	 * 创建4个表
	 * 分别为：word，word_list,
	 * 			problem,problem_category
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub
		//创建class_table表
		db.execSQL("CREATE TABLE class_table("
				+ "id integer PRIMARY KEY AUTOINCREMENT,"
				+ "username varchar(30), "
				+ "password varchar(30),"
				+ "semester varchar(15),"
				+ "meta_json_data varchar(5000))");
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		
	}

}
