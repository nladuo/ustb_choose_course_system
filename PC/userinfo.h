#ifndef USERINFO_H
#define USERINFO_H
#include <QtGui>

/**
 * @brief The UserInfo class
 */
class UserInfo
{
public:
    static UserInfo* getInstance();
    void setName(QString name){ this->name = name;}
    void setPassword(QString password) { this->password = password; }
    QString getName() { return this->name; }
    QString getPassword() { return this->password;}

private:
    static UserInfo* userInfo;
    UserInfo();
    QString name;
    QString password;
};

#endif // USERINFO_H
