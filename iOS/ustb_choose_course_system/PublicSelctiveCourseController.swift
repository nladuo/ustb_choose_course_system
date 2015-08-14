//
//  NoneNativeSelctiveClassController.swift
//  ustb_choose_course_system
//
//  Created by TheMoonBird on 15/8/14.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit
//公共选修课
class PublicSelctiveCourseController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let CELL_LABEL_TAG = 101
    var datas:[String:[String]] = [:]
    var parentVc:ChooseCourseTabBarController!

    override func loadView(){
        super.loadView()
        parentVc = self.tabBarController as ChooseCourseTabBarController
        tableView.delegate = self
        tableView.dataSource = self
        datas["可选课"] = ["微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407", "微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407"]
        datas["已选课"] = ["微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407", "微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407","微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407"]
        datas["已修课"] = ["微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407", "微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407", "微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407", "微机原理及接口技术B    [王睿](必修)   (1-10周)   逸夫楼407"]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.selected = false

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

        return 20;
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel(frame: CGRectMake(0, 0, 320, 22))
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        headerLabel.text = "  " + datas.keys.array[section]

        return headerLabel
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return datas.keys.array.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("publicCourseCell", forIndexPath: indexPath) as UITableViewCell
        var label = cell.viewWithTag(CELL_LABEL_TAG) as UILabel
        label.text = (datas[datas.keys.array[indexPath.section]]!)[indexPath.row]

        return cell

    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[datas.keys.array[section]]!.count
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
