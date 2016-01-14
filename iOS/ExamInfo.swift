//
//  ExamInfo.swift
//  ustb_choose_course_system
//
//  Created by 李鑫 on 16/1/14.
//  Copyright © 2016年 kalen blue. All rights reserved.
//

import UIKit

extension kalen.app{
    class ExamInfo: NSObject {
        var className = ""
        var examTime = ""
        var examLocation = ""
        
        init(className: String, examTime: String, examLocation: String){
            self.className = className
            self.examTime = examTime
            self.examLocation = examLocation
        }
        
    }
}

