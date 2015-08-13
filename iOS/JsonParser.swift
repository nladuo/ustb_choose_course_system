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
        
        
        
        //获取课表
        func getClassTableItems() ->[ClassBean]{
            
            var classes:[ClassBean] = []
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("selectedCourses") as [AnyObject]

            for obj2 in array {
                //println(obj2)
                var className = obj2.objectForKey("DYKCM") as String
                //println(obj2)
                
                //获取第一个老师的姓名
                var (tup):(AnyObject) = obj2.objectForKey("JSM")!

                var teacher:String = tup[0]["JSM"] as String
                println( "teacher --->" + teacher)
                
                var srcStr = obj2.objectForKey("SKSJDDSTR") as String
                if srcStr == "" {
                    classes.append(ClassBean(_where: -1, className: className, teacher: teacher, time: "", position: ""))
                    continue;
                }
                
                //把每一种课的的不同时间地点的分为不同的课程， 将这些添加到classes里面
                for c in parseClassTable(srcStr, className: className, teacher: teacher) {
                    classes.append(c)
                    print("JsonParser ---->getCourseTable")
                    println(c.toString())

                }
                
//                //添加配套课
//                var tup2:[AnyObject] = obj2.objectForKey("PTK") as [AnyObject]
//
//                println("\n---------------------->>>")
//                println("\n---------------------->>>")
//                println(tup2.count)
//                println("\n<<----------------------")
//                println("\n<<----------------------")
                //for i in 1...
//                for obj3 in array3 {
//                    var ClassName = obj3.objectForKey("DYKCM") as String
//                    //获取第一个老师的姓名
//                    var array4 = obj3.objectForKey("JSM") as [AnyObject]
//                    var teacher:String = array4[0].objectForKey("JSM") as String
//                    
//                    var srcStr = obj3.objectForKey("SKSJDDSTR") as String
//                    if srcStr == "" {
//                        classes.append(ClassBean(_where: -1, className: className, teacher: teacher, time: "", position: ""))
//                        continue;
//                    }
//                    
//                    //把每一种课的的不同时间地点的分为不同的课程， 将这些添加到classes里面
//                    for c in parseClassTable(srcStr, className: className, teacher: teacher) {
//                        classes.append(c)
//                    }
//                    
//                }

            }
            println( "课程数目：---》\(classes.count)")
            return classes
        }
        
        //获取学期
        func getSemester() ->String{
            var data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var obj : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var array = obj.objectForKey("selectedCourses") as [AnyObject]
            
            return array[0].objectForKey("XNXQ") as String
            
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
                var deadline = obj2.objectForKey("TKJZRQ") as String
                var teacher = (obj2.objectForKey("JSM") as [AnyObject])[0].objectForKey("JSM") as String
                
                classes.append(ClassBean(id: String(id), className: className, teacher: teacher, deadline: deadline))
                
            }
            return [ClassBean()]
        }
        
        
        //提取课表信息
        private func parseClassTable(srcString: String, className: String, teacher: String) ->[ClassBean]{
            
            
            var classes:[ClassBean] = []
            var srcStr = srcString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            var datas:[String] = split(srcStr) {$0 == " "}
            var i = 0

            println(teacher + "--> \(datas.count)")
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