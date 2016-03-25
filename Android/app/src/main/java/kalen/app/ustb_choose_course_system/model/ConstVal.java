package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-8-11.
 */
public class ConstVal {

    public static final String PreChooseCourse = "预选课";
    public static final String AfterChooseCourse = "退补选课";

    public static final String LOGIN_URL = "http://elearning.ustb.edu.cn/choose_courses/j_spring_security_check";

    public static final String CHECK_LOGIN_SUCCESS_URL ="http://elearning.ustb.edu.cn/choose_courses/loginsucc.action";

    public static final String SEARCH_NOT_FULL_PUBLIC_SELECTIVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadFormalNormalNotFullPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1426047666276&limit=5000&start=0&uid=";

    public static final String SEARCH_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalRequiredCoursesDisplay.action?_dc=1441789804883&limit=5000&start=0&uid=";

    public static final String SEARCH_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadFormalNormalMajorSelectiveCourseDisplay.action?_dc=1441806390326&limit=5000&start=0&uid=";

    public static final String SEARCH_PRE_PUBLIC_SELECTIVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadPreNormalPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1452167956795&limit=5000&start=0&uid=";

    public static final String SEARCH_PRE_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadPreNormalRequiredCoursesDisplay.action?_dc=1452167835674&limit=5000&start=0&uid=";

    public static final String SEARCH_PRE_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadPreNormalMajorSelectiveCourseDisplay.action?_dc=1452167921622&limit=5000&start=0&uid=";

    public static final String FETCH_CLASS_TABLE_PAGE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action";

    public static final String REMOVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removeFormalNormalPublicSelectiveCourse.action";

    public static final String REMOVE_PRE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removePreNormalPublicSelectiveCourse.action";

    public static final String ADD_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addFormalNormalPublicSelectiveCourse.action";

    public static final String ADD_PRE_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addPreNormalPublicSelectiveCourse.action";

    public static final String ADD_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addFormalNormalRequiredCourse.action";

    public static final String ADD_PRE_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addPreNormalRequiredCourse.action";

    public static final String ADD_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addFormalNormalMajorSelectiveCourse.action";

    public static final String ADD_PRE_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addPreNormalMajorSelectiveCourse.action";

    public static final String INNOVITATE_CREDIT_URL = "http://elearning.ustb.edu.cn/choose_courses/information/singleStuInfo_singleStuInfo_loadSingleStuCxxfPage.action";

    public static final double VERSION = 1.10;

    public static final int APP_ID = 4;

    public static final String USER_SHARE_PREFERENCE = "user";

    public  static final String APP_WEBSIT_URL = "http://vps.kalen25115.cn:3000/";

    public static final String APP_UPDATE_CHECK_URL = "http://vps.kalen25115.cn:3000/update?id=" + APP_ID;

    public static final String APP_DOWNLOAD_URL = "http://vps.kalen25115.cn:3000/download?id=" + APP_ID;

    public static final String EXAMLIST_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_examList_loadExamListPage.action";

    public static String getRequiredCourseURL(String kch, String uid){
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalAccordByKchRequiredCourses.action?" +
                "kch=" + kch
                +"&_dc=1441796553804&limit=5000&start=0" +
                "&uid=" + uid;
    }

    public static String getPreRequiredCourseURL(String kch, String uid){
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadPreNormalAccordByKchRequiredCourses.action?" +
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

    public static String getPreSpecifiedCourseUrl(String kch, String uid){
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadPreNormalAccordByKchMajorSelectiveCourses.action?" +
                "kch="+ kch +
                "&_dc=1441814777297&limit=5000" +
                "&start=0&uid=" + uid;
    }



}
