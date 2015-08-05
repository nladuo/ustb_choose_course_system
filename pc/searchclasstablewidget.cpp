#include "searchclasstablewidget.h"
#include "ui_searchclasstablewidget.h"

SearchClassTableWidget::SearchClassTableWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::SearchClassTableWidget)
{
    //设置居中
    QDesktopWidget* pDw = QApplication::desktop();//获得桌面窗体
    QRect rect = pDw->screenGeometry ();
    move( (rect.width() -this->width ()) / 2, (rect.height() -this->height ()) / 2 );

    ui->setupUi(this);
}

/**
 * @brief SearchClassTableWidget::setSemester
 * @param semester
 */
void SearchClassTableWidget::setSemester(QString semester){
    ui->whichSemesterLineEdit->setText (semester);
}

SearchClassTableWidget::~SearchClassTableWidget()
{
    delete ui;
}

/**
 * @brief SearchClassTableWidget::on_searchBtn_clicked
 */
void SearchClassTableWidget::on_searchBtn_clicked()
{
    //clear cache
    for (int i = 0; i < 42; i++){ classItems[i] = ""; }

    QByteArray postData;
    postData.append("listXnxq=")
            .append (ui->whichSemesterLineEdit->text ())
            .append("&uid=")
            .append (UserInfo::getInstance ()->getName ());
    //登陆,并获取登陆的cookie(session),如果没有获取成功,则是密码或用户名错误
    QNetworkReply* reply = HttpUtil::post ("http://elearning.ustb.edu.cn/choose_courses/choosecourse/commonChooseCourse_courseList_loadTermCourses.action"
                                           , postData,mCookieJar);
    QByteArray data = reply->readAll ();

    qDebug()<<data;

    JsonParser *parser = new JsonParser(data);

    vector<ClassBean *> beans = parser->getClassTableItems ();
    vector<ClassBean*>::iterator iter;
    QString unknownClass = "";
    //parse classbean to string
    for (iter = beans.begin(); iter != beans.end(); iter++){
        int where = ((ClassBean *)(*iter))->getWhere ();
        //未知课程
        if(where == -1){
            QString classInfo =  ((ClassBean *)(*iter))->getClassName ()
                    .append ("(")
                    .append (((ClassBean *)(*iter))->getTeacher () != NULL ?((ClassBean *)(*iter))->getTeacher () : "未知老师")
                    .append (")");
            if(unknownClass != ""){
                unknownClass.append ("  、");
            }
            unknownClass.append (classInfo);
            continue;
        }
        QString classItemStr = ((ClassBean *)(*iter))->getClassName ()
                .append ("<br>")
                .append (((ClassBean *)(*iter))->getTeacher ())
                .append ("<br>(")
                .append (((ClassBean *)(*iter))->getTime ())
                .append (" ")
                .append (((ClassBean *)(*iter))->getPosition ())
                .append (")");

        if(classItems[where] == ""){
            classItems[where] = classItemStr;
        }else{
            classItems[where] = classItems[where]
                    .append ("<hr>")
                    .append (classItemStr);
        }
    }

    QWidget* classTableWidget = new QWidget;
    classTableWidget->setWindowTitle ("2014-2015-3课程表");
    QGridLayout* layout = new QGridLayout;
    layout->setSpacing(0);
    layout->setMargin(0);
    QString config[] = {"\\", "第一节", "第二节",
                        "第三节",  "第四节", "第五节",
                        "第六节", "未知时间课程", "星期一",  "星期二",
                        "星期三",  "星期四",
                        "星期五", "星期六", "星期日" };
    for(int i = 0 ; i < 15 ; i++){
        QLabel* label = new QLabel;
        label->setAlignment(Qt::AlignCenter);
        QFont ft;
        ft.setPointSize(10);
        label->setFrameShape (QFrame::Box);
        label->setStyleSheet("border: 1px dashed  #000000");
        label->setFont(ft);
        label->setText (config[i]);
        if(i < 8){
            layout->addWidget (label, i, 0);
        }else{
            layout->addWidget (label, 0, i - 7);
        }

    }
    //未知课程
    {
        QLabel* label = new QLabel;
        label->setAlignment(Qt::AlignCenter);
        QFont ft;
        ft.setPointSize(10);
        label->setFrameShape (QFrame::Box);
        label->setStyleSheet("border: 1px dashed  #000000");
        label->setFont(ft);
        label->setText (unknownClass);
        layout->addWidget (label, 7, 1, 1, 7);
    }

    for (int i = 0; i < 42; i++){
        int weekNum = i / 6;
        int whichNum = i % 6;
        QLabel* label = new QLabel;
        label->setAlignment(Qt::AlignCenter);
        label->setFrameShape (QFrame::Box);
        label->setStyleSheet("border: 1px dashed  #000000");
        QFont ft;
        ft.setPointSize(9);
        label->setFont(ft);
        label->setText (classItems[i]);
        layout->addWidget (label, whichNum + 1, weekNum + 1);
    }
    classTableWidget->setLayout (layout);
    QDesktopWidget* pDw = QApplication::desktop();//获得桌面窗体
    QRect rect = pDw->screenGeometry ();
    classTableWidget->move( (rect.width() -classTableWidget->width ()) / 2
                            , (rect.height() -classTableWidget->height ()) / 2 );
    classTableWidget->show ();
}
