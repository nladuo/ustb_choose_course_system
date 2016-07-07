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
        func getSelectedCourses() throws ->[ClassBean]{
            return try getCourses ("selectedCourses")
        }
        
        //可选课
        func getAlternativeCourses() throws->[ClassBean]{
            return try getCourses ("alternativeCourses")
        }
        
        //获取软件更新信息
        func getUpdateMsg() -> (version:Double, update_note:String)?{
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            
            if obj == nil{
                return nil
            }
            
            let version = obj!.objectForKey("version") as! Double
            let update_note = obj!.objectForKey("update_note") as! String
            
            return (version: version, update_note: update_note)
        }
        
        //获取选课结果
        func getMsg() -> String{
            var resultStr:String = ""
            
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            
            if obj == nil{
                return jsonStr.componentsSeparatedByString("g")[1].componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0].componentsSeparatedByString("\'")[1]
            }
            
            if let temp = obj!.objectForKey("msg") as? String{
                resultStr = temp
            }
            
            return resultStr
        }
        
        //必修课和专业选修课列表
        func getTechingCourses()throws -> [ClassBean]{
            var classes:[ClassBean] = []
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if obj == nil {
                print("解析getTechingCourses()错误")
                throw KBError.NotLogin
            }
            let array = obj.objectForKey("teachingPrograms") as! [AnyObject]
            for obj2 in array {
                let className = obj2.objectForKey("KCM") as! String
                let kch = obj2.objectForKey("KCH") as! String
                var score = ""
                if let scoreTemp = obj2.objectForKey("DYCCJ") as? String{
                    score = scoreTemp
                }
                classes.append(ClassBean(className: className, score: score, kch: kch))
                
            }
            return classes
        }
        
        
        //已选公选课
        func getLearnedPublicCourses() throws -> [ClassBean]{
            var classes:[ClassBean] = []
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if obj == nil {
                print("解析getLearnedPublicCourses()错误")
                throw KBError.NotLogin
            }
            let array = obj.objectForKey("learnedPublicCourses") as! [AnyObject]
            for obj2 in array {
                let className = obj2.objectForKey("DYKCM") as! String
                let teacher = obj2.objectForKey("LRR") as! String
                let credit = obj2.objectForKey("XF") as! String
                let score = obj2.objectForKey("GPACJ") as! String
                let semester = obj2.objectForKey("XNXQ") as! String
               
                classes.append(ClassBean(className: className, teacher: teacher, credit: credit, score: score, semester: semester))
                
            }
            return classes
        }
        
        //获取选课信息
        private func getCourses(type:String) throws ->[ClassBean]{
            
            var classes:[ClassBean] = []
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if obj == nil {
                print("解析getCourses(type: \(type))错误")
                throw KBError.NotLogin
            }
            let array : [AnyObject] = obj.objectForKey(type) as! [AnyObject]
            
            for obj2 in array {
                let id:Int = obj2.objectForKey("ID") as! Int
                let className = obj2.objectForKey("DYKCM") as! String
                let KXH = obj2.objectForKey("KXH") as! String
                let DYKCH = obj2.objectForKey("DYKCH") as! String
                
                let KRL = obj2.objectForKey("KRL") as! Int
                var ratio = ""
                //SKRS有可能是int也有可能是String
                if let temp = obj2.objectForKey("SKRS") as? Int{
                    //SKRS = temp
                    ratio = "\(temp)/\(KRL)"
                }else if let temp2 = obj2.objectForKey("SKRS") as? String{
                    ratio = "\(temp2)/\(KRL)"
                }else{
                    //如果都错就是当成0个人
                    ratio = "0/\(KRL)"
                }
                
                var tup:[AnyObject] = obj2.objectForKey("JSM")! as! [AnyObject]
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
                let credit = obj2.objectForKey("XF") as! String
                let time_and_position = obj2.objectForKey("SKSJDDSTR") as! String

                classes.append(ClassBean(id: "\(id)", className: className, teacher: teacher, time_and_position: time_and_position, credit: credit, ratio: ratio, KXH: KXH, DYKCH: DYKCH))
                
            }
            return classes
        }
        
        //获取课表
        func getClassTableItems() throws ->[ClassBean]{
            
            var classes:[ClassBean] = []
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if obj == nil {
                print("解析getClassTableItems()出错")
                throw KBError.NotLogin
            }
            
            let array = obj.objectForKey("selectedCourses") as! [AnyObject]

            for obj2 in array {
                //println(obj2)
                let className = obj2.objectForKey("DYKCM") as! String
                
                //获取第一个老师的姓名
                var tup:[AnyObject] = obj2.objectForKey("JSM")! as! [AnyObject]
                var teacher:String = ""
                if tup.count != 0 {
                    teacher = tup[0]["JSM"] as! String
                }else{
                    teacher = "未知老师"
                }

                let srcStr = obj2.objectForKey("SKSJDDSTR") as! String
                if srcStr == "" {
                    classes.append(ClassBean(_where: -1, className: className, teacher: teacher, time: "", position: ""))
                    continue;
                }
                
                //把每一种课的的不同时间地点的分为不同的课程， 将这些添加到classes里面
                for c in parseClassTable(srcStr, className: className, teacher: teacher) {
                    classes.append(c)
                }
                
                //添加配套课
                let array3:[AnyObject] = obj2.objectForKey("PTK") as! [AnyObject]

                for obj3 in array3 {
                    _ = obj3.objectForKey("DYKCM") as! String
                    //获取第一个老师的姓名
                    var array4 = obj3.objectForKey("JSM") as! [AnyObject]
                    var teacher = ""
                    if array4.count != 0{
                        teacher = array4[0].objectForKey("JSM") as! String
                    }else{
                        teacher = "未知老师"
                    }
                    
                    let srcStr = obj3.objectForKey("SKSJDDSTR") as! String
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
        func getSemester() throws ->String{
            let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let obj : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if obj == nil {
                print("解析getSemester()")
                throw KBError.NotLogin
            }
            
            var array = obj.objectForKey("selectedCourses") as! [AnyObject]
            
            return array[0].objectForKey("XNXQ") as! String
            
        }
        
        
        //提取课表信息
        private func parseClassTable(srcString: String, className: String, teacher: String) ->[ClassBean]{
            
            
            var classes:[ClassBean] = []
            let srcStr = srcString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            var datas:[String] = srcStr.characters.split {$0 == " "}.map { String($0) }
            
           // var datas:[String] = srcStr.characters.split {$0 == " "}.map { String($0) }
            
            var i = 0

            //println(teacher + "--> \(datas.count)")
            while i < datas.count {
                //上课地点
                let position:String = (datas[i + 1].characters.split {$0 == ")"}.map { String($0) } )[0]
//                //周几
//                var weekTime:Int = ((datas[i].split {$0 == ","})[0] as NSString).characterAtIndex(2) - 48
                //周几
                
                let weekTime:Int = Int((datas[i].componentsSeparatedByString(",")[0] as NSString).characterAtIndex(2)) - 48
                //第几节
                let whichNum:Int = Int((datas[i].componentsSeparatedByString(",")[1] as NSString).characterAtIndex(1)) - 48
                
                //摆放的位置
                let _where:Int = (weekTime - 1) * 6 + whichNum - 1;
                //上课时间
                let time = (datas[i] as NSString).substringFromIndex(8) as String
                
                classes.append(ClassBean(_where: _where, className: className, teacher: teacher, time: time, position: position))
                i += 2
            }
            
            return classes
        }

    }

}