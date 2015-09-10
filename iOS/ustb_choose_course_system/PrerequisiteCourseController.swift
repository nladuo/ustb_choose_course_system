//
//  RequiredClassViewController.swift
//  ustb_choose_course_system
//
//  Created by TheMoonBird on 15/8/14.
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
    
    
    override func loadView(){
        super.loadView()
        
        parentVc = self.tabBarController as ChooseCourseTabBarController
        
        tableView.delegate = self
        tableView.dataSource = self
        parentVc.updatePrerequisiteCourses(self)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func afterParseDatas() {
        datas = parentVc.prerequisiteClasses
        tableView.reloadData()
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
        
        var bean = datas[indexPath.row]
        
        MBProgressHUD.showMessage("加载中...")
        var data = kalen.app.HttpUtil.get(kalen.app.ConstVal.getRequiredCourseURL(bean.kch, uid: kalen.app.UserInfo.getInstance().username), cookieStr: parentVc.cookieData)
        
        MBProgressHUD.hideHUD()
        if data == nil{
            MBProgressHUD.showError("网络连接错误")
            return
        }
        var parser = kalen.app.JsonParser(jsonStr: data!)
        var classes = parser.getAlternativeCourses()
        if classes.count == 0{
            MBProgressHUD.showError("本学期尚未开课")
        }else{
            performSegueWithIdentifier("PrerequisiteShowDetail", sender: classes)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PrerequisteCourseCell", forIndexPath: indexPath) as UITableViewCell
        
        var bean = datas[indexPath.row]
        var classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as UILabel
        var scoreLabel = cell.viewWithTag(SCORE_TAG) as UILabel
        
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
            
            var vc = segue.destinationViewController as DetailTableViewController
            vc.datas = (sender as [kalen.app.ClassBean])
            vc.cookieData = parentVc.cookieData
            vc.addUrl = kalen.app.ConstVal.ADD_PREREQUISITE_COURSE_URL
            vc.classType = "必修课"
            
        }
    }
    

}
