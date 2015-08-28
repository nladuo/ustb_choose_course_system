#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <qmessagebox.h>
#include <QDesktopWidget>
#include <QProgressDialog>
#include "controllwindow.h"
#include "httputil.h"
#include "const_val.h"
#include "userinfo.h"
#include "waitdialog.h"

namespace Ui {
class MainWindow;
}

/**
 * @brief The MainWindow class
 */
class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
   // void on_savePrpCheckBox_clicked(bool checked);
    void on_loginBtn_clicked();
    void on_actionAbout_clicked();
    void on_actionUpdate_clicked();
    void on_actionNotice_clicked();

private:
    Ui::MainWindow *ui;
    ControllWindow controllWindow;
    void saveUserInfo(bool isClear);
};

#endif // MAINWINDOW_H
