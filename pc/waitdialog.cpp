#include "waitdialog.h"
#include "ui_waitdialog.h"

WaitDialog::WaitDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::WaitDialog)
{
    ui->setupUi(this);
    this->ui->progressBar->setMaximum (0);
    this->ui->progressBar->setMinimum (0);
    QDesktopWidget* pDw = QApplication::desktop();//获得桌面窗体
    QRect rect = pDw->screenGeometry ();
    move( (rect.width() -this->width ()) / 2, (rect.height() -this->height ()) / 2 );
}

WaitDialog::~WaitDialog()
{
    delete ui;
}
