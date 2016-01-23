//
//  InnovativeCreditController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 16/1/14.
//  Copyright © 2016年 kalen blue. All rights reserved.
//

import UIKit

class InnovativeCreditController: UITableViewController {

    let TYPE_TAG    = 601
    let NAME_TAG    = 602
    let CREDIT_TAG  = 603
    var cookieData:String = ""
    
    var datas:[kalen.app.InnovativeCredit] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        datas.append(kalen.app.InnovativeCredit(credit: "学分", name: "名称", type: "类型"))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show waiting message
        MBProgressHUD.showMessage("加载中")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            let html = kalen.app.HttpUtil.get(kalen.app.ConstVal.INNOVITATE_CREDIT_URL, cookieStr: self.cookieData)

            
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUD()
                if html != nil{
                    for credit in kalen.app.HtmlParser.getInnovateCredits(html as! String){
                        self.datas.append(credit)
                    }
                    self.tableView.reloadData()
                }else{
                    MBProgressHUD.showError("网络错误")
                }
            })
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("innovativeCell", forIndexPath: indexPath)

        let typeLabel = cell.viewWithTag(TYPE_TAG) as! UILabel
        typeLabel.textAlignment = NSTextAlignment.Center
        typeLabel.text = datas[indexPath.row].type
        let nameLabel = cell.viewWithTag(NAME_TAG) as! UILabel
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = datas[indexPath.row].name
        let creditLabel = cell.viewWithTag(CREDIT_TAG) as! UILabel
        creditLabel.textAlignment = NSTextAlignment.Center
        creditLabel.text = datas[indexPath.row].credit
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }


}
