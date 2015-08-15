//
//  NoneNativeSelctiveClassController.swift
//  ustb_choose_course_system
//
//  Created by TheMoonBird on 15/8/14.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit
//公共选修课
class PublicSelctiveCourseController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseCourseDelegate {

    @IBOutlet var tableView: UITableView!
    //显示课程名称
    let CLASSNAME_TAG = 101
    //侠士老师姓名
    let TEACHER_TAG = 102
    //显示学分
    let CREDIT_TAG = 103
    //显示课程上课地点或者显示得分
    let TIME_AND_POSITION_OR_SCORE_TAG = 104
    var datas:[[kalen.app.ClassBean]] = [[],[],[]]
    var sectionName:[String] = ["未满公选课", "已选课程", "已修公选课"]
    var parentVc:ChooseCourseTabBarController!

    override func loadView(){
        super.loadView()
        parentVc = self.tabBarController as ChooseCourseTabBarController
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        var bean = datas[indexPath.section][indexPath.row]
        
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
            if indexPath.section == 0 {
                otherBtnStr = "添加此课程"
            }else{
                otherBtnStr = "退选此课程"
            }
            alert = UIAlertView(title: "课程详情", message: message, delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: otherBtnStr)
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
        var cell = tableView.dequeueReusableCellWithIdentifier("publicCourseCell", forIndexPath: indexPath) as UITableViewCell
        
        
        var classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as UILabel
        var teacherLabel = cell.viewWithTag(TEACHER_TAG) as UILabel
        var creditLabel = cell.viewWithTag(CREDIT_TAG) as UILabel
        var timeAndPositionOrScoreLabel = cell.viewWithTag(TIME_AND_POSITION_OR_SCORE_TAG) as UILabel
        
        var bean = datas[indexPath.section][indexPath.row]
        
        classNameLabel.text = bean.className
        teacherLabel.text = bean.teacher
        creditLabel.text = bean.credit + "学分"
        if indexPath.section == 2 {
            timeAndPositionOrScoreLabel.text = "得分:" + bean.score
            timeAndPositionOrScoreLabel.textAlignment = NSTextAlignment.Center
        }else{
            timeAndPositionOrScoreLabel.text = bean.time_and_postion
        }

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
