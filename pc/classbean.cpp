#include "classbean.h"

/**
 * @brief ClassBean::ClassBean
 * @param id
 * @param className
 * @param teacher
 * @param timeAndPosition
 */
ClassBean::ClassBean(QString id, QString className, QString teacher, QString timeAndPosition, QString credit)
{
    this->id = id;
    this->className = className;
    this->teacher = teacher;
    this->timeAndPosition = timeAndPosition;
    this->credit = credit;
}

/**
 * @brief ClassBean::ClassBean
 * @param where
 * @param className
 * @param teacher
 * @param time
 * @param position
 */
ClassBean::ClassBean(int where, QString className, QString teacher, QString time, QString position)
{
    this->where = where;
    this->className = className;
    this->teacher = teacher;
    this->time = time;
    this->position = position;
}
