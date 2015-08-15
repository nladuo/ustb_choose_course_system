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
        var _where:Int = 0
        var time:String = ""
        var position:String = ""
        var time_and_postion:String = ""
        var credit = ""
        var score = "0"
        
        //for search class
        init(id: String, className: String, teacher:String, time_and_position:String, credit:String){
            self.id = id
            self.className = className
            self.teacher = teacher
            self.time_and_postion = time_and_position
            self.credit = credit
        }
        
        //for learned class
        init(className: String, teacher:String, credit:String, score: String){
            self.className = className
            self.teacher = teacher
            self.credit = credit
            self.score = score
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