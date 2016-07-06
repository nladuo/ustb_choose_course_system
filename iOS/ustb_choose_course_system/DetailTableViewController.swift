//
//  DetailTableViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-9-10.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UIAlertViewDelegate {
    
    
    //显示课程名称
    let CLASSNAME_TAG = 401
    
    //显示老师姓名
    let TEACHER_TAG = 402
    
    //显示学分
    let CREDIT_TAG = 403
    
    //显示人数比例
    let RATIO_TAG = 404
    
    //显示课程上课地点或者显示得分
    let TIME_AND_POSITION_TAG = 405
    
    var cookieData:String = ""
    
    var datas:[kalen.app.ClassBean] = []
    
    var selectedPos = -1
    
    var classType = ""
    
    var addUrl = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.cloudsColor()
        self.navigationController?.navigationBar.configureFlatNavigationBarWithColor(UIColor.midnightBlueColor())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let barItem = UIBarButtonItem(title: "返回 ", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        barItem.configureFlatButtonWithColor(UIColor.peterRiverColor(), highlightedColor: UIColor.belizeHoleColor(), cornerRadius: 3)
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barItem
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if buttonIndex == 1{
            
            let bean = datas[selectedPos]
            
            MBProgressHUD.showMessage("加载中...")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                //获取json数据
                let params = [
                    "id": bean.id,
                    "uid": kalen.app.UserInfo.getInstance().username,
                    "xkfs": self.classType,
                    "xf": bean.credit,
                    "NJ": "",
                    "ZYH": ""]
                let data = kalen.app.HttpUtil.post(self.addUrl, params: params, cookieStr: self.cookieData)
                
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUD()
                    if data == nil{
                        MBProgressHUD.showError("网络连接错误")
                        return
                    }
                    let parser = kalen.app.JsonParser(jsonStr: data! as String)
                    let msg = parser.getMsg()
                    let alert = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                })
                
            })
        }        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let bean = datas[indexPath.row]
        //设置当前选中课程的ID
        selectedPos = indexPath.row
        
        let message = "课程名称： " + bean.className
            + "\n老师： " + bean.teacher
            + "\n学分： " + bean.credit
            + "\n上课时间和地点： " + bean.time_and_postion
        let alert:UIAlertView = UIAlertView(title: "课程详情", message: message, delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "添加此课程")
        
        
        alert.show()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableCell", forIndexPath: indexPath) as UITableViewCell
        
        
        
        let classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as! UILabel
        let teacherLabel = cell.viewWithTag(TEACHER_TAG) as! UILabel
        let creditLabel = cell.viewWithTag(CREDIT_TAG) as! UILabel
        let ratioLabel = cell.viewWithTag(RATIO_TAG) as! UILabel
        let timeAndPositionLabel = cell.viewWithTag(TIME_AND_POSITION_TAG) as! UILabel
        
        
        let bean = datas[indexPath.row]
        
        classNameLabel.text = bean.className
        teacherLabel.text = bean.teacher
        creditLabel.text = bean.credit + "学分"
        ratioLabel.text = bean.ratio
        timeAndPositionLabel.text = bean.time_and_postion
        ratioLabel.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
