//
//  JsonParser.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-10.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import Foundation

extension kalen.app{
    
    class JsonParser{
        
        private var jsonStr:String
        
        init(jsonStr: String){
            self.jsonStr = jsonStr
        }
        
        //已选课
        func getSelectedCourses() ->[ClassBean]{
            
            return getCourses ("selectedCourses")
        }
        
        
        
        //可选课
        func getAlternativeCourses() ->[ClassBean]{
            
            return getCourses ("alternativeCourses")
        }
        
        //必修课和专业选修课列表
        func getTechingCourses()-> [ClassBean]{
            var classes:[ClassBean] = []
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("teachingPrograms") as [AnyObject]
            for obj2 in array {
                var className = obj2.objectForKey("KCM") as String
                var kch = obj2.objectForKey("KCH") as String
                var score = ""
                if let scoreTemp = obj2.objectForKey("DYCCJ") as? String{
                    score = scoreTemp
                }
                classes.append(ClassBean(className: className, score: score, kch: kch))
                
            }
            return classes
        }
        
        
        //已选公选课
        func getLearnedPublicCourses() -> [ClassBean]{
            var classes:[ClassBean] = []
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("learnedPublicCourses") as [AnyObject]
            for obj2 in array {
                var className = obj2.objectForKey("DYKCM") as String
                var teacher = obj2.objectForKey("LRR") as String
                var credit = obj2.objectForKey("XF") as String
                var score = obj2.objectForKey("GPACJ") as String
                var semester = obj2.objectForKey("XNXQ") as String
               
                classes.append(ClassBean(className: className, teacher: teacher, credit: credit, score: score, semester: semester))
                
            }
            return classes
        }
        
        //获取选课信息
        private func getCourses(type:String) ->[ClassBean]{
            
            var classes:[ClassBean] = []
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey(type) as [AnyObject]
            for obj2 in array {
                var id:Int = obj2.objectForKey("ID") as Int
                var className = obj2.objectForKey("DYKCM") as String
                var KXH = obj2.objectForKey("KXH") as String
                var DYKCH = obj2.objectForKey("DYKCH") as String
                var SKRS = 0
                if let temp = obj2.objectForKey("SKRS") as? Int{
                    SKRS = temp
                }
                
                var KRL = obj2.objectForKey("KRL") as Int
                
                var ratio = "\(SKRS)/\(KRL)"
                
                var tup:[AnyObject] = obj2.objectForKey("JSM")! as [AnyObject]
                var teacher:String = ""
                if tup.count != 0 {
                    if let temp = tup[0]["JSM"] as? String{
                        teacher = temp
                    }else{
                        teacher = "未知老师"
                    }
                }else{
                    teacher = "未知老师"
                }
                var credit = obj2.objectForKey("XF") as String
                var time_and_position = obj2.objectForKey("SKSJDDSTR") as String

                classes.append(ClassBean(id: "\(id)", className: className, teacher: teacher, time_and_position: time_and_position, credit: credit, ratio: ratio, KXH: KXH, DYKCH: DYKCH))
                
            }
            return classes
        }
        
        
        
        
        //获取课表
        func getClassTableItems() ->[ClassBean]{
            
            var classes:[ClassBean] = []
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("selectedCourses") as [AnyObject]

            for obj2 in array {
                //println(obj2)
                var className = obj2.objectForKey("DYKCM") as String
                
                //获取第一个老师的姓名
                var tup:[AnyObject] = obj2.objectForKey("JSM")! as [AnyObject]
                var teacher:String = ""
                if tup.count != 0 {
                    teacher = tup[0]["JSM"] as String
                }else{
                    teacher = "未知老师"
                }

                var srcStr = obj2.objectForKey("SKSJDDSTR") as String
                if srcStr == "" {
                    classes.append(ClassBean(_where: -1, className: className, teacher: teacher, time: "", position: ""))
                    continue;
                }
                
                //把每一种课的的不同时间地点的分为不同的课程， 将这些添加到classes里面
                for c in parseClassTable(srcStr, className: className, teacher: teacher) {
                    classes.append(c)
                }
                
                //添加配套课
                var array3:[AnyObject] = obj2.objectForKey("PTK") as [AnyObject]

                for obj3 in array3 {
                    var ClassName = obj3.objectForKey("DYKCM") as String
                    //获取第一个老师的姓名
                    var array4 = obj3.objectForKey("JSM") as [AnyObject]
                    var teacher = ""
                    if array4.count != 0{
                        teacher = array4[0].objectForKey("JSM") as String
                    }else{
                        teacher = "未知老师"
                    }
                    
                    var srcStr = obj3.objectForKey("SKSJDDSTR") as String
                    if srcStr == "" {
                        classes.append(ClassBean(_where: -1, className: className, teacher: teacher, time: "", position: ""))
                        continue;
                    }
                    
                    //把每一种课的的不同时间地点的分为不同的课程， 将这些添加到classes里面
                    for c in parseClassTable(srcStr, className: className, teacher: teacher) {
                        classes.append(c)
                    }
                    
                }

            }
            //println( "课程数目：---》\(classes.count)")
            return classes
        }
        
        //获取学期
        func getSemester() ->String{
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("selectedCourses") as [AnyObject]
            
            return array[0].objectForKey("XNXQ") as String
            
        }
        
        
        
        //提取课表信息
        private func parseClassTable(srcString: String, className: String, teacher: String) ->[ClassBean]{
            
            
            var classes:[ClassBean] = []
            var srcStr = srcString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            var datas:[String] = split(srcStr) {$0 == " "}
            var i = 0

            //println(teacher + "--> \(datas.count)")
            while i < datas.count {
                //上课地点
                var position:String = (split(datas[i + 1]) {$0 == ")"} )[0]
                //周几
                var weekTime:Int = ((split(datas[i]) {$0 == ","})[0] as NSString).characterAtIndex(2) - 48
                //第几节
                var whichNum:Int = ((split(datas[i]) {$0 == ","})[1] as NSString).characterAtIndex(1) - 48
                //摆放的位置
                var _where:Int = (weekTime - 1) * 6 + whichNum - 1;
                //上课时间
                var time = (datas[i] as NSString).substringFromIndex(8) as String
                
                classes.append(ClassBean(_where: _where, className: className, teacher: teacher, time: time, position: position))
                i += 2
            }
            
            return classes
        }

    }

}