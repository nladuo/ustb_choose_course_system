//
//  AboutViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-29.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var wv: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //屏幕自适应
        wv.scalesPageToFit = true
        //加载URL
        let request = NSURLRequest(URL: NSURL(string: kalen.app.ConstVal.APP_WEBSITE_URL)!)
        wv.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
