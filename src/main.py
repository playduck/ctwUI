#!/usr/bin/env python3

from PyQt5 import QtCore, QtQml
from PyQt5.QtWidgets import QApplication

import config
import resources
import sys

import bridge
import process

def main() -> int:

    QApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling, True)
    QApplication.setAttribute(QtCore.Qt.AA_UseHighDpiPixmaps, True)

    app = QApplication(sys.argv)
    resources.qInitResources()

    # setup qml and context
    engine = QtQml.QQmlApplicationEngine()
    context = engine.rootContext()
    context.setContextProperty("os", sys.platform)

    bridgeObject = bridge.Bridge()
    context.setContextProperty("bridge", bridgeObject)


    # load qml
    # can't use qrc here, since it would imply all data be loaded from qrc
    # which is impossible with dynamically generated images
    qml_file = config.getResource("./src/qml/main.qml")
    engine.load(qml_file)

    # setup mac window
    if sys.platform.startswith("darwin"):
        import macWindow
        macWindow.setCustomWindow(engine)


    # start timer in interactive
    if getattr(sys, 'frozen', True):
        # used to abort programm with ^C
        timer = QtCore.QTimer()
        # need to connect otherwise it won't fire
        timer.timeout.connect(lambda: None)
        timer.start(100)

    # run gui
    rcode = app.exec_()

    return rcode


if __name__ == "__main__":
    sys.exit(main())
