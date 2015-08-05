#include "jsonparser.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QJsonDocument>

JsonParser::JsonParser(QByteArray jsonStr)
{
    this->jsonStr = jsonStr;
}

/**
 * @brief JsonParser::getAlternativeCourses
 * @return
 */
vector<ClassBean*> JsonParser::getAlternativeCourses ()
{
    return getCourses ("alternativeCourses");
}

/**
 * @brief JsonParser::getSelectedCourses
 * @return
 */
vector<ClassBean*> JsonParser::getSelectedCourses ()
{
    return getCourses ("selectedCourses");
}

/**
 * @brief JsonParser::getCourses
 * @param type
 * @return
 */
vector<ClassBean*> JsonParser::getCourses (QString type)
{
    vector<ClassBean*> v;
    QByteArray data = jsonStr;
    QJsonParseError jsonError;//Qt5新类
    QJsonDocument json = QJsonDocument::fromJson(data, &jsonError);//Qt5新类
    if(jsonError.error == QJsonParseError::NoError)//Qt5新类
    {
        QJsonObject obj = json.object();//Qt5新类
        QJsonArray array = obj[type].toArray ();
        for (int i = 0; i < array.size ();i++){
            QJsonObject obj2 = array.at (i).toObject ();
            int id = obj2["ID"].toInt ();
            QString className = obj2["DYKCM"].toString ();
            QString deadline = obj2["TKJZRQ"].toString ();
            QString teacher;
            {
                QJsonArray array2 = obj2["JSM"].toArray ();
                QJsonObject obj3 = array2.at (0).toObject ();
                teacher = obj3["JSM"].toString ();
            }
            v.push_back (new ClassBean(QString::number (id), className, teacher, deadline));
        }
    }
    return v;
}

/**
 * @brief JsonParser::getClassTableItems
 * @return
 */
vector<ClassBean*> JsonParser::getClassTableItems ()
{
    vector<ClassBean*> v;
    QByteArray data = jsonStr;
    QJsonParseError jsonError;//Qt5新类
    QJsonDocument json = QJsonDocument::fromJson(data, &jsonError);//Qt5新类
    if(jsonError.error == QJsonParseError::NoError)//Qt5新类
    {
        QJsonObject obj = json.object();//Qt5新类
        QJsonArray array = obj["selectedCourses"].toArray ();
        for (int i = 0; i < array.size ();i++){
            QJsonObject obj2 = array.at (i).toObject ();
            QString className = obj2["DYKCM"].toString ();
            QString teacher;
            {//获取第一个老师的姓名
                QJsonArray array2 = obj2["JSM"].toArray ();
                QJsonObject obj3 = array2.at (0).toObject ();
                teacher = obj3["JSM"].toString ();
            }
            QString srcStr = obj2["SKSJDDSTR"].toString ();
            if(srcStr == ""){
                v.push_back (new ClassBean(-1, className, teacher, "",""));
                continue;
            }
            vector<ClassBean*> temps = parseClassTable (srcStr, className, teacher);
            v.insert (v.end (), temps.begin (), temps.end ());

            //配套课
            {
                QJsonArray array2 = obj2["PTK"].toArray ();
                for (int j = 0; j < array2.size (); j++){
                    QJsonObject obj3 = array2.at (j).toObject ();
                    QString className = obj3["DYKCM"].toString ();
                    QString teacher;
                    {//获取第一个老师的姓名
                        QJsonArray array3 = obj3["JSM"].toArray ();
                        QJsonObject obj4 = array3.at (0).toObject ();
                        teacher = obj4["JSM"].toString ();
                    }
                    QString srcStr = obj3["SKSJDDSTR"].toString ();
                    if(srcStr == ""){
                        v.push_back (new ClassBean(-1, className, teacher, "",""));
                        continue;
                    }
                    vector<ClassBean*> temps = parseClassTable (srcStr, className, teacher);
                    v.insert (v.end (), temps.begin (), temps.end ());
                }
            }

        }
    }
    return v;
}

/**
 * @brief JsonParser::parseClassTable
 * @param srcStr
 * @param className
 * @param teacher
 * @return
 */
vector<ClassBean*> JsonParser::parseClassTable(QString srcStr, QString className, QString teacher)
{
    vector<ClassBean*> classes;
    srcStr = srcStr.trimmed ();
    QVector<QStringRef> datas = srcStr.splitRef (' ');
    for(int i = 0; i < datas.size (); i+=2){
        QString position = QString::fromUtf8 (datas.at (i+1).split (')')[0].toUtf8 ());
        //周几
        int weekTime  = QString::fromUtf8 (datas.at (i).split (',')[0].toUtf8 ()).at(2).toLatin1 () - 48;
        //第几节
        int whichNum = QString::fromUtf8 (datas.at (i).split (',')[1].toUtf8 ()).at (1).toLatin1 () - 48;
        int where = (weekTime - 1) * 6 + whichNum - 1;
        QString time = QString::fromUtf8 (datas.at (i).toUtf8 ()).remove (0, 8);
        classes.push_back (new ClassBean(where, className, teacher, time, position));
    }
    return classes;
}

/**
 * @brief JsonParser::getSemester
 * @return
 */
QString JsonParser::getSemester (){
    QByteArray data = jsonStr;
    QJsonParseError jsonError;//Qt5新类
    QJsonDocument json = QJsonDocument::fromJson(data, &jsonError);//Qt5新类
    if(jsonError.error == QJsonParseError::NoError)//Qt5新类
    {
        QJsonObject obj = json.object();//Qt5新类
        QJsonArray array = obj["selectedCourses"].toArray ();
        for (int i = 0; i < array.size ();i++){
            QJsonObject obj2 = array.at (i).toObject ();
            return obj2["XNXQ"].toString ();

        }
    }
    return "无法定位具体学期";

}

