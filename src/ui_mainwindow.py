# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'mainwindow.ui',
# licensing of 'mainwindow.ui' applies.
#
# Created: Fri Feb  1 18:43:24 2019
#      by: pyside2-uic  running on PySide2 5.12.0
#
# WARNING! All changes made in this file will be lost!

from PySide2 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(945, 585)
        MainWindow.setCursor(QtCore.Qt.ArrowCursor)
        self.main_window = QtWidgets.QWidget(MainWindow)
        self.main_window.setBaseSize(QtCore.QSize(800, 600))
        self.main_window.setObjectName("main_window")
        self.mode_tabs = QtWidgets.QTabWidget(self.main_window)
        self.mode_tabs.setGeometry(QtCore.QRect(0, 0, 951, 591))
        self.mode_tabs.setObjectName("mode_tabs")
        self.build = QtWidgets.QWidget()
        self.build.setObjectName("build")
        self.horizontalLayoutWidget = QtWidgets.QWidget(self.build)
        self.horizontalLayoutWidget.setGeometry(QtCore.QRect(-1, -1, 951, 561))
        self.horizontalLayoutWidget.setObjectName("horizontalLayoutWidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.build_info = QtWidgets.QGraphicsView(self.horizontalLayoutWidget)
        self.build_info.setMouseTracking(True)
        self.build_info.setTabletTracking(True)
        self.build_info.setObjectName("build_info")
        self.horizontalLayout.addWidget(self.build_info)
        self.build_canvas = QtWidgets.QListView(self.horizontalLayoutWidget)
        self.build_canvas.setObjectName("build_canvas")
        self.horizontalLayout.addWidget(self.build_canvas)
        self.mode_tabs.addTab(self.build, "")
        self.play = QtWidgets.QWidget()
        self.play.setObjectName("play")
        self.horizontalLayoutWidget_2 = QtWidgets.QWidget(self.play)
        self.horizontalLayoutWidget_2.setGeometry(QtCore.QRect(0, 0, 951, 561))
        self.horizontalLayoutWidget_2.setObjectName("horizontalLayoutWidget_2")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget_2)
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.play_canvas = QtWidgets.QGraphicsView(self.horizontalLayoutWidget_2)
        self.play_canvas.setObjectName("play_canvas")
        self.horizontalLayout_2.addWidget(self.play_canvas)
        self.play_info = QtWidgets.QListView(self.horizontalLayoutWidget_2)
        self.play_info.setMouseTracking(True)
        self.play_info.setTabletTracking(True)
        self.play_info.setModelColumn(0)
        self.play_info.setObjectName("play_info")
        self.horizontalLayout_2.addWidget(self.play_info)
        self.mode_tabs.addTab(self.play, "")
        MainWindow.setCentralWidget(self.main_window)

        self.retranslateUi(MainWindow)
        self.mode_tabs.setCurrentIndex(1)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtWidgets.QApplication.translate("MainWindow", "MainWindow", None, -1))
        self.mode_tabs.setTabText(self.mode_tabs.indexOf(self.build), QtWidgets.QApplication.translate("MainWindow", "Build", None, -1))
        self.mode_tabs.setTabText(self.mode_tabs.indexOf(self.play), QtWidgets.QApplication.translate("MainWindow", "Play", None, -1))

