//
//  NativeSelectiveController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15/8/14.
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
        parentVc.updateSpecifiedCourses(self, isPullToRefresh: false)
        
        //添加下拉刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //下拉刷新
    func refresh(refreshControl: UIRefreshControl) {
        parentVc.updateSpecifiedCourses(self, isPullToRefresh: true)
    }
    
    
    func afterParseDatas(isPullToRefresh: Bool) {
        datas = parentVc.specifiedClasses
        tableView.reloadData()
        if isPullToRefresh{
            //如果是下拉刷新的，重新刷新
            self.refreshControl!.endRefreshing()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let bean = datas[indexPath.row]
        
        
        MBProgressHUD.showMessage("加载中...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var url = ""
            if self.parentVc.chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
                url = kalen.app.ConstVal.getSpecifiedCourseUrl(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
            }else{
                url = kalen.app.ConstVal.getPreSpecifiedCourseUrl(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
            }
            let data = kalen.app.HttpUtil.get(url, cookieStr: self.parentVc.cookieData)
            
            dispatch_async(dispatch_get_main_queue(), {
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
                    self.performSegueWithIdentifier("SpecifiedShowDetail", sender: classes)
                }
            })
            
        })
        
        
        
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
