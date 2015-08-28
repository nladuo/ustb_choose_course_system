#-------------------------------------------------
#
# Project created by QtCreator 2015-08-02T00:31:40
#
#-------------------------------------------------

QT       += core gui
QT       += network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ustb_choose_courses_system
TEMPLATE = app


SOURCES += main.cpp \
    mainwindow.cpp \
    controllwindow.cpp \
    httputil.cpp \
    userinfo.cpp \
    classbean.cpp \
    jsonparser.cpp \
    mylistitem.cpp \
    searchclasstablewidget.cpp \
    waitdialog.cpp

HEADERS  += mainwindow.h \
    controllwindow.h \
    httputil.h \
    const_val.h \
    userinfo.h \
    classbean.h \
    jsonparser.h \
    mylistitem.h \
    searchclasstablewidget.h \
    waitdialog.h

FORMS    += \
    mainwindow.ui \
    controllwindow.ui \
    mylistitem.ui \
    searchclasstablewidget.ui \
    waitdialog.ui

RESOURCES += \
    ustb_app.qrc
