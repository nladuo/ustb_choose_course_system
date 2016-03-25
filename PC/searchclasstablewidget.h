#ifndef SEARCHCLASSTABLEWIDGET_H
#define SEARCHCLASSTABLEWIDGET_H

#include <QWidget>
#include <QDesktopWidget>
#include <QGridLayout>
#include <vector>
#include "httputil.h"
#include "classbean.h"
#include "jsonparser.h"
#include "const_val.h"
#include "userinfo.h"

namespace Ui {
class SearchClassTableWidget;
}

/**
 * @brief The SearchClassTableWidget class
 */
class SearchClassTableWidget : public QWidget
{
    Q_OBJECT

public:
    explicit SearchClassTableWidget(QWidget *parent = 0);
    void setCookieJar(QNetworkCookieJar* cookieJar){this->mCookieJar = cookieJar;}
    ~SearchClassTableWidget();
    void setSemester(QString semester);

private slots:
    void on_searchBtn_clicked();

private:
    Ui::SearchClassTableWidget *ui;
    QString classItems[42];
    QNetworkCookieJar* mCookieJar;
};

#endif // SEARCHCLASSTABLEWIDGET_H
