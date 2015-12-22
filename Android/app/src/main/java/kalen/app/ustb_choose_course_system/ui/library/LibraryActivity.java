package kalen.app.ustb_choose_course_system.ui.library;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import java.util.ArrayList;
import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-11-24.
 */
public class LibraryActivity extends ListActivity{

    private EditText mBookEText;
    private int nowPage = 1;
    private ArrayList<String> mListItems;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_library);
        getActionBar().setDisplayHomeAsUpEnabled(true);
        mBookEText = (EditText) findViewById(R.id.library_book_et);
        findViewById(R.id.library_book_search_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String bookName = mBookEText.getText().toString();

            }
        });


    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch(item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

}
