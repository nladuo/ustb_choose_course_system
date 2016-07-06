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
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.cloudsColor()
        self.navigationController?.navigationBar.configureFlatNavigationBarWithColor(UIColor.midnightBlueColor())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let barItem = UIBarButtonItem(title: "返回 ", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        barItem.configureFlatButtonWithColor(UIColor.peterRiverColor(), highlightedColor: UIColor.belizeHoleColor(), cornerRadius: 3)
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barItem
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
