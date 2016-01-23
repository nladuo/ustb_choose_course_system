//
//  ExamListController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 16/1/14.
//  Copyright © 2016年 kalen blue. All rights reserved.
//

import UIKit

class ExamListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let CLASSNAME_TAG       = 701
    let EXAM_TIME_TAG       = 702
    let EXAM_LOCATION_TAG   = 703
    
    var cookieData:String = ""
    var datas:[kalen.app.ExamInfo] = []
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var semesterTextFiled: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func loadView() {
        super.loadView()
        tableview.dataSource = self
        tableview.delegate = self
        searchBtn.layer.cornerRadius = 5.0   //添加圆角
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatas()
        // Do any additional setup after loading the view.
        //show waiting message
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            //1、先获取当前的学期
            let url = kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL + kalen.app.UserInfo.getInstance().username;
            
            let jsonStr = kalen.app.HttpUtil.get(url, cookieStr: self.cookieData)
            if jsonStr != nil{
                let jsonParser = kalen.app.JsonParser(jsonStr: jsonStr as! String)
                let semester = jsonParser.getSemester()
                let params = ["listXnxq": semester,"uid": kalen.app.UserInfo.getInstance().username]
                let html = kalen.app.HttpUtil.post(kalen.app.ConstVal.EXAMLIST_URL, params: params, cookieStr: self.cookieData)
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUD()
                    self.semesterTextFiled.text = semester
                    if html != nil{
                        for exam in kalen.app.HtmlParser.getExamList(html as! String){
                            self.datas.append(exam)
                        }
                        self.tableview.reloadData()
                    }else{
                        MBProgressHUD.showError("网络错误")
                    }
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUD()
                    self.semesterTextFiled.text = "无法获取当前学期"
                    MBProgressHUD.showError("网络错误")
                })
            }
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
            })
        })

    }
    func initDatas(){
        datas.removeAll()
        datas.append(kalen.app.ExamInfo(className: "课程名称", examTime: "考试时间", examLocation: "考试地点"))
    }

    @IBAction func refreshExamList(sender: AnyObject) {
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let params = ["listXnxq": self.semesterTextFiled.text!,"uid": kalen.app.UserInfo.getInstance().username]
            let html = kalen.app.HttpUtil.post(kalen.app.ConstVal.EXAMLIST_URL, params: params, cookieStr: self.cookieData)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if html != nil{
                    self.initDatas()
                    for exam in kalen.app.HtmlParser.getExamList(html as! String){
                        self.datas.append(exam)
                    }
                    self.tableview.reloadData()
                }else{
                    MBProgressHUD.showError("网络错误")
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("examListCell", forIndexPath: indexPath)
        
        let classNameLabel = cell.viewWithTag(CLASSNAME_TAG) as! UILabel
        classNameLabel.textAlignment = NSTextAlignment.Center
        classNameLabel.text = datas[indexPath.row].className
        let examTimeLabel = cell.viewWithTag(EXAM_TIME_TAG) as! UILabel
        examTimeLabel.textAlignment = NSTextAlignment.Center
        examTimeLabel.text = datas[indexPath.row].examTime
        let examLocationLabel = cell.viewWithTag(EXAM_LOCATION_TAG) as! UILabel
        examLocationLabel.textAlignment = NSTextAlignment.Center
        examLocationLabel.text = datas[indexPath.row].examLocation
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        semesterTextFiled.resignFirstResponder()
    }
    
}
