//
//  MainTableViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-11.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UIAlertViewDelegate, HttpDelegate {
    
    private var cookieData:String = ""
    private var httpUtil:kalen.app.HttpUtil?
    private var loginAlertView:UIAlertView!
    var username:String = ""
    var password:String = ""
    
    
    private let LOGOUT_BTN_INDEX = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false

        var vc = self.navigationController as MainNavigationController
        
        self.username = vc.username
        self.password = vc.password
        //登陆操作
        //1.显示一个alertview
        loginAlertView = UIAlertView(title: "正在登陆...", message: nil, delegate: nil, cancelButtonTitle: nil)
        var aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        aiv.startAnimating()
        loginAlertView.addSubview(UIButton(frame: CGRectMake(100, 100, 100, 100)))
        loginAlertView.show()

        //2.开始登陆
        var params = ["j_username": username + ",undergraduate","j_password": password]
        httpUtil = kalen.app.HttpUtil(delegate: self)
        httpUtil!.postWithCookie(kalen.app.ConstVal.LOGIN_URL, params: params)
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 15
        }
        if section == 1{
            return 35
        }
        
        return 1000.0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 {
            //预选课 和 考试安排查询
            if (indexPath.row == 1) || (indexPath.row == 3){
                let alert = UIAlertView()
                alert.title = "提示"
                alert.message = "此功能会等到选课系统更新后添加"
                alert.addButtonWithTitle("确定")
                alert.show()
                
            }
        }
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    

    @IBAction func logoutBarItemClicked(sender: AnyObject) {
        var alertView = UIAlertView(title: "注意", message: "是否要退出账户", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == self.LOGOUT_BTN_INDEX {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func afterPostWithCookie() {
        println("in viewController")
        self.cookieData = httpUtil!.cookieData.componentsSeparatedByString(";")[0]
        var result:NSString = kalen.app.HttpUtil.get(kalen.app.ConstVal.CHECK_LOGIN_SUCCESS_URL, cookieStr: self.cookieData)
        println(result)


        dispatch_sync(dispatch_get_main_queue()) {
            // Your code
            self.loginAlertView.dismissWithClickedButtonIndex(0, animated: false)
            self.loginAlertView = nil
            //发生错误
            if result.length > 100 {
                let alert = UIAlertView(title: "登陆失败", message: "请检查用户名密码是否正确\n注：请尽可能不要输错密码，输错密码反应可能会很慢", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            }else{
                var alert2 = UIAlertView(title: "登陆成功", message: nil, delegate: nil, cancelButtonTitle: "确定")
                alert2.show()
                
            }

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "classTableSegue"{
            var vc = segue.destinationViewController as ClassTableViewController
            vc.cookieData = cookieData
        }else if segue.identifier == "chooseCourseSegue" {
            var vc = segue.destinationViewController as ChooseCourseTabBarController
            vc.cookieData = cookieData
        }
        
        
    }


    
    

    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
