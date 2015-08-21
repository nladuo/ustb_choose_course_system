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
    var publicClasses:[kalen.app.ClassBean] = []
    //所有的专业选修课
    var specifiedClasses:[kalen.app.ClassBean] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNotFullPublicSelectiveCourses(_delegate:ChooseCourseDelegate){
        var data = kalen.app.HttpUtil.get(kalen.app.ConstVal.SEARCH_NOT_FULL_PUBLIC_COURSE_URL, cookieStr: cookieData)
        if data != nil{
            var parser = kalen.app.JsonParser(jsonStr: data!)
            notFullPublicClasses = parser.getAlternativeCourses()
            selectedClasses = parser.getSelectedCourses()
            learnedPublicClasses = parser.getLearnedPublicCourses()
        }else{
            notFullPublicClasses = []
            selectedClasses = []
            learnedPublicClasses = []
            MBProgressHUD.showError("网络连接错误")
        }
        
        
        
        _delegate.afterParseDatas()
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as ClassTableViewController
        vc.cookieData = cookieData

    }


}
