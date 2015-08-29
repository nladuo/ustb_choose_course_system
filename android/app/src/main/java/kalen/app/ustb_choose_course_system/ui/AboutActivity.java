package kalen.app.ustb_choose_course_system.ui;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import android.widget.Toast;

import kalen.app.ustb_choose_course_system.R;
import kalen.app.ustb_choose_course_system.model.ConstVal;

/**
 * Created by kalen on 15-8-28.
 */
public class AboutActivity extends ActionBarActivity{
    ProgressDialog dialog;
    WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
        initToolBar();

        webView = (WebView) findViewById(R.id.about_wview);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setSupportZoom(true);
        settings.setBuiltInZoomControls(true);
        settings.setUseWideViewPort(true);
        settings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN);
        settings.setLoadWithOverviewMode(true);
        webView.setWebChromeClient(new WebChromeClient() {
        });
        webView.setWebViewClient(new WebViewClient() {

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                dialog.dismiss();
            }
        });
        dialog = ProgressDialog.show(AboutActivity.this,
                null, "页面加载中，请稍后..");
        webView.loadUrl(ConstVal.APP_WEBSIT_URL);
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

}
