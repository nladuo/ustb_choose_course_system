//
//  ViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

//Login View Controller
class LoginViewController: UIViewController, HttpDelegate{
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var cookieData = ""
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var saveProSwitch: UISwitch!
    private var httpUtil:kalen.app.HttpUtil?
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    /*
        根据switch来判断是否保存用户名密码
    */
    func savePro(){
        if(!saveProSwitch.selected){
            userDefaults.setObject(username.text, forKey: "username")
            userDefaults.setObject(password.text, forKey: "password")
            
        }else{
            userDefaults.setObject( "", forKey: "username")
            userDefaults.setObject( "", forKey: "password")
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        password.secureTextEntry = true
        loginBtn.layer.cornerRadius = 7.0   //添加圆角
        
        //取出用户名
        if let name:AnyObject = userDefaults.objectForKey("username"){
            username.text = name as String
        }
        //取出密码
        if let pass:AnyObject = userDefaults.objectForKey("password"){
            password.text = pass as String
        }
    }

    @IBAction func loginBtnClicked(sender: AnyObject) {
        var uname:NSString = username.text
        var passwd:NSString = password.text
        
        if uname == "" {
            MBProgressHUD.showError("请输入用户名")
        }else if passwd == "" {
            MBProgressHUD.showError("请输入密码")
        }else{
            MBProgressHUD.showMessage("正在登录中")
            var params = ["j_username": uname + ",undergraduate","j_password": passwd]
            httpUtil = kalen.app.HttpUtil(delegate: self)
            httpUtil?.postWithCookie(kalen.app.ConstVal.LOGIN_URL, params: params)
        }
        
    }
    
    func afterPostWithCookie() {
        println("in viewController")
        println("is Error --->\(httpUtil!.isError)")
        
        if httpUtil!.isError {
            //网络请求出现错误
            dispatch_sync(dispatch_get_main_queue()) {
                MBProgressHUD.hideHUD()
                MBProgressHUD.showError("网络错误")
            }
            
        }else{//联网正常
            
            self.cookieData = httpUtil!.cookieData.componentsSeparatedByString(";")[0]
            var result:NSString? = kalen.app.HttpUtil.get(kalen.app.ConstVal.CHECK_LOGIN_SUCCESS_URL, cookieStr: self.cookieData)
            
            
            dispatch_sync(dispatch_get_main_queue()) {
                MBProgressHUD.hideHUD()//隐藏蒙版
                if result != nil{
                    if result!.length > 100 {
                        MBProgressHUD.showError("用户名或密码错误")
                    }else{
                        MBProgressHUD.showSuccess("登陆成功")
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                }else{
                    MBProgressHUD.showError("网络连接错误")
                }
                
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue"{
            savePro() //是否保存用户名密码
            
            var vc = segue.destinationViewController as MainNavigationController
            vc.cookieData = cookieData

            var userInfo = kalen.app.UserInfo.getInstance()
            userInfo.username = username.text
            userInfo.password = password.text
        }
        
    }

}

