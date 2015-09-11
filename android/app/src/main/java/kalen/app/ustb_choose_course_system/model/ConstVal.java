package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-8-11.
 */
public class ConstVal {
    public static final String LOGIN_URL = "http://elearning.ustb.edu.cn/choose_courses/j_spring_security_check";

    public static final String CHECK_LOGIN_SUCCESS_URL ="http://elearning.ustb.edu.cn/choose_courses/loginsucc.action";

    public static final String SEARCH_NOT_FULL_PUBLIC_SELECTIVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadFormalNormalNotFullPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1426047666276&limit=5000&start=0&uid=";

    public static final String SEARCH_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalRequiredCoursesDisplay.action?_dc=1441789804883&limit=5000&start=0&uid=";

    public static final String SEARCH_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadFormalNormalMajorSelectiveCourseDisplay.action?_dc=1441806390326&limit=5000&start=0&uid=";

    public static final String FETCH_CLASS_TABLE_PAGE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action";

    public static final String REMOVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removeFormalNormalPublicSelectiveCourse.action";

    public static final String ADD_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addFormalNormalPublicSelectiveCourse.action";

    public static final String ADD_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addFormalNormalRequiredCourse.action";

    public static final String ADD_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addFormalNormalMajorSelectiveCourse.action";

    public static final double VERSION = 0.11;

    public static final int APP_ID = 4;

    public static final String USER_SHARE_PREFERENCE = "user";

    public  static final String APP_WEBSIT_URL = "http://vps.kalen25115.cn:3000/";

    public static final String APP_UPDATE_CHECK_URL = "http://vps.kalen25115.cn:3000/update?id=" + APP_ID;

    public static final String APP_DOWNLOAD_URL = "http://vps.kalen25115.cn:3000/download?id=" + APP_ID;

    public static String getRequiredCourseURL(String kch, String uid){
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalAccordByKchRequiredCourses.action?" +
                "kch=" + kch
                +"&_dc=1441796553804&limit=5000&start=0" +
                "&uid=" + uid;
    }

    public static String getSpecifiedCourseUrl(String kch, String uid){
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/" +
                "normalChooseCourse_normalMajorSelective_loadFormalNormalAcc" +
                "ordByKchMajorSelectiveCourses.action?" +
                "kch="+ kch +
                "&_dc=1441814777297&limit=5000" +
                "&start=0&uid=" + uid;
    }

}
