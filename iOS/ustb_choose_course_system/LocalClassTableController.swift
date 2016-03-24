//
//  File.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-11-15.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//


import UIKit

class LocalClassTableViewController: UIViewController{
    
    var jsonParser:kalen.app.JsonParser!
    var cList:[String] = []
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private var CELL_HEIGHT:CGFloat = 0 //一个单元格最小的高度
    private let CELL_WIDTH:CGFloat = 100.0//一个单元格的宽
    
  //  @IBOutlet var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    //存放所有的课名称的btn集合
    var classCollections:[[String]] = []
    var unkownClassItem:String = ""
    var labelCollections:[[UILabel]] = []
    var tagImgCollections:[[UIImageView]] = []
    var unkownClassLabel:UILabel!
    
    override func loadView() {
        super.loadView()
        print("loadView", self.navigationController)
        //20为显示时间、运营商等等的高度，3为bottomMargin
        CELL_HEIGHT = (UIScreen.mainScreen().bounds.size.height - self.navigationController!.navigationBar.frame.size.height - 20 - 3
                ) / CGFloat(8.0)
        //CELL_HEIGHT = 100
        scrollView.contentSize.width = 8 * CELL_WIDTH

        //添加所有标题的label
        addTitleLabels()
        //添加所有课程的label
        addClassContentLabels()
        //添加未知课程
        addUnkownClassLabel()
        //初始化课表img标签
        initTagImageCollections()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDIDLoad", self.navigationController)
        
        jsonParser = kalen.app.JsonParser(jsonStr: userDefaults.objectForKey(cList[0]) as! String)
        //2、初始化课程数组所有的内容
        assignStringsContent()
        //3、把字符分解开放到collection里面
        manipulateClassStringCollections()
        //4、更新UI，把数组里面所有的内容更新到UI中
        updateClassTableUI()
        
    }
    
    @IBAction func lookUpOtherClassTableBtnClicked(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        for c in cList{
            alert.addAction(UIAlertAction(title: c, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                let jsonStr: String = self.userDefaults.objectForKey(c) as! String
                self.jsonParser = kalen.app.JsonParser(jsonStr: jsonStr)
                //print(jsonStr)
                //print(c)
                self.clearStringsContent()
                //2、初始化课程数组所有的内容
                self.assignStringsContent()
                //3、把字符分解开放到collection里面
                self.manipulateClassStringCollections()
                //4、更新UI，把数组里面所有的内容更新到UI中
                self.updateClassTableUI()
                
            }))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //根据学期来操作课程显示
    func manipulateClassStringCollections(){
        
        let beans:[kalen.app.ClassBean] = self.jsonParser.getClassTableItems()
        
        for bean in beans{
            let _where = bean._where
            //未知时间课程
            if _where == -1 {
                let classInfo:String = bean.className
                    + "("
                    + (bean.teacher == "" ? bean.teacher : "未知老师")
                    + ")";
                if unkownClassItem != "" {
                    unkownClassItem = unkownClassItem + "  、"
                }
                
                unkownClassItem = unkownClassItem + classInfo
                continue
            }
            let classItemStr:String = bean.className
                + "\n"
                + bean.teacher
                + "\n("
                + bean.time
                + "  "
                + bean.position
                + ")"
            let i = _where / 6
            let j = _where % 6
            if classCollections[i][j] == ""{
                classCollections[i][j] = classItemStr
            }else{
                classCollections[i][j] = classCollections[i][j] + "\n\n-------------------------\n\n" + classItemStr
                
            }
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
                yPoint = 0 //-CELL_HEIGHT
            }else{
                xPoint = 0
                yPoint = CGFloat(i - 7) * CELL_HEIGHT
            }
            
            let label = UILabel(frame: CGRectMake(xPoint, yPoint, CELL_WIDTH, CELL_HEIGHT))
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
                let xPoint:CGFloat = CGFloat(i + 1) * CELL_WIDTH
                let yPoint:CGFloat = CGFloat(j + 1) * CELL_HEIGHT
                let btn = UIButton(frame: CGRectMake(xPoint, yPoint, CELL_WIDTH, CELL_HEIGHT))
                
                let label = UILabel(frame: CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT))
                
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
        
        //println(sender.tag)
        if sender.tag == -1 {
            if unkownClassItem != ""{
                let alert = UIAlertView(title: nil, message: unkownClassItem, delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        }else{
            let i = sender.tag / 6
            let j = sender.tag % 6
            if classCollections[i][j] != "" {
                let alert = UIAlertView(title: nil, message: classCollections[i][j], delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        }
    }
    
    //初始化课表的img标签
    func initTagImageCollections(){
        for i in 0...6{
            var imgCollection:[UIImageView] = []
            for j in 0...5{
                let img = UIImageView(frame: CGRectMake(CELL_WIDTH - 13, CELL_HEIGHT - 13, 9, 9))
                img.image = UIImage(named: "class_table_tag")
                imgCollection.append(img)
                labelCollections[i][j].addSubview(img)
            }
            tagImgCollections.append(imgCollection)
        }
        
    }
    
    //添加未知课程的label
    func addUnkownClassLabel(){
        let btn = UIButton(frame: CGRectMake( CELL_WIDTH , 7 * CELL_HEIGHT, 7 * CELL_WIDTH, CELL_HEIGHT))
        btn.layer.borderWidth = 0.3
        btn.layer.borderColor = UIColor.blackColor().CGColor
        btn.tag = -1
        btn.addTarget(self, action: "classBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        unkownClassLabel = UILabel(frame: CGRectMake(0, 0, 7 * CELL_WIDTH, CELL_HEIGHT))
        unkownClassLabel.font = UIFont(name: "Helvetica", size: 10.0)
        unkownClassLabel.numberOfLines = 0
        unkownClassLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        btn.addSubview(unkownClassLabel)
        
        scrollView.addSubview(btn)
    }
    
    //更新课表UI
    func updateClassTableUI(){
        for i in 0...6{
            for j in 0...5{
                
                if (classCollections[i][j] != "") && isMoreThanOneCourse(classCollections[i][j]) {
                    labelCollections[i][j].textColor = UIColor.blueColor()
                    tagImgCollections[i][j].alpha = 1
                }else{
                    labelCollections[i][j].textColor = UIColor.blackColor()
                    tagImgCollections[i][j].alpha = 0
                }
                
                labelCollections[i][j].text = showFirstThreeLines(classCollections[i][j])
                
            }
        }
        unkownClassLabel.text = unkownClassItem
    }
    
    //初始化课表内容数组
    func assignStringsContent(){
        for _ in 0...6{
            var collection:[String] = []
            for _ in 0...5{
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
    
    func isMoreThanOneCourse(courseInfo: String)->Bool{
        let arr = courseInfo.characters.split{$0 == "\n"}.map { String($0) }
        if arr.count == 3{
            return false
        }
        return true
    }
    
    func showFirstThreeLines(courseStr: String) -> String{
        let arr:[String] = courseStr.characters.split{$0 == "\n"}.map { String($0) }
        if arr.count > 3{
            return arr[0] + "\n" + arr[1] + "\n" + arr[2]
        }
        
        return courseStr
        
    }
    
}
