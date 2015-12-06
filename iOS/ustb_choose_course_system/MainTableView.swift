//
//  MainTableView.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-10.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class MainTableView: UITableView, UITableViewDataSource, UITableViewDelegate{
    
    let MAIN_CELL_LABEL = 1
    let DATA_RES = ["退补选课", "预选课", "课表查询", "考试安排查询", "关于本软件", "检查更新"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
        self.scrollEnabled = false
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return DATA_RES.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("main_cell")
        var label = cell?.viewWithTag(MAIN_CELL_LABEL) as UILabel
        label.text = DATA_RES[indexPath.row]
        
        
        return cell as UITableViewCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            
        }
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
