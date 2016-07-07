//
//  ChooseCourseTabBarController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-12.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class ChooseCourseTabBarController: UITabBarController {

    var cookieData:String = ""
    //已修公选课
    var learnedPublicClasses:[kalen.app.ClassBean] = []
    
    //已选课
    var selectedClasses:[kalen.app.ClassBean] = []
    
    //未满的公选课
    var notFullPublicClasses:[kalen.app.ClassBean] = []
    
    //所有的公选课
    //var publicClasses:[kalen.app.ClassBean] = []
    
    //专业选修课列表
    @IBOutlet weak var showClassTableBarItem: UIBarButtonItem!
    var specifiedClasses:[kalen.app.ClassBean] = []
    
    //必修课列表
    var prerequisiteClasses:[kalen.app.ClassBean] = []
    
    //上课类型
//    var chooseCourseType = kalen.app.ConstVal.AfterChooseCourse
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.cloudsColor()
        self.navigationController?.navigationBar.configureFlatNavigationBarWithColor(UIColor.midnightBlueColor())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        showClassTableBarItem.configureFlatButtonWithColor(UIColor.peterRiverColor(), highlightedColor: UIColor.belizeHoleColor(), cornerRadius: 3)
        showClassTableBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barItem = UIBarButtonItem(title: "返回 ", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        barItem.configureFlatButtonWithColor(UIColor.peterRiverColor(), highlightedColor: UIColor.belizeHoleColor(), cornerRadius: 3)
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNotFullPublicSelectiveCourses(_delegate:ChooseCourseDelegate, isPullToRefresh: Bool){
        print(kalen.app.UserInfo.getInstance().chooseCourseType)
        
        if !isPullToRefresh{
            MBProgressHUD.showMessage("加载中")
        }
        
        var url:String = ""
        if kalen.app.UserInfo.getInstance().chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
            url = kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL
        }else{
            url = kalen.app.ConstVal.SEARCH_PRE_PUBLIC_SELECTIVE_COURSE_URL
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let data = kalen.app.HttpUtil.get(url, cookieStr: self.cookieData)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if data != nil{
                    let parser = kalen.app.JsonParser(jsonStr: data! as String)
                    do{
                        self.notFullPublicClasses = try parser.getAlternativeCourses()
                        self.selectedClasses = try parser.getSelectedCourses()
                        self.learnedPublicClasses = try parser.getLearnedPublicCourses()
                    }catch{
                        MBProgressHUD.showError("您已经下线，请重新登录")
                    }
                    
                }else{
                    self.notFullPublicClasses = []
                    self.selectedClasses = []
                    self.learnedPublicClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                
                _delegate.afterParseDatas(isPullToRefresh)
            })
            
        })
        
        
    }
    
    func updatePrerequisiteCourses(_delegate: ChooseCourseDelegate, isPullToRefresh: Bool){
        print(kalen.app.UserInfo.getInstance().chooseCourseType)
        //var data
        if !isPullToRefresh{
            MBProgressHUD.showMessage("加载中")
        }
        
        var urlPrerequisite:String = ""
        var urlPublic:String = ""
        if kalen.app.UserInfo.getInstance().chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
            urlPrerequisite = kalen.app.ConstVal.SEARCH_PREREQUISITE_COURSE_URL
            urlPublic = kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL
        }else{
            urlPrerequisite = kalen.app.ConstVal.SEARCH_PRE_PREREQUISITE_COURSE_URL
            urlPublic = kalen.app.ConstVal.SEARCH_PRE_PUBLIC_SELECTIVE_COURSE_URL
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dataForSelectedCoureses = kalen.app.HttpUtil.get(urlPublic, cookieStr: self.cookieData)
            let dataForPrerequisiteCourses = kalen.app.HttpUtil.get(urlPrerequisite, cookieStr: self.cookieData)
            
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if (dataForPrerequisiteCourses != nil) && (dataForSelectedCoureses != nil){
                    
                    do{
                        //必修课如果已经选择了的话，再向服务器post数据，服务器会抛出异常
                        var parser = kalen.app.JsonParser(jsonStr: dataForSelectedCoureses! as String)
                        self.selectedClasses = try parser.getSelectedCourses()
                        //添加必修课列表
                        parser = kalen.app.JsonParser(jsonStr: dataForPrerequisiteCourses! as String)
                        self.prerequisiteClasses = try parser.getTechingCourses()
                    }catch{
                        MBProgressHUD.showError("您的账号已下线，请重新登录")
                    }
                    
                }else{
                    self.prerequisiteClasses = []
                    self.selectedClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                _delegate.afterParseDatas(isPullToRefresh)
                
            })
        })
        

    }
    
    func updateSpecifiedCourses(_delegate: ChooseCourseDelegate, isPullToRefresh: Bool){
        print(kalen.app.UserInfo.getInstance().chooseCourseType)
        //var data
        if !isPullToRefresh{
            MBProgressHUD.showMessage("加载中")
        }
        
        var url:String = ""
        if kalen.app.UserInfo.getInstance().chooseCourseType == kalen.app.ConstVal.AfterChooseCourse{
            url = kalen.app.ConstVal.SEARCH_SPECIFIED_COURSE_URL
        }else{
            url = kalen.app.ConstVal.SEARCH_PRE_SPECIFIED_COURSE_URL
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        
            let data = kalen.app.HttpUtil.get(url, cookieStr: self.cookieData)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if data != nil{
                    let parser = kalen.app.JsonParser(jsonStr: data! as String)
                    do{
                        self.specifiedClasses = try parser.getTechingCourses()
                    }catch{
                        MBProgressHUD.showError("您已经下线，请重新登录")
                    }
                }else{
                    self.specifiedClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                
                _delegate.afterParseDatas(isPullToRefresh)
            })
        })
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ClassTableViewController
        vc.cookieData = cookieData
    }

    
}
