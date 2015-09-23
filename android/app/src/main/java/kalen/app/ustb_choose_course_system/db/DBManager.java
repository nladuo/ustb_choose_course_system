package kalen.app.ustb_choose_course_system.db;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import java.util.ArrayList;
import java.util.List;
import kalen.app.ustb_choose_course_system.model.ClassTableBean;

public class DBManager {

	private DBHelper helper;     
	private SQLiteDatabase db;
	private static final String TAB_NAME = "class_table";
		
	public DBManager(Context context) {  
		helper = new DBHelper(context);  
		db = helper.getWritableDatabase();      
	}

	public void insertClassTableIfNotExist(ClassTableBean bean){
		if (!isClassTableExist(bean)){
            ContentValues values = new ContentValues();
            values.put("username", bean.getUsername());
            values.put("password", bean.getPassword());
            values.put("semester", bean.getSemester());
            values.put("meta_json_data", bean.getMeta_json_data());
            db.insert(TAB_NAME, null, values);
		}
	}

    /**
     *
     * @return
     */
    public List<ClassTableBean> getClassTables(){
        List<ClassTableBean> beans = new ArrayList<>();

        Cursor cursor = db.rawQuery("SELECT * FROM "
                + TAB_NAME,null);
        //遍历cursor
        while (cursor.moveToNext()) {
            int id = cursor.getInt(cursor.getColumnIndex("id"));
            String username = cursor.getString(cursor.getColumnIndex("username"));
            String password = cursor.getString(cursor.getColumnIndex("password"));
            String semester = cursor.getString(cursor.getColumnIndex("semester"));
            String meta_json_data = cursor.getString(cursor.getColumnIndex("meta_json_data"));
            beans.add(new ClassTableBean(id, username, password, semester, meta_json_data));
        }
        cursor.close();
        return beans;
    }

    /**
     *
     * @param bean
     * @return
     */
	private boolean isClassTableExist(ClassTableBean bean){

        for (ClassTableBean data : getClassTables()){
            if (data.getUsername().equals(bean.getUsername())
                    && data.getSemester().equals(bean.getSemester())
                    && data.getPassword().equals(bean.getPassword()) ){
                return true;
            }
        }

		return false;

	}

	/**
	 * 关闭数据库
	 */
	public void close(){
		helper.close();
		db.close();
	}


}
