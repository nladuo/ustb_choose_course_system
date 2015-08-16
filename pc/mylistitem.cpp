#include "mylistitem.h"
#include "ui_mylistitem.h"

/**
 * @brief MyListItem::MyListItem
 * @param bean
 * @param parent
 */
MyListItem::MyListItem(ClassBean* bean,QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MyListItem)
{
    ui->setupUi(this);
    this->bean = bean;
    ui->nameLabel->setText (bean->getClassName ());
    ui->teacherLabel->setText (bean->getTeacher ());
    ui->timeAndPositionLabel->setText (bean->getTimeAndPosition ());
    ui->creditLabel->setText (bean->getCredit ());
}



MyListItem::~MyListItem()
{
    delete ui;
}
