#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QtCore>
#include <vector>
#include "classbean.h"
#include "const_val.h"
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
    QString getResultMsg ();
    QString getSemester();
    bool isNeedUpdate();
    QString getSoftWareUpdateInfo();
    //QString getChooseCourseResult();
private:
    QByteArray jsonStr;
    vector<ClassBean*> getCourses(QString type);
    vector<ClassBean*> parseClassTable(QString srcStr, QString className, QString teacher);
};

#endif // JSONPARSER_H
