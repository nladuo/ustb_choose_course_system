#ifndef HTTPUTIL_H
#define HTTPUTIL_H

#include <QObject>
#include <QtNetwork/QNetworkCookie>
#include <QtNetwork/QNetworkCookieJar>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QtCore>

/**
 * @brief The HttpUtil class
 */
class HttpUtil : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtil(QObject *parent = 0);
    static QNetworkReply* get(QString url, QNetworkCookieJar* cookieJar = NULL);
    static QNetworkReply* post(QString url,QByteArray postData, QNetworkCookieJar* cookieJar);

signals:

public slots:

};


#endif // HTTPUTIL_H
