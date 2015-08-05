#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QtCore>
#include <vector>
#include "classbean.h"
using namespace std;

/**
 * @brief The JsonParser class
 */
class JsonParser
{
public:
    JsonParser(QByteArray jsonStr);
    vector<ClassBean*> getSelectedCourses();
    vector<ClassBean*> getAlternativeCourses();
    vector<ClassBean*> getClassTableItems();
    QString getSemester();
private:
    QByteArray jsonStr;
    vector<ClassBean*> getCourses(QString type);
    vector<ClassBean*> parseClassTable(QString srcStr, QString className, QString teacher);
};

#endif // JSONPARSER_H
