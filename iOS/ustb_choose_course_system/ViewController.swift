//
//  ViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

//Login View Controller
class ViewController: UIViewController, HttpDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var httpUtil:kalen.app.HttpUtil?
    var cookieData:String?;
    var getClasstableController:GetClassViewController?
    
    let MAIN_CELL_LABEL = 1
    let DATA_RES = ["退补选课", "预选课", "课表查询", "考试安排查询", "关于本软件", "检查更新"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return DATA_RES.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("main_cell")
        var label = cell?.viewWithTag(MAIN_CELL_LABEL) as UILabel
        label.text = DATA_RES[indexPath.row]
        
        
        return cell as UITableViewCell
    }
    
    //section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            getClasstableController = GetClassViewController(cookie: cookieData! ,nibName: "GetClassViewController", bundle: nil)
                
            self.navigationController?.pushViewController(getClasstableController!, animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendBtnPressed(sender: AnyObject){
        var params = ["j_username":"41357009,undergraduate","j_password":"l82566258"]
        httpUtil = kalen.app.HttpUtil(delegate: self)
        httpUtil!.postWithCookie(kalen.app.ConstVal.LOGIN_URL, params: params)
    }
    
    func afterPostWithCookie() {
        println("in viewController")
        self.cookieData = httpUtil!.cookieData.componentsSeparatedByString(";")[0]
        var result:NSString = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_COURSE_URL + "41357009", cookieStr: self.cookieData!)
        
        println(result)
    }
    



}

