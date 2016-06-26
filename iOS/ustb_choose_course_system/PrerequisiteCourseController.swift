//
//  RequiredClassViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15/8/14.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit
//必修课
class PrerequisiteCourseController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseCourseDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var datas:[kalen.app.ClassBean] = []
    let CLASSNAME_TAG = 201
    let SCORE_TAG = 202
    var parentVc:ChooseCourseTabBarController!
    
    var refreshControl = UIRefreshControl()
    
    
    override func loadView(){
        super.loadView()
        
        parentVc = self.tabBarController as! ChooseCourseTabBarController
        
        //添加下拉刷新
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        parentVc.updatePrerequisiteCourses(self, isPullToRefresh: false)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //下拉刷新
    func refresh(refreshControl: UIRefreshControl) {
        parentVc.updatePrerequisiteCourses(self, isPullToRefresh: true)
    }
    
    func afterParseDatas(isPullToRefresh: Bool) {
        datas = parentVc.prerequisiteClasses
        tableView.reloadData()
        if isPullToRefresh{
            //如果是下拉刷新的，重新刷新
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        //判断已选课里面是否已经选过该课程
        for bean in parentVc.selectedClasses{
            if bean.DYKCH == datas[indexPath.row].kch {
                MBProgressHUD.showError("你已经选过此必修课!!")
                return
            }
        }
        
        let bean = datas[indexPath.row]
        MBProgressHUD.showMessage("加载中...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var url = ""
            if self.parentVc.chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
                url = kalen.app.ConstVal.getRequiredCourseURL(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
            }else{
                url = kalen.app.ConstVal.getPreRequiredCourseURL(bean.kch, uid: kalen.app.UserInfo.getInstance().username)
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
                    self.performSegueWithIdentifier("PrerequisiteShowDetail", sender: classes)
                }
            })
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PrerequisteCourseCell", forIndexPath: indexPath) as UITableViewCell
        
        let bean = datas[indexPath.row]
        let classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as! UILabel
        let scoreLabel = cell.viewWithTag(SCORE_TAG) as! UILabel
        
        classNameLabel.text = bean.className
        scoreLabel.text = bean.score
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PrerequisiteShowDetail"{
            
            let vc = segue.destinationViewController as! DetailTableViewController
            vc.datas = (sender as! [kalen.app.ClassBean])
            vc.cookieData = parentVc.cookieData
            if parentVc.chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
                vc.addUrl = kalen.app.ConstVal.ADD_PREREQUISITE_COURSE_URL
            }else{
                vc.addUrl = kalen.app.ConstVal.ADD_PRE_PREREQUISITE_COURSE_URL
            }
            vc.classType = "必修课"
        }
    }
    

}
