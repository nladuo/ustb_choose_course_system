//
//  MainTableViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-11.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController{
    
    private var cookieData:String = ""
    
    private var loginAlertView:UIAlertView!
    
    
    private let LOGOUT_BTN_INDEX = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false

        var vc = self.navigationController as MainNavigationController
        //取出cookie
        cookieData = vc.cookieData
        
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
            
            //课表查询
            if indexPath.row == 2 {
                
                performSegueWithIdentifier("classTableSegue", sender: nil)
                
            }
        }
        
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    

    @IBAction func logoutBarItemClicked(sender: AnyObject) {
        var alert = UIAlertController(title: "是否要退出账户", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
    

}
