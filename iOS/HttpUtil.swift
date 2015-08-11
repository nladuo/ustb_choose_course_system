//
//  httputil.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import Foundation

//通过异步来设置一个代理
extension kalen.app{
    
    class HttpUtil:NSObject, NSURLSessionTaskDelegate{
        
        var isError:Bool = false
        var cookieData:String = ""
        var _delegate:HttpDelegate?;
        
        init(delegate:HttpDelegate){
            self._delegate = delegate
        }

        /*
            get方法
            类方法
        */
        class func get(url:String, cookieStr:String)->NSString{
            var req:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url));
            req.addValue(cookieStr, forHTTPHeaderField: "Cookie")
            req.HTTPMethod = "GET"

            var data = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: nil)
            
            return NSString(data: data!, encoding: NSUTF8StringEncoding)
            
        }
        
        
        /*
            post方法
            类方法
        */
        class func post(url:String, params:Dictionary<NSString, NSString>, cookieStr:String)->NSString{
            var req = NSMutableURLRequest(URL: NSURL(string: url))
            req.addValue(cookieStr, forHTTPHeaderField: "Cookie")
            req.HTTPMethod = "POST"
            req.addValue(cookieStr, forHTTPHeaderField: "Cookie")
            var str:NSMutableString = NSMutableString(string: "")
            for (key,value) in params{
                if str.length != 0{
                    str.appendString("&")
                }
                str.appendString(key)
                str.appendString("=")
                str.appendString(value)
            }
            req.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
            var data = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: nil)
            return NSString(data: data!, encoding: NSUTF8StringEncoding)
        }
        
        /*
            处理重定向请求，直接使用nil来取消重定向请求
            Note：这个方法一定要写在postWithCookie的前面，如果写在后面页面还是会重定向
        */
        func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest!) -> Void) {
            completionHandler(nil)
        }
        
        /*
            post方法
            获取登陆cookie
            成员方法
        */
        func postWithCookie(url:String, params:Dictionary<NSString, NSString>){
            
            var req = NSMutableURLRequest(URL: NSURL(string: url))
            req.HTTPMethod = "POST"
            var str:NSMutableString = NSMutableString(string: "")
            for (key,value) in params{
                if str.length != 0{
                    str.appendString("&")
                }
                str.appendString(key)
                str.appendString("=")
                str.appendString(value)
            }
            req.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)

            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session:NSURLSession? = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            
            
            let task = session!.dataTaskWithRequest(req, completionHandler: { (data : NSData!, response : NSURLResponse!, error : NSError!) -> Void in
                if error == nil{
                    self.isError = false
                    //由于拦截了302，设置了completionHandler参数为nil，所以忽略了重定向请求，这里返回的Response就是包含302状态码的Response了。
                    if let resp = response as? NSHTTPURLResponse{
                        println(resp.statusCode)
                        for (key, val) in resp.allHeaderFields{
                            if(key as String) == "Set-Cookie"{
                                self.cookieData = val as String
                                println(self.cookieData)
                            }
                        }
                    }
                }else{
                    self.isError = true
                }
                
                //通知事件结束
                self._delegate?.afterPostWithCookie()
                
            })
            task.resume()
            
        }
    }
    
    
    
}