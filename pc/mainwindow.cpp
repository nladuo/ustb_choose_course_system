#include "mainwindow.h"
#include "ui_mainwindow.h"

/**
 * @brief MainWindow::MainWindow
 * @param parent
 */
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->setMaximumSize (286, 278);
    this->setMinimumSize (286, 278);
    this->ui->pswdEdit->setEchoMode (QLineEdit::Password);
    //设置居中
    QDesktopWidget* pDw = QApplication::desktop();//获得桌面窗体
    QRect rect = pDw->screenGeometry ();
    move( (rect.width() -this->width ()) / 2, (rect.height() -this->height ()) / 2 );
    connect(this->ui->action_about, &QAction::triggered, this, &MainWindow::on_actionAbout_clicked);
    connect(this->ui->action_update, &QAction::triggered, this, &MainWindow::on_actionUpdate_clicked);
    connect (this->ui->action_notice, &QAction::triggered, this, &MainWindow::on_actionNotice_clicked);
    ui->savePrpCheckBox->setChecked (true);
    QFile file( "username" );
    if ( file.exists())
    {
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file);
        ui->usrNameEdit->setText (in.readLine ());
        file.close ();
    }else{
        file.open(QIODevice::ReadWrite | QIODevice::Text);
        file.close ();
    }

    QFile file2( "password" );
    if ( file2.exists())
    {
        file2.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file2);
        ui->pswdEdit->setText (in.readLine ());
        file2.close ();
    }else{
        file.open(QIODevice::ReadWrite | QIODevice::Text);
        file2.close ();
    }

}

/**
 * @brief MainWindow::on_actionAbout_clicked
 */
void MainWindow::on_actionAbout_clicked ()
{
    QMessageBox::about (this, "关于", ABOUT_MSG);
}

/**
 * @brief MainWindow::on_actionUpdate_clicked
 */
void MainWindow::on_actionUpdate_clicked ()
{
    QNetworkReply* reply = HttpUtil::get(UPDATE_URL, new QNetworkCookieJar());
    QByteArray data = reply->readAll ();
    JsonParser parser = JsonParser(data);
    QString msg = parser.getSoftWareUpdateInfo ();
    QMessageBox::about (this, "更新信息", msg);
}

/**
 * @brief MainWindow::on_actionNotice_clicked
 */
void MainWindow::on_actionNotice_clicked ()
{
    QMessageBox::about (this,"注意事项", NOTE_MSG);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::saveUserInfo (bool isClear){
    QString username;
    QString password;
    if(isClear){
        username = "";
        password = "";
    }else{
        username = ui->usrNameEdit->text ();
        password = ui->pswdEdit->text ();
    }
    QFile file("username");
    file.open(QIODevice::ReadWrite | QIODevice::Text);
    QTextStream in(&file);
    in<<username<<"\n";
    file.close();

    QFile file2("password");
    file2.open(QIODevice::ReadWrite | QIODevice::Text);
    QTextStream in2(&file2);
    in2<<password<<"\n";
    file2.close();
}

/**
 * @brief MainWindow::on_loginBtn_clicked
 *  登陆过程中,如果登陆登陆失败,显示错误信息
 *   如果登陆成功,把cookie传递给下一个界面
 *   否则,显示错误信息
 */
void MainWindow::on_loginBtn_clicked()
{
    saveUserInfo( !ui->savePrpCheckBox->isChecked ());

    QString username = this->ui->usrNameEdit->text ();
    QString password = this->ui->pswdEdit->text ();
    UserInfo* userInfo = UserInfo::getInstance ();
    userInfo->setName (username);
    userInfo->setPassword (password);
    //set post data
    QByteArray postData;
    postData.append("j_username=").append (username).append (",undergraduate&");
    postData.append("j_password=").append (password);
    //登陆,并获取登陆的cookie(session),如果没有获取成功,则是密码或用户名错误
    QNetworkReply* reply = HttpUtil::post (LOGIN_URL, postData, new QNetworkCookieJar());
    QString cookieData = reply->rawHeader ("Set-Cookie");
    //qDebug()<<cookieData;

    QNetworkCookieJar *cookieJar = new QNetworkCookieJar();
    QNetworkCookie *cookie = new QNetworkCookie();
    cookie->setDomain (".elearning.ustb.edu.cn");
    cookie->setPath ("/choose_courses/");
    cookie->setName ("JSESSIONID");
    cookie->setValue ( cookieData.splitRef (';')[0].split ('=')[1].toUtf8 ());
    cookieJar->insertCookie (*cookie);

    //qDebug()<<cookieData.splitRef (';')[0].split ('=')[1];

    reply = HttpUtil::get (CHECK_LOGIN_SUCCESS_URL, cookieJar);

    //登录失败的话,后台会出异常信息
    if( reply->readAll ().size ()> 200){
        QMessageBox::about (this, "LOGIN_STATUS", "登陆失败:用户名或密码错误");
        return;
    }
    QMessageBox::about (this, "LOGIN_STATUS", "登陆成功");
    this->close ();
    controllWindow.setCookieJar (cookieJar);
    controllWindow.searchClasses ();
    controllWindow.show ();
}
