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
    
    @IBOutlet weak var username: FUITextField!
    @IBOutlet weak var password: FUITextField!
    @IBOutlet weak var saveProSwitch: UISwitch!
    private var httpUtil:kalen.app.HttpUtil?
    
    @IBOutlet weak var loginBtn: FUIButton!
    @IBOutlet weak var localClassTableBarItem: UIBarButtonItem!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func saveProSwitchToggled(sender: AnyObject) {
        print("switch :\(saveProSwitch.on)")
        if(!saveProSwitch.on){
            userDefaults.setObject( "", forKey: "username")
            userDefaults.setObject( "", forKey: "password")
        }
        userDefaults.setBool(saveProSwitch.on, forKey: "isOn")
    }
    
    /*
        根据switch来判断是否保存用户名密码
    */
    func savePro(){
        if(saveProSwitch.on){
            userDefaults.setObject(username.text, forKey: "username")
            userDefaults.setObject(password.text, forKey: "password")
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    override func loadView() {
        super.loadView()
        print(UIColor.turquoiseColor())
        //navigationbar
        self.view.backgroundColor = UIColor.cloudsColor()
        self.navigationController?.navigationBar.configureFlatNavigationBarWithColor(UIColor.midnightBlueColor())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        username.layer.borderColor = UIColor.turquoiseColor().CGColor
        password.layer.borderColor = UIColor.turquoiseColor().CGColor
        
        localClassTableBarItem.configureFlatButtonWithColor(UIColor.peterRiverColor(), highlightedColor: UIColor.belizeHoleColor(), cornerRadius: 3)
        localClassTableBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
  
        loginBtn.backgroundColor = UIColor.turquoiseColor()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread.sleepForTimeInterval(2.0)
        
        password.secureTextEntry = true
        loginBtn.layer.cornerRadius = 7.0   //添加圆角
        
        //取出用户名
        if let name:AnyObject = userDefaults.objectForKey("username"){
            username.text = name as? String
        }
        //取出密码
        if let pass:AnyObject = userDefaults.objectForKey("password"){
            password.text = pass as? String
        }
        
        //取出UISwitch是否选中
        if let isOn:Bool = userDefaults.boolForKey("isOn"){
            saveProSwitch.setOn(isOn, animated: false)
        }else{
            saveProSwitch.setOn(true, animated: false)
        }
        
    }
    
    @IBAction func localClassTableBtnClicked(sender: AnyObject) {
        
        var cList:[String] = []
        var tempStr:String = ""
        if let class_list:AnyObject = userDefaults.objectForKey("class_list"){
            tempStr = class_list as! String
            cList = tempStr.componentsSeparatedByString("\n")
        }
        
        if (cList.count == 0) || (tempStr == ""){
            let alert = UIAlertView(title: "提示", message: "你还没有添加本地课表，请登陆后添加", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        self.performSegueWithIdentifier("localClassTableSegue", sender: cList)
        
    }

    @IBAction func loginBtnClicked(sender: AnyObject) {
        let uname:NSString = username.text!
        let passwd:NSString = password.text!
        
        if uname == "" {
            MBProgressHUD.showError("请输入用户名")
        }else if passwd == "" {
            MBProgressHUD.showError("请输入密码")
        }else{
            MBProgressHUD.showMessage("正在登录中")
            let params = ["j_username": (uname as String) + ",undergraduate","j_password": passwd]
            httpUtil = kalen.app.HttpUtil(delegate: self)
            httpUtil?.postWithCookie(kalen.app.ConstVal.LOGIN_URL, params: params)
        }
        
    }
    
    func afterPostWithCookie() {
        //println("in viewController")
        //println("is Error --->\(httpUtil!.isError)")
        
        if httpUtil!.isError {
            //网络请求出现错误
            dispatch_sync(dispatch_get_main_queue()) {
                MBProgressHUD.hideHUD()
                MBProgressHUD.showError("网络错误")
            }
            
        }else{//联网正常
            
            self.cookieData = httpUtil!.cookieData.componentsSeparatedByString(";")[0]
            let result:NSString? = kalen.app.HttpUtil.get(kalen.app.ConstVal.CHECK_LOGIN_SUCCESS_URL, cookieStr: self.cookieData)
            
            
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
            
            let vc = segue.destinationViewController as! MainNavigationController
            vc.cookieData = cookieData

            let userInfo = kalen.app.UserInfo.getInstance()
            userInfo.username = username.text!
            userInfo.password = password.text!
        }else if segue.identifier == "localClassTableSegue"{
            let vc = segue.destinationViewController as! LocalClassTableViewController
            let list = sender as! [String]
            vc.cList = []
            for str in list{
                if str != ""{
                    vc.cList.append(str)
                }
            }
        }
        
    }

}

