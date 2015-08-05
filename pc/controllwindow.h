#ifndef CONTROLLWINDOW_H
#define CONTROLLWINDOW_H

#include <QMainWindow>
#include <QListWidgetItem>
#include <vector>
#include <QGridLayout>
#include "httputil.h"
#include "classbean.h"
#include "mylistitem.h"
#include "jsonparser.h"
#include "const_val.h"
#include "userinfo.h"
#include "searchclasstablewidget.h"

using namespace std;

namespace Ui {
class ControllWindow;
}

/**
 * @brief The ControllWindow class
 */
class ControllWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit ControllWindow(QWidget *parent = 0);
    ~ControllWindow();
    void setCookieJar(QNetworkCookieJar* cookieJar){this->mCookieJar = cookieJar;}
    void searchClasses();

private slots:
    void on_searchClassBtn_clicked();
    void on_alternativeListWidget_itemDoubleClicked(QListWidgetItem *item);
    void on_getClassTableBtn_clicked();
    void on_actionAbout_clicked();
    void on_actionUpdate_clicked();
    void on_actionNotice_clicked();

private:
    Ui::ControllWindow *ui;
    QNetworkCookieJar* mCookieJar;
    vector<ClassBean*> alternativeClasses;
    vector<ClassBean*> selectedClasses;
    void getBean();
    SearchClassTableWidget searchClassTableWidget;

};

#endif // CONTROLLWINDOW_H
