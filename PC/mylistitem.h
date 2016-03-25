#ifndef MYLISTITEM_H
#define MYLISTITEM_H

#include <QWidget>
#include "classbean.h"

namespace Ui {
class MyListItem;
}

/**
 * @brief The MyListItem class
 */
class MyListItem : public QWidget
{
    Q_OBJECT

public:
    explicit MyListItem(ClassBean* bean,QWidget *parent = 0);
    ~MyListItem();
    ClassBean* getBean(){return this->bean;}

private:
    Ui::MyListItem *ui;
    ClassBean* bean;
};

#endif // MYLISTITEM_H
