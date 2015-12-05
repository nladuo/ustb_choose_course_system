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
        
        //post课表URL
        static let FETCH_CLASS_TABLE_URL:String = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action"
        
        //移除课程URL
        static let REMOVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removeFormalNormalPublicSelectiveCourse.action"
        
        //添加公共选修课URL
        static let ADD_PUBLIC_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addFormalNormalPublicSelectiveCourse.action"
        
        //添加必修课URL
        static let ADD_PREREQUISITE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_addFormalNormalRequiredCourse.action"
        
        //添加专业选修课URL
        static let ADD_SPECIFIED_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_addFormalNormalMajorSelectiveCourse.action"
        
        static let APP_CHECK_UPDATE_URL = "http://vps.kalen25115.cn:3000/update?id=5"
        
        //当前软件版本
        static let VERSION:Double = 0.11
        
        //APP官网
        static let APP_WEBSITE_URL = "http://vps.kalen25115.cn:3000"
        
        //获取指定必修列表URL
        static func getRequiredCourseURL(kch: String, uid: String) -> String{
            return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalRequired_loadFormalNormalAccordByKchRequiredCourses.action?kch=\(kch)&_dc=1441796553804&limit=5000&start=0&uid=\(uid)"
        }
        
        //获取指定选修课URL
        static func getSpecifiedCourseUrl(kch: String, uid: String) -> String{
            return "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalMajorSelective_loadFormalNormalAccordByKchMajorSelectiveCourses.action?kch=\(kch)&_dc=1441814777297&limit=5000&start=0&uid=\(uid)"
        }
    }
}
