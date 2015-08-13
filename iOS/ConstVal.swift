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
        static let SEARCH_COURSE_URL:String = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadFormalNormalNotFullPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1426047666276&limit=5000&start=0&uid=";
        //post课表URL
        static let FETCH_CLASS_TABLE_URL:String = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action"
        
        //当前软件版本
        static let VERSION:Double = 1.00
    }
}
