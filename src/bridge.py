from PyQt5 import QtCore
import process
import config
import threading

class Bridge(QtCore.QObject):
    done = QtCore.pyqtSignal(int, name="conversionDone")
    def __init__(self):
        QtCore.QObject.__init__(self)
        data = config.loadConfig()

        self._binary = data.get("binary", "")
        self._logfile = data.get("logfile", "")

    @QtCore.pyqtSlot("QVariantMap")
    def convertAction(self, settings: dict) -> None:
        x = threading.Thread(target=process.convert, args=(
            settings, self._binary, self._logfile,
            self.done.emit
        ))
        x.start()

        # process.convert(settings, self._binary, self._logfile)
        # ()

    @QtCore.pyqtSlot(str)
    def setBinary(self, path: str) -> None:
        self._binary = path
        config.saveConfig(self)

    @QtCore.pyqtProperty(str)
    def binary(self) -> str:
        return self._binary

    @QtCore.pyqtSlot(str)
    def setLog(self, path: str) -> None:
        self._logfile = path
        config.saveConfig(self)

    @QtCore.pyqtProperty(str)
    def logfile(self) -> str:
        return self._logfile
