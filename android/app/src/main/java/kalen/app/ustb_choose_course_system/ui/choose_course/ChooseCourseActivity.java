package kalen.app.ustb_choose_course_system.ui.choose_course;

import android.app.ActionBar;
import android.graphics.Color;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.PagerTabStrip;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-8-16.
 */
public class ChooseCourseActivity extends ActionBarActivity {


    private FragmentPagerAdapter mAdapter;
    private List<Fragment> mFragments;
    ViewPager pager = null;
    PagerTabStrip tabStrip = null;
    ArrayList<String> titleContainer = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_choose_course);
        initPager();
        initToolBar();
    }

    private void initToolBar() {
        Toolbar mToolbar = (Toolbar) findViewById(R.id.top_bar);
        TextView mToolBarTextView = (TextView) findViewById(R.id.top_bar_title);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        mToolbar.setNavigationIcon(R.mipmap.btn_back);
        mToolbar.setNavigationOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View view) {
                finish();
            }
        });
        mToolBarTextView.setText(R.string.app_name);
    }


    @Override
    public void onSaveInstanceState(Bundle outState, PersistableBundle outPersistentState) {
        //super.onSaveInstanceState(outState, outPersistentState);
    }

    private void initPager() {
        pager = (ViewPager) findViewById(R.id.choose_course_viewpager);
        tabStrip = (PagerTabStrip) findViewById(R.id.choose_course_tabstrip);
        tabStrip.setDrawFullUnderline(false);
        tabStrip.setTabIndicatorColor(Color.BLUE);
        tabStrip.setTextSpacing(200);

        titleContainer.add("必修课");
        titleContainer.add("专选课");
        titleContainer.add("公选课");

        mFragments = new ArrayList<>();
        Fragment mTab01 = new PrerequsiteCourseFragment();
        Fragment mTab02 = new SpecifiedSelectiveCourseFragment();
        Fragment mTab03 = new PublicSelctiveCourseFragment();
        mFragments.add(mTab01);
        mFragments.add(mTab02);
        mFragments.add(mTab03);

        mAdapter = new FragmentPagerAdapter(getSupportFragmentManager())
        {

            @Override
            public int getCount()
            {
                return mFragments.size();
            }

            @Override
            public Fragment getItem(int arg0)
            {
                return mFragments.get(arg0);
            }

            @Override
            public CharSequence getPageTitle(int position) {
                return titleContainer.get(position);
            }
        };
        pager.setAdapter(mAdapter);

    }
}
