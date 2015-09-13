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
    var specifiedClasses:[kalen.app.ClassBean] = []
    
    //必修课列表
    var prerequisiteClasses:[kalen.app.ClassBean] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNotFullPublicSelectiveCourses(_delegate:ChooseCourseDelegate){
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var data = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL, cookieStr: self.cookieData)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if data != nil{
                    var parser = kalen.app.JsonParser(jsonStr: data! as String)
                    self.notFullPublicClasses = parser.getAlternativeCourses()
                    self.selectedClasses = parser.getSelectedCourses()
                    self.learnedPublicClasses = parser.getLearnedPublicCourses()
                }else{
                    self.notFullPublicClasses = []
                    self.selectedClasses = []
                    self.learnedPublicClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                
                _delegate.afterParseDatas()
            })
            
        })
        
        
    }
    
    func updatePrerequisiteCourses(_delegate: ChooseCourseDelegate){
        //var data
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var dataForSelectedCoureses = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL, cookieStr: self.cookieData)
            var dataForPrerequisiteCourses = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_PREREQUISITE_COURSE_URL, cookieStr: self.cookieData)
            
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if (dataForPrerequisiteCourses != nil) && (dataForSelectedCoureses != nil){
                    //必修课如果已经选择了的话，再向服务器post数据，服务器会抛出异常
                    var parser = kalen.app.JsonParser(jsonStr: dataForSelectedCoureses! as String)
                    self.selectedClasses = parser.getSelectedCourses()
                    
                    //添加必修课列表
                    //parser = nil
                    parser = kalen.app.JsonParser(jsonStr: dataForPrerequisiteCourses! as String)
                    self.prerequisiteClasses = parser.getTechingCourses()
                    
                }else{
                    self.prerequisiteClasses = []
                    self.selectedClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                _delegate.afterParseDatas()
                
            })
        })
        

    }
    
    func updateSpecifiedCourses(_delegate: ChooseCourseDelegate){
        //var data
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        
            var data = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_SPECIFIED_COURSE_URL, cookieStr: self.cookieData)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if data != nil{
                    var parser = kalen.app.JsonParser(jsonStr: data! as String)
                    self.specifiedClasses = parser.getTechingCourses()
                    
                }else{
                    self.specifiedClasses = []
                    MBProgressHUD.showError("网络连接错误")
                }
                
                _delegate.afterParseDatas()
            })
        })
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! ClassTableViewController
        vc.cookieData = cookieData

    }


}
