//
//  ClassBean.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-12.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//
import Foundation

extension kalen.app{
    class ClassBean{
        
        var id:String = ""
        var className:String = ""
        var teacher:String = ""
        var deadline:String = ""
        var _where:Int = 0
        var time:String = ""
        var position:String = ""
        
        //for search class
        init(id: String, className: String, teacher:String, deadline:String){
            self.id = id
            self.className = className
            self.teacher = teacher
            self.deadline = deadline
        }
        
        //for get class table
        init(_where: Int, className: String, teacher: String, time: String, position: String){
            self._where = _where
            self.className = className
            self.teacher = teacher
            self.time = time
            self.position = position
        }

        func toString() ->String {
            return className + "--->\(_where)--->" + time + "--->" + position
        }

        
        init(){
            
        }
        
    }
}