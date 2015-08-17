package kalen.app.ustb_choose_course_system.ui.choose_course;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import kalen.app.ustb_choose_course_system.R;

/**
 * Created by kalen on 15-8-16.
 */
public class PrerequsiteCourseFragment extends Fragment {
    View view;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        view = inflater.inflate(R.layout.fragment_prerequisite_course, null);

        return view;

    }
}
