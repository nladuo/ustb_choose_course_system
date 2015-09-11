#ifndef CONST_URL_H
#define CONST_URL_H
#include<QtCore>
//URL
const QString LOGIN_URL = "http://elearning.ustb.edu.cn/choose_courses/j_spring_security_check";
const QString CHECK_LOGIN_SUCCESS_URL ="http://elearning.ustb.edu.cn/choose_courses/loginsucc.action";
const QString SEARCH_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_loadFormalNormalNotFullPublicSelectiveCourses.action?xqj=null&jc=null&kcm=&_dc=1426047666276&limit=5000&start=0&uid=";
const QString CLASS_TABLE_PAGE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadAllCourseListPage.action";
const QString ADD_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_addFormalNormalPublicSelectiveCourse.action";
const QString REMOVE_COURSE_URL = "http://elearning.ustb.edu.cn/choose_courses/choosecourse/normalChooseCourse_normalPublicSelective_removeFormalNormalPublicSelectiveCourse.action";
//software annoucement
const QString NOTE_MSG = "说明：\n本软件主要致力于退补选课，为了更迅速的刷选修课\n\n注意事项：\n1、请联网使用软件，否则会造成软件崩溃。\n2、登陆本软件后，请不要再次登陆网页版选课系统，以防止程序崩掉。";
const QString ABOUT_MSG = "软件名称：USTB选课系统<br>当前版本：0.11<br>作者：叁公子<br>软件“官网”：<a href=\"http://vps.kalen25115.cn:3000\">http://vps.kalen25115.cn:3000</a><br>作者博客：<a href=\"http://blog.kalen25115.cn\">http://blog.kalen25115.cn</a><br>说明：本软件为开源软件，仅供学习参考<br>源码地址：<a href=\"https://github.com/nladuo/ustb_choose_course_system\">https://github.com/nladuo/ustb_choose_course_system</a>";
const double VERSION = 0.12;
//software id  (window -> 1, ubuntu 64 -> 2, mac -> 3, android -> 4, iOS -> 5)
const QString UPDATE_URL ="http://vps.kalen25115.cn:3000/update?id=2";
const QString DOWNLOAD_URL = "http://vps.kalen25115.cn:3000/download?id=2";

#endif // CONST_URL_H
