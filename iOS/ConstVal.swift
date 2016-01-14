//
//  const_val.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import Foundation

extension kalen.app{
    struct  ConstVal{
        
        static let PreChooseCourse = "预选课";
        static let AfterChooseCourse = "退补选课";
        //登陆URL
        static let LOGIN_URL:String = "http://elearning.ustb.edu.cn/choose_courses/j_spring_security_check"
        
        //验证登陆是否成功URL
        static let CHECK_LOGIN_SUCCESS_URL:String = "http://elearning.ustb.edu.cn/choose_courses/loginsucc.action"
        
        //获取退补选修课URL
        static let SEARCH_NOT_FULL_PUBLIC_COURSE_URL:String = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadFormalNormalNotFullPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1426047666276&limit=5000&start=0&uid=";
        
        //获取专选课列表URL
        static let SEARCH_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadFormalNormalMajorSelectiveCourseDisplay.action?_dc=1441806390326&limit=5000&start=0&uid="

        //获取公选课列表URL
        static let SEARCH_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalRequiredCoursesDisplay.action?_dc=1441789804883&limit=5000&start=0&uid="
        
        static let SEARCH_PRE_PUBLIC_SELECTIVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadPreNormalPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1452167956795&limit=5000&start=0&uid=";
        
        static let SEARCH_PRE_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadPreNormalRequiredCoursesDisplay.action?_dc=1452167835674&limit=5000&start=0&uid=";
        
        static let SEARCH_PRE_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadPreNormalMajorSelectiveCourseDisplay.action?_dc=1452167921622&limit=5000&start=0&uid=";
        
        //post课表URL
        static let FETCH_CLASS_TABLE_URL:String = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action"
        
        //移除课程URL
        static let REMOVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removeFormalNormalPublicSelectiveCourse.action"
        
        static let REMOVE_PRE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removePreNormalPublicSelectiveCourse.action";

        
        //添加公共选修课URL
        static let ADD_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addFormalNormalPublicSelectiveCourse.action"
        
        static let ADD_PRE_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addPreNormalPublicSelectiveCourse.action";

        
        //添加必修课URL
        static let ADD_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addFormalNormalRequiredCourse.action"
        
        static let ADD_PRE_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addPreNormalRequiredCourse.action";

        
        //添加专业选修课URL
        static let ADD_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addFormalNormalMajorSelectiveCourse.action"
        
        static let ADD_PRE_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addPreNormalMajorSelectiveCourse.action";

        
        static let INNOVITATE_CREDIT_URL = "http://elearning.ustb.edu.cn/choose_courses/information/singleStuInfo_singleStuInfo_loadSingleStuCxxfPage.action";

        
        static let EXAMLIST_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_examList_loadExamListPage.action";
        
        static let APP_CHECK_UPDATE_URL = "http://vps.kalen25115.cn:3000/update?id=5"
        
        //当前软件版本
        static let VERSION:Double = 1.02
        
        //APP官网
        static let APP_WEBSITE_URL = "http://vps.kalen25115.cn:3000"
        
        //获取指定必修列表URL
        static func getRequiredCourseURL(kch: String, uid: String) -> String{
            return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalAccordByKchRequiredCourses.action?kch=\(kch)&_dc=1441796553804&limit=5000&start=0&uid=\(uid)"
        }
        
        static func getPreRequiredCourseURL(kch:String, uid:String) -> String{
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadPreNormalAccordByKchRequiredCourses.action?kch=\(kch)&_dc=1441796553804&limit=5000&start=0&uid=\(uid)";
        }
        
        //获取指定选修课URL
        static func getSpecifiedCourseUrl(kch: String, uid: String) -> String{
            return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadFormalNormalAccordByKchMajorSelectiveCourses.action?kch=\(kch)&_dc=1441814777297&limit=5000&start=0&uid=\(uid)"
        }
        
        static func getPreSpecifiedCourseUrl(kch:String, uid:String) -> String{
        return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadPreNormalAccordByKchMajorSelectiveCourses.action?kch=\(kch)&_dc=1441814777297&limit=5000&start=0&uid=\(uid)";
        }
    }
}
