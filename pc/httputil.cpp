#include "httputil.h"

HttpUtil::HttpUtil(QObject *parent) : QObject(parent)
{

}


/**
 * @brief HttpUtil::get
 * @param url
 * @param cookieJar
 * @return
 */
QNetworkReply* HttpUtil::get (QString url, QNetworkCookieJar* cookieJar)
{
    QNetworkAccessManager* manager = new QNetworkAccessManager();
    manager->setCookieJar(cookieJar);

    QNetworkRequest req;
    req.setUrl(QUrl(url));
    QNetworkReply *reply = manager->get(req);
    QEventLoop eventLoop;
    connect(manager, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));

    eventLoop.exec();       //block until finish
    return reply;
}

/**
 * @brief HttpUtil::post
 * @param url
 * @param postData
 * @param cookieJar
 * @return
 */
QNetworkReply* HttpUtil::post(QString url,QByteArray postData, QNetworkCookieJar* cookieJar){
    QNetworkAccessManager* manager = new QNetworkAccessManager();
    //setcookie
    manager->setCookieJar(cookieJar);

    //set url
    QNetworkRequest req;
    req.setUrl(QUrl(url));
    //set header
    req.setRawHeader ("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    req.setRawHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko");

    QNetworkReply *reply = manager->post(req, postData);
    reply->ignoreSslErrors ();
    QEventLoop eventLoop;
    connect(manager, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));
    eventLoop.exec();       //block until finish
    return reply;
}


