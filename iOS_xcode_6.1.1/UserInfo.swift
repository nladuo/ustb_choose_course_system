//
//  userinfo.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import Foundation

let userInfo = kalen.app.UserInfo()

extension kalen.app{
    class UserInfo{
        var username:String = "";
        var password:String = "";
        
        class func getInstance() -> UserInfo{
            
            return userInfo
        }
        
        init(){
            
        }
        
    }
}
