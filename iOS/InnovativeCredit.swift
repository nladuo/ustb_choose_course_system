//
//  InnovativeCredit.swift
//  ustb_choose_course_system
//
//  Created by 李鑫 on 16/1/14.
//  Copyright © 2016年 kalen blue. All rights reserved.
//

import UIKit

extension kalen.app{
    class InnovativeCredit: NSObject {
        
        var credit = ""
        var name = ""
        var type = ""
        
        init(credit: String, name: String, type: String){
            self.credit = credit
            self.name = name
            self.type = type
        }
        
    }
    
}
