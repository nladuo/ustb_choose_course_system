#include <QDesktopWidget>
#include <QMessageBox>
#include "controllwindow.h"
#include "ui_controllwindow.h"

ControllWindow::ControllWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::ControllWindow)
{
    ui->setupUi(this);
    this->setMaximumSize (490, 367);
    this->setMinimumSize (490, 367);
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
    QMessageBox::about (this, "关于", "版本:北科大选课系统V0.10<br>作者:刘嘉铭<br>博客:<a href=\"http://blog.kalen25115.cn\">http://blog.kalen25115.cn</a><br>说明:本软件为开源软件<br>源码地址:<a href=\"https://github.com/nladuo/ustb_choose_course_system\">https://github.com/nladuo/ustb_choose_course_system</a>");
}

/**
 * @brief ControllWindow::on_actionUpdate_clicked
 */
void ControllWindow::on_actionUpdate_clicked (){

}

/**
 * @brief ControllWindow::on_actionNotice_clicked
 */
void ControllWindow::on_actionNotice_clicked (){
    QMessageBox::about (this, "注意", "登陆本软件后，请不要再次登陆网页版选课系统，以防止程序崩掉。");
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
 * @brief ControllWindow::on_alternativeListWidget_itemDoubleClicked
 * @param item
 */
void ControllWindow::on_alternativeListWidget_itemDoubleClicked(QListWidgetItem *item)
{
    QMessageBox::about (this, "title", item->text ());
}

/**
 * @brief ControllWindow::on_getClassTableBtn_clicked
 */
void ControllWindow::on_getClassTableBtn_clicked()
{
    searchClassTableWidget.setCookieJar (mCookieJar);
    searchClassTableWidget.show ();
}
