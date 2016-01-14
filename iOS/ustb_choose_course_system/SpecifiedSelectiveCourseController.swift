//
//  NativeSelectiveController.swift
//  ustb_choose_course_system
//
//  Created by TheMoonBird on 15/8/14.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit
//专业选修课
class SpecifiedSelectiveCourseController: UITableViewController, ChooseCourseDelegate {

    var datas:[kalen.app.ClassBean] = []
    let CLASSNAME_TAG = 501
    var parentVc:ChooseCourseTabBarController!
    
    
    override func loadView(){
        super.loadView()
        
        parentVc = self.tabBarController as! ChooseCourseTabBarController
        //代理请求网络
        parentVc.updateSpecifiedCourses(self)
        
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func afterParseDatas() {
        datas = parentVc.specifiedClasses
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let bean = datas[indexPath.row]
        
        MBProgressHUD.showMessage("加载中...")
        var url = ""
        if parentVc.chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
            url = kalen.app.ConstVal.getSpecifiedCourseUrl(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
        }else{
            url = kalen.app.ConstVal.getPreSpecifiedCourseUrl(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
        }
        let data = kalen.app.HttpUtil.get(url, cookieStr: parentVc.cookieData)
        
        MBProgressHUD.hideHUD()
        if data == nil{
            MBProgressHUD.showError("网络连接错误")
            return
        }
        let parser = kalen.app.JsonParser(jsonStr: data! as String)
        let classes = parser.getAlternativeCourses()
        if classes.count == 0{
            MBProgressHUD.showError("本学期尚未开课")
        }else{
            performSegueWithIdentifier("SpecifiedShowDetail", sender: classes)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SpecifiedCourseCell", forIndexPath: indexPath) as UITableViewCell
        
        let bean = datas[indexPath.row]
        let classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as! UILabel
        
        classNameLabel.text = bean.className

        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpecifiedShowDetail"{
            
            let vc = segue.destinationViewController as! DetailTableViewController
            vc.datas = (sender as! [kalen.app.ClassBean])
            vc.cookieData = parentVc.cookieData
            if parentVc.chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
                vc.addUrl = kalen.app.ConstVal.ADD_SPECIFIED_COURSE_URL
            }else{
                vc.addUrl = kalen.app.ConstVal.ADD_PRE_SPECIFIED_COURSE_URL
            }
            vc.classType = "专业选修课"
        }
    }

}
