//
//  HtmlParser.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 16/1/14.
//  Copyright © 2016年 kalen blue. All rights reserved.
//

import UIKit

extension kalen.app{
    class HtmlParser: NSObject {
        
        class func getInnovateCredits(html:String)->[InnovativeCredit]{
            var credits :[InnovativeCredit] = []
            let doc = try? HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
            var index = 0
            for tr in doc!.css("tbody, tr") {
                index += 1
                let tds = tr.css("td")
                var i = 0
                let credit = InnovativeCredit(credit: "", name: "", type: "")
                for td in tds{
                    td.stringValue
                    switch i{
                    case 1:credit.type = td.stringValue
                    case 2:credit.name = td.stringValue
                    case 3:credit.credit = td.stringValue
                    default: break
                    }
                    i += 1
                }
                print(index,credit.name)
                credits.append(credit)
            }
            credits.removeFirst()
            credits.removeFirst()
            return credits
        }
        
        class func getExamList(html:String)->[ExamInfo]{
            var list :[ExamInfo] = []
            let doc = try? HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
            for tr in doc!.css("tbody, tr") {
                let tds = tr.css("td")
                var i = 0
                let exam = ExamInfo(className: "", examTime: "", examLocation: "")
                for td in tds{
                    td.stringValue
                    switch i{
                    case 1:exam.className = td.stringValue
                    case 2:exam.examTime = td.stringValue
                    case 3:exam.examLocation = td.stringValue
                    default: break
                    }
                    i += 1
                }
                list.append(exam)
            }
            list.removeFirst()
            list.removeFirst()
            return list
        }
        
        
    }
}

