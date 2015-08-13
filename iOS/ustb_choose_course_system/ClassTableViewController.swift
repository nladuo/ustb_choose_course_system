//
//  ClassTableViewController.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-12.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

class ClassTableViewController: UIViewController{
    
    var cookieData:String = ""
    var jsonParser:kalen.app.JsonParser!
    
    
    private var CELL_HEIGHT:CGFloat = 0 //一个单元格最小的高度
    private let CELL_WIDTH:CGFloat = 100.0//一个单元格的宽度


    @IBOutlet var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var semester: UITextField!
    //存放所有的课名称的btn集合
    var classCollections:[[String]] = []
    var unkownClassItem:String = ""
    var labelCollections:[[UILabel]] = []
    var unkownClassLabel:UILabel!

    @IBAction func searchBtnClicked(sender: AnyObject) {
        //1、清楚课程String数组所有的内容
        clearStringsContent()
        //2、根据学期来把相应的内容放到数组里面
        manipulateClassStringCollections(semester.text)
        //3、更新UI，把数组里面所有的内容更新到UI中
        updateClassTableUI()

    }

    @IBAction func noteBarItemClicked(sender: AnyObject) {
        println("说明Clicked")
    }
    
    override func loadView() {
        super.loadView()
        CELL_HEIGHT = (UIScreen.mainScreen().bounds.size.height - topView.frame.size.height - 70.0) / 8.0
        scrollView.contentSize.width = 8 * CELL_WIDTH
        //scrollView.contentSize.height = UIScreen.mainScreen().bounds.size.height - topView.frame.size.height - 70.0
        searchBtn.layer.cornerRadius = 7.0   //添加圆角

        //添加所有标题的label
        addTitleLabels()

        //添加所有课程的label
        addClassContentLabels()

        //添加未知课程
        addUnkownClassLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dispatch_sync(dispatch_get_main_queue()) {
//            
//        }
        
        //1、先获取当前的学期
        var url = kalen.app.ConstVal.SEARCH_COURSE_URL + kalen.app.UserInfo.getInstance().username;
        
        var jsonStr = kalen.app.HttpUtil.get(url, cookieStr: self.cookieData)
        jsonParser = kalen.app.JsonParser(jsonStr: jsonStr)
        semester.text = jsonParser.getSemester()
        //2、初始化课程数组所有的内容
        assignStringsContent()
        //3、根据学期来把相应的内容放到数组里面
        manipulateClassStringCollections(semester.text)
        //4、更新UI，把数组里面所有的内容更新到UI中
        updateClassTableUI()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //根据学期来操作课程显示
    func manipulateClassStringCollections(semesterText:String){
        
        println("-------------------in manipulate--------------------")

        //获取json数据
        var params = ["listXnxq": semesterText,"uid": kalen.app.UserInfo.getInstance().username]
        var data = kalen.app.HttpUtil.post(kalen.app.ConstVal.FETCH_CLASS_TABLE_URL, params: params, cookieStr: cookieData)

        println(data)

        var parser = kalen.app.JsonParser(jsonStr: data)
        var beans:[kalen.app.ClassBean] = parser.getClassTableItems()

        println( " count --> \(beans.count)")

        for bean in beans{
            var _where = bean._where
            println("where -->\(_where)")
            if _where == -1 {
                var classInfo:String = bean.className
                    + "("
                    + (bean.teacher == "" ? bean.teacher : "未知老师")
                    + ")";
                if unkownClassItem != "" {
                    unkownClassItem = unkownClassItem + "  、"
                }

                println("class Info --->" + classInfo)
                unkownClassItem = unkownClassItem + classInfo
                continue
            }
            var classItemStr:String = bean.className
                    + "\n"
                    + bean.teacher
                    + "\n("
                    + bean.time
                    + "  "
                    + bean.position
                    + ")"
            var i = _where / 6
            var j = _where % 6
            if classCollections[i][j] == ""{
                classCollections[i][j] = classItemStr
            }else{
                classCollections[i][j] = classCollections[i][j] + "\n\n-------------------------\n\n" + classItemStr

            }
            println("classInfo-->" + classItemStr)
        }
    }

    //添加课表的表头
    func addTitleLabels(){
        var config:[String] = ["\\", "星期一",  "星期二",
            "星期三",  "星期四",
            "星期五", "星期六", "星期日", "第一节", "第二节",
            "第三节",  "第四节", "第五节",
            "第六节", "未知时间课程"]

        for i in 0...14{
            var xPoint: CGFloat = 0
            var yPoint: CGFloat = 0
            if i < 8 {
                xPoint = CGFloat(i) * CELL_WIDTH
                yPoint = -CELL_HEIGHT
            }else{
                xPoint = 0
                yPoint = CGFloat(i - 8) * CELL_HEIGHT
            }

            var label = UILabel(frame: CGRectMake(xPoint, yPoint, CELL_WIDTH, CELL_HEIGHT))
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "Helvetica", size: 12.0)
            label.text = config[i]
            label.layer.borderWidth = 0.3
            label.layer.borderColor = UIColor.blackColor().CGColor
            scrollView.addSubview(label)
        }
    }

    //添加课表的中间位置的Label
    func addClassContentLabels(){

        for i in 0...6{
            var labelCollection:[UILabel] = []
            for j in 0...5{
                var xPoint:CGFloat = CGFloat(i + 1) * CELL_WIDTH
                var yPoint:CGFloat = CGFloat(j) * CELL_HEIGHT
                var btn = UIButton(frame: CGRectMake(xPoint, yPoint, CELL_WIDTH, CELL_HEIGHT))


                var label = UILabel(frame: CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT))

                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont(name: "Helvetica", size: 10.0)
                label.text = ""
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                btn.layer.borderWidth = 0.3
                btn.layer.borderColor = UIColor.blackColor().CGColor

                btn.tag = i * 6 + j
                btn.addSubview(label)
                btn.addTarget(self, action: "classBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)


                //添加到集合中
                labelCollection.append(label)
                scrollView.addSubview(btn)
            }
            labelCollections.append(labelCollection)
        }

    }

    @IBAction func classBtnClicked(sender: UIButton){
        println(sender.tag)
        var i = sender.tag / 6
        var j = sender.tag % 6
        if classCollections[i][j] != "" {
            let alert = UIAlertView(title: nil, message: classCollections[i][j], delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
    }

    //添加未知课程的label
    func addUnkownClassLabel(){
        var btn = UIButton(frame: CGRectMake( CELL_WIDTH , 6 * CELL_HEIGHT, 7 * CELL_WIDTH, CELL_HEIGHT))
        btn.layer.borderWidth = 0.3
        btn.layer.borderColor = UIColor.blackColor().CGColor
        btn.tag = -1
        btn.addTarget(self, action: "classBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        

        unkownClassLabel = UILabel(frame: CGRectMake(0, 0, 7 * CELL_WIDTH, CELL_HEIGHT))
        unkownClassLabel.textAlignment = NSTextAlignment.Center
        unkownClassLabel.font = UIFont(name: "Helvetica", size: 10.0)
        unkownClassLabel.numberOfLines = 0
        unkownClassLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping

        scrollView.addSubview(btn)
    }
    
    //更新课表UI
    func updateClassTableUI(){
        for i in 0...6{
            for j in 0...5{
                labelCollections[i][j].text = classCollections[i][j]
            }
        }
        unkownClassLabel.text = unkownClassItem
    }
    
    //初始化课表内容数组
    func assignStringsContent(){
        for i in 0...6{
            var collection:[String] = []
            for i in 0...5{
                collection.append("")
            }
            classCollections.append(collection)
        }
        unkownClassItem = ""
    }

    //清除课表内容数组的内容
    func clearStringsContent(){
        for i in 0...6{
            for j in 0...5{
                classCollections[i][j] = ""
            }
        }
        unkownClassItem = ""
    }

//    //获取一行的label中，高度的那个
//    func getMaxHeightOfARow(row: Int) -> CGFloat{
//        var max_height:CGFloat = 0.0
//
//        for i in 0...7{
//            var height:CGFloat = (labelCollections[row][i] as UILabel).frame.size.height
//
//            if max_height < height{
//                max_height = height
//            }
//        }
//
//        return max_height
//    }
//
//    //获取当前应该添加
//    func getCurrentHeightByRow(row: Int) -> CGFloat{
//        var sum:CGFloat = 0.0
//        if row != 0{
//            for i in 0...(row - 1){
//                sum += getMaxHeightOfARow(i)
//            }
//
//        }
//        return sum
//
//    }




}
