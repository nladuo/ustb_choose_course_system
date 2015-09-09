#include <QDesktopWidget>
#include <QMessageBox>
#include "controllwindow.h"
#include "ui_controllwindow.h"

ControllWindow::ControllWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::ControllWindow)
{
    ui->setupUi(this);
    this->setMaximumSize (542, 367);
    this->setMinimumSize (542, 367);
    //设置居中
    QDesktopWidget* pDw = QApplication::desktop();//获得桌面窗体
    QRect rect = pDw->screenGeometry ();
    move( (rect.width() -this->width ()) / 2, (rect.height() -this->height ()) / 2 );

    connect(this->ui->action_about, &QAction::triggered, this, &ControllWindow::on_actionAbout_clicked);
    connect(this->ui->action_update, &QAction::triggered, this, &ControllWindow::on_actionUpdate_clicked);
    connect (this->ui->action_notice, &QAction::triggered, this, &ControllWindow::on_actionNotice_clicked);

}

ControllWindow::~ControllWindow()
{
    delete ui;
}

/**
 * @brief ControllWindow::on_actionAbout_clicked
 */
void ControllWindow::on_actionAbout_clicked (){
    QMessageBox::about (this, "关于", ABOUT_MSG);
}

/**
 * @brief ControllWindow::on_actionUpdate_clicked
 */
void ControllWindow::on_actionUpdate_clicked (){
    WaitDialog dialog;
    dialog.show ();
    QNetworkReply* reply = HttpUtil::get(UPDATE_URL, new QNetworkCookieJar());
    QByteArray data = reply->readAll ();
    JsonParser parser = JsonParser(data);
    QString msg = parser.getSoftWareUpdateInfo ();
    dialog.close ();
    QMessageBox::about (this, "更新信息", msg);
}

/**
 * @brief ControllWindow::on_actionNotice_clicked
 */
void ControllWindow::on_actionNotice_clicked (){
    QMessageBox::about (this, "注意事项" ,NOTE_MSG);
}

/**
 * @brief ControllWindow::getBean
 */
void ControllWindow::getBean()
{
    QString searchUrl = SEARCH_COURSE_URL;
    QNetworkReply* reply = HttpUtil::get (searchUrl.append (UserInfo::getInstance ()->getName ()),
                                          mCookieJar);
    QByteArray jsonStr = reply->readAll ();
    JsonParser* parser = new JsonParser(jsonStr);
    alternativeClasses = parser->getAlternativeCourses ();
    selectedClasses = parser->getSelectedCourses ();
    searchClassTableWidget.setSemester (parser->getSemester ());
    delete parser;
}

/**
 * @brief ControllWindow::searchClasses
 */
void ControllWindow::searchClasses()
{
    QTime current_time = QTime::currentTime();
    int second = current_time.second();
    int msec = current_time.msec();

    ui->alternativeListWidget->clear ();
    ui->selectedListWidget->clear ();
    getBean ();

    vector<ClassBean*>::iterator iter;
    //add alternative classes
    for (iter = alternativeClasses.begin(); iter != alternativeClasses.end(); iter++){
        QListWidgetItem *listItem = new QListWidgetItem();
        listItem->setText ( ((ClassBean *)(*iter))->getId () );
        MyListItem* item = new MyListItem((ClassBean *)(*iter));
        ui->alternativeListWidget->addItem (listItem);
        ui->alternativeListWidget->setItemWidget (listItem, item);
    }

    //add selective class
    for (iter = selectedClasses.begin(); iter != selectedClasses.end(); iter++){
        QListWidgetItem *listItem = new QListWidgetItem();
        listItem->setText ( ((ClassBean *)(*iter))->getId () );
        MyListItem* item = new MyListItem((ClassBean *)(*iter));
        ui->selectedListWidget->addItem (listItem);
        ui->selectedListWidget->setItemWidget (listItem, item);
    }

    //Test connect time
    current_time = QTime::currentTime();
    qDebug()<<"after--->"<<current_time.second() - second <<"."<<current_time.msec () - msec;
}

/**
 * @brief ControllWindow::on_searchClassBtn_clicked
 */
void ControllWindow::on_searchClassBtn_clicked()
{
    //查找选课
    searchClasses ();
}

/**
 * @brief ControllWindow::on_getClassTableBtn_clicked
 */
void ControllWindow::on_getClassTableBtn_clicked()
{
    searchClassTableWidget.setCookieJar (mCookieJar);
    searchClassTableWidget.show ();
}

/**
 * 选课
 * @brief ControllWindow::on_alternativeListWidget_itemDoubleClicked
 * @param item
 */
void ControllWindow::on_alternativeListWidget_itemDoubleClicked(QListWidgetItem *item)
{
    QByteArray postData;
    postData.append("id=").append (item->text ()).append ("&");
    postData.append("uid=").append (UserInfo::getInstance ()->getName ());
    QNetworkReply* reply = HttpUtil::post (ADD_COURSE_URL, postData, this->mCookieJar);

    QByteArray data = reply->readAll ();
    QMessageBox::about (this, "选课结果", data);
    searchClasses ();
}

/**
 * 退课
 * @brief ControllWindow::on_selectedListWidget_itemDoubleClicked
 * @param item
 */
void ControllWindow::on_selectedListWidget_itemDoubleClicked(QListWidgetItem *item)
{
    if( QMessageBox::warning (this, "退课", "你确定要退掉这门课？",
                          QMessageBox::Yes | QMessageBox::No, QMessageBox::No)
            == QMessageBox::Yes){
            qDebug()<<"Yes";
            ClassBean*bean = getSelectedClassBeanByCourseId (item->text ());
            QByteArray postData;
            postData.append("kch=").append (bean->getDYKCH ()).append ("&");
            postData.append ("kxh=").append (bean->getKXH ()).append ("&");
            postData.append ("xh=").append ("&");
            postData.append("uid=").append (UserInfo::getInstance ()->getName ());
            QNetworkReply* reply = HttpUtil::post (REMOVE_COURSE_URL, postData, this->mCookieJar);
            QByteArray data = reply->readAll ();
            qDebug()<<data;
            QMessageBox::about (this, "退课结果", data);
    }else{
        //qDebug()<<"No";
    }
    searchClasses ();
}

ClassBean* ControllWindow::getSelectedClassBeanByCourseId(QString id){

    vector<ClassBean*>::iterator iter;
    //add alternative classes
    for (iter = selectedClasses.begin(); iter != selectedClasses.end(); iter++){
        if(  ((ClassBean *)(*iter))->getId () == id){

            ClassBean bean = *(ClassBean *)(*iter);

            return new ClassBean(bean.getId (),
                                 bean.getClassName (),
                                 bean.getTeacher (),
                                 bean.getTimeAndPosition (),
                                 bean.getCredit (),
                                 bean.getRatio (),
                                 bean.getKXH (),
                                 bean.getDYKCH ());
        }
    }

    return NULL;
}


