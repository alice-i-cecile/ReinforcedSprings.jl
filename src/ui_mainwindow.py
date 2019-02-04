# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'mainwindow.ui',
# licensing of 'mainwindow.ui' applies.
#
# Created: Mon Feb  4 14:45:15 2019
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
        self.build_layout = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget)
        self.build_layout.setContentsMargins(0, 0, 0, 0)
        self.build_layout.setObjectName("build_layout")
        self.build_info = QtWidgets.QLabel(self.horizontalLayoutWidget)
        self.build_info.setMinimumSize(QtCore.QSize(200, 0))
        self.build_info.setBaseSize(QtCore.QSize(200, 0))
        self.build_info.setAlignment(QtCore.Qt.AlignCenter)
        self.build_info.setTextInteractionFlags(QtCore.Qt.NoTextInteraction)
        self.build_info.setObjectName("build_info")
        self.build_layout.addWidget(self.build_info)
        self.build_canvas = QtWidgets.QGraphicsView(self.horizontalLayoutWidget)
        self.build_canvas.setMouseTracking(True)
        self.build_canvas.setTabletTracking(True)
        self.build_canvas.setObjectName("build_canvas")
        self.build_layout.addWidget(self.build_canvas)
        self.mode_tabs.addTab(self.build, "")
        self.play = QtWidgets.QWidget()
        self.play.setObjectName("play")
        self.horizontalLayoutWidget_2 = QtWidgets.QWidget(self.play)
        self.horizontalLayoutWidget_2.setGeometry(QtCore.QRect(10, 0, 951, 561))
        self.horizontalLayoutWidget_2.setObjectName("horizontalLayoutWidget_2")
        self.play_layout = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget_2)
        self.play_layout.setContentsMargins(0, 0, 0, 0)
        self.play_layout.setObjectName("play_layout")
        self.play_info = QtWidgets.QLabel(self.horizontalLayoutWidget_2)
        self.play_info.setMinimumSize(QtCore.QSize(200, 0))
        self.play_info.setBaseSize(QtCore.QSize(200, 0))
        self.play_info.setAlignment(QtCore.Qt.AlignCenter)
        self.play_info.setTextInteractionFlags(QtCore.Qt.NoTextInteraction)
        self.play_info.setObjectName("play_info")
        self.play_layout.addWidget(self.play_info)
        self.play_canvas = QtWidgets.QGraphicsView(self.horizontalLayoutWidget_2)
        self.play_canvas.setMinimumSize(QtCore.QSize(200, 0))
        self.play_canvas.setBaseSize(QtCore.QSize(200, 0))
        self.play_canvas.setObjectName("play_canvas")
        self.play_layout.addWidget(self.play_canvas)
        self.mode_tabs.addTab(self.play, "")
        MainWindow.setCentralWidget(self.main_window)

        self.retranslateUi(MainWindow)
        self.mode_tabs.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtWidgets.QApplication.translate("MainWindow", "MainWindow", None, -1))
        self.build_info.setText(QtWidgets.QApplication.translate("MainWindow", "Mass: 50", None, -1))
        self.mode_tabs.setTabText(self.mode_tabs.indexOf(self.build), QtWidgets.QApplication.translate("MainWindow", "Build", None, -1))
        self.play_info.setText(QtWidgets.QApplication.translate("MainWindow", "FPS: NYI", None, -1))
        self.mode_tabs.setTabText(self.mode_tabs.indexOf(self.play), QtWidgets.QApplication.translate("MainWindow", "Play", None, -1))

