//
//  NoneNativeSelctiveClassController.swift
//  ustb_choose_course_system
//
//  Created by TheMoonBird on 15/8/14.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit
//公共选修课
class PublicSelctiveCourseController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseCourseDelegate, UIAlertViewDelegate {

    @IBOutlet var tableView: UITableView!
    //显示课程名称
    let CLASSNAME_TAG = 101
    
    //显示老师姓名
    let TEACHER_TAG = 102
    
    //显示学分
    let CREDIT_TAG = 103
    
    //显示人数比例
    let RATIO_OR_SCORE_TAG = 104
    
    //显示课程上课地点或者显示得分
    let TIME_AND_POSITION_OR_SEMESTER_TAG = 105
    
    //选课的tag
    let ALTERNATIVE_COURSE_TAG = 0
    
    //退课的tag
    let SELECTED_COURSE_TAG = 1
    
    //当前选中的课程ID
    var selectedId = ""
    
    var datas:[[kalen.app.ClassBean]] = [[],[],[]]
    
    var sectionName:[String] = ["未满公选课", "已选课程", "已修公选课"]
    
    var parentVc:ChooseCourseTabBarController!

    override func loadView(){
        super.loadView()
        
        parentVc = self.tabBarController as!
        ChooseCourseTabBarController
        tableView.delegate = self
        tableView.dataSource = self
        parentVc.updateNotFullPublicSelectiveCourses(self)
    }
    
    func afterParseDatas() {
        datas[0] = parentVc.notFullPublicClasses
        datas[1] = parentVc.selectedClasses
        datas[2] = parentVc.learnedPublicClasses
        tableView.reloadData()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){

        if buttonIndex == 1{
        
            if alertView.tag == 0{
                
                MBProgressHUD.showMessage("加载中..")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    //获取json数据
                    var params = ["id": self.selectedId,"uid": kalen.app.UserInfo.getInstance().username]
                    var data = kalen.app.HttpUtil.post(kalen.app.ConstVal.ADD_PUBLIC_COURSE_URL, params: params, cookieStr: self.parentVc.cookieData)
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUD()
                        if data == nil{
                            MBProgressHUD.showError("网络连接错误")
                            return
                        }
                        var parser = kalen.app.JsonParser(jsonStr: data as String!)
                        var msg = parser.getMsg()
                        var alert = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        
                        self.parentVc.updateNotFullPublicSelectiveCourses(self)
                        
                        println("添加选修课")
                    })
                })
                
            }else if alertView.tag == 1{
                var bean = findCourseBeanByCourseID(selectedId, beans: datas[1])
                
                var alert = UIAlertView(title: "课程详情", message: "你确定要退掉：\(bean.className)吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.tag = 2
                alert.show()
                
                println("退补选修课")
                
            }else if alertView.tag == 2{
                var bean = findCourseBeanByCourseID(selectedId, beans: datas[1])
                
                MBProgressHUD.showMessage("加载中..")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    //获取json数据
                    var params = [
                        "kch": bean.DYKCH,
                        "xh": "",
                        "kxh": bean.KXH,
                        "uid": kalen.app.UserInfo.getInstance().username]
                    var data = kalen.app.HttpUtil.post(kalen.app.ConstVal.REMOVE_COURSE_URL, params: params, cookieStr: self.parentVc.cookieData)
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUD()
                        if data == nil{
                            MBProgressHUD.showError("网络连接错误")
                            return
                        }
                        var parser = kalen.app.JsonParser(jsonStr: data! as String)
                        var msg = parser.getMsg()
                        var alert = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        
                        self.parentVc.updateNotFullPublicSelectiveCourses(self)
                    })
                    
                })
                println("确定退选修课")
            }
            
        }
        
    }
    
    func findCourseBeanByCourseID(id: String, beans: [kalen.app.ClassBean]) -> kalen.app.ClassBean{
        
        var bean:kalen.app.ClassBean!
        for b in beans{
            if b.id == id{
                bean = b
                break
            }
        }
        
        return bean
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        var bean = datas[indexPath.section][indexPath.row]
        //设置当前选中课程的ID
        selectedId = bean.id
        
        var message = "课程名称： " + bean.className
                    + "\n老师： " + bean.teacher
                    + "\n学分： " + bean.credit
        var alert:UIAlertView!
        if indexPath.section == 2 {
            message += "\n得分： " + bean.score
            alert = UIAlertView(title: "课程详情", message: message, delegate: nil, cancelButtonTitle: "确定")

            
        }else{
            message += "\n上课时间和地点： " + bean.time_and_postion
            var otherBtnStr = ""
            var tag = 0
            if indexPath.section == 0 {
                otherBtnStr = "添加此课程"
                tag = 0
            }else{
                otherBtnStr = "退选此课程"
                tag = 1
            }
            alert = UIAlertView(title: "课程详情", message: message, delegate: self, cancelButtonTitle: "确定", otherButtonTitles: otherBtnStr)
            //alert.tag = bean.id
            alert.tag = tag
        }

        
        alert.show()

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

        return 20;
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel(frame: CGRectMake(0, 0, 320, 22))
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        headerLabel.text = "  " + sectionName[section]

        return headerLabel
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return sectionName.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("publicCourseCell", forIndexPath: indexPath) as! UITableViewCell
        
        
        var classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as! UILabel
        var teacherLabel = cell.viewWithTag(TEACHER_TAG) as! UILabel
        var creditLabel = cell.viewWithTag(CREDIT_TAG) as! UILabel
        var ratioOrScoreLabel = cell.viewWithTag(RATIO_OR_SCORE_TAG) as! UILabel
        var timeAndPositionOrSemesterLabel = cell.viewWithTag(TIME_AND_POSITION_OR_SEMESTER_TAG) as! UILabel
        
        
        var bean = datas[indexPath.section][indexPath.row]
        
        classNameLabel.text = bean.className
        teacherLabel.text = bean.teacher
        creditLabel.text = bean.credit + "学分"
        if indexPath.section == 2 {
            ratioOrScoreLabel.text = "得分:" + bean.score

            timeAndPositionOrSemesterLabel.text = bean.semester
            timeAndPositionOrSemesterLabel.textAlignment = NSTextAlignment.Center
        }else{
            ratioOrScoreLabel.text = bean.ratio
            timeAndPositionOrSemesterLabel.text = bean.time_and_postion
        }
        
        ratioOrScoreLabel.textAlignment = NSTextAlignment.Center

        return cell

    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].count
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
