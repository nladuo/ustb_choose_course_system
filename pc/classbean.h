#ifndef CLASSBEAN_H
#define CLASSBEAN_H
#include<QtCore>

class ClassBean
{
public:
    //for search class
    ClassBean(QString id, QString className, QString teacher, QString timeAndPosition, QString credit);
    //for get class table
    ClassBean(int where, QString className, QString teacher, QString time ,QString position);
    /****************filed************/
    //get method
    QString getId(){return this->id;}
    QString getClassName(){return this->className;}
    QString getTeacher(){return this->teacher;}
    int getWhere(){return this->where;}
    QString getTime() {return this->time;}
    QString getPosition() {return this->position;}
    QString getTimeAndPosition() {return this->timeAndPosition;}
    QString getCredit() {return this->credit;}
    //set method
    void setId(QString id){this->id = id;}
    void setClassName(QString className){this->className = className;}
    void setTeacher(QString teacher){this->teacher = teacher;}
    void setWhere(int where) {this->where = where;}
    void setTime(QString time) {this->time = time;}
    void setPosition(QString position){this->position = position;}
    void setTimeAndPosition(QString timeAndPosition) {this->timeAndPosition = timeAndPosition;}
    void setCredit(QString credit) { this->credit = credit; }
private:
    QString id;
    QString className;
    QString teacher;
    QString timeAndPosition;
    int where;
    QString time;
    QString position;
    QString credit;
};

#endif // CLASSBEAN_H
