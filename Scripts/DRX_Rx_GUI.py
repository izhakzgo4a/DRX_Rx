import sys
from PyQt5 import QtWidgets, QtGui, uic
from PyQt5.QtGui import *
# from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import cv2
import socket
import threading
import numpy as np
import time

import DRX_GUI_UI

server_ip = '127.0.0.1'  # Localhost
server_port = 12345  # Example port

class myApp(QtWidgets.QMainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.ui = uic.loadUi('DRX_GUI.ui', self)

        self.intIntrpCheckBox.clicked.connect(lambda: self.setIntIntrp(self.intIntrpCheckBox.isChecked()))

        self.rssiOffset = [0,0,0,0]
        self.rssiOffsetSpinBox_0.valueChanged.connect(self.updateRssiOffset)
        self.rssiOffsetSpinBox_1.valueChanged.connect(self.updateRssiOffset)
        self.rssiOffsetSpinBox_2.valueChanged.connect(self.updateRssiOffset)
        self.rssiOffsetSpinBox_3.valueChanged.connect(self.updateRssiOffset)



        self.VidThread = VideoThread()
        self.VidThread.start()
        self.VidThread.ImageUpdate.connect(self.ImageUpdateSlot)

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((server_ip, server_port))
        self.sock.listen()
        self.clients = []
        self.connected = False

        self.receiveThread = threading.Thread(target=self.receive)
        self.receiveThread.start()

        self.rssiTimer = QTimer()
        self.rssiTimer.timeout.connect(lambda: self.readRssi())
        self.rssiTimer.start(1000)

        self.sr = cv2.dnn_superres.DnnSuperResImpl_create()

        # read the model
        path = 'EDSR_x4.pb'
        self.sr.readModel(path)

        # set the model and scale
        self.sr.setModel('edsr', 4)

        # if you have cuda support
        self.sr.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
        self.sr.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA)

    def ImageUpdateSlot(self, Image):
        if self.intrpCheckBox.isChecked():
            # arrayImage = qimage2ndarray
            downSampledImage = Image[::4,::4,:]
            upSampledImage = self.sr.upsample(Image)
            ConvertToQtFormat = QImage(upSampledImage.data, Image.shape[1], Image.shape[0], QImage.Format_RGB888)
            Pic = ConvertToQtFormat.scaled(640, 480, Qt.KeepAspectRatio)
            self.label_Image.setPixmap(QPixmap.fromImage(Pic))
        else:
            downSampledImage = np.zeros(Image.shape)
            downSampledImage[::4, ::4, :] = Image[::4, ::4, :]
            downSampledImage = downSampledImage.astype('uint8')
            ConvertToQtFormat = QImage(Image.data, Image.shape[1], Image.shape[0], QImage.Format_RGB888)
            Pic = ConvertToQtFormat.scaled(640, 480, Qt.KeepAspectRatio)
            self.label_Image.setPixmap(QPixmap.fromImage(Pic))



    def CancelFeed(self):
        self.VideoThread.stop()

    def receive(self):
        while True:
            # Accept Connection
            self.client, self.address = self.sock.accept()
            self.clients.append(self.client)
            print("Connected with {}".format(str(self.address)))
            self.connected = True

            # self.client.send('hello'.encode('ascii'))
            # Start Handling Thread For Client
            # thread = threading.Thread(target=handle, args=(self.client,))
            # thread.start()

    def sendMessage(self, message):
        if self.connected:
            self.client.send((message + '\n').encode('ascii'))
            return True
        else:
            return False

    def writeReg(self, addr, data):
        msg = 'RegWr ' + format(addr, '08x') + ' ' + format(data, '08x')
        if self.sendMessage(msg):
            data = self.client.recv(30).decode("utf-8")
            print(data)
        else:
            print("Client not connected")

    def readReg(self, addr):
        msg = 'RegRd ' + format(addr, '08x')
        # print(msg)
        if self.sendMessage(msg):
            data = self.client.recv(30).decode("utf-8").split(' ')[1][:8]
            # print('Reg: ' + format(addr, '08x') + data)
            return data
        else:
            print("Client not connected")
            return False

    def setLeds(self, on):
        if on:
            self.writeReg(0x412F_0000, 0xf)
        else:
            self.writeReg(0x412F_0000, 0x0)

    def setIntIntrp(self, on):
        if on:
            self.writeReg(0x4133_0000, 0x4)
        else:
            self.writeReg(0x4133_0000, 0x0)

    def updateRssiOffset(self):
        self.rssiOffset[0] = self.rssiOffsetSpinBox_0.value()
        self.rssiOffset[1] = self.rssiOffsetSpinBox_1.value()
        self.rssiOffset[2] = self.rssiOffsetSpinBox_2.value()
        self.rssiOffset[3] = self.rssiOffsetSpinBox_3.value()

    def readRssi(self):
        chRssi = []
        for i in range(4):
            addr = 0x4134_0000 + i*0x10000
            rssiRegData = self.readReg(addr)
            if not rssiRegData == False:
                chRssiAcc = int('0x' + rssiRegData, 16)
                chRssi.append(chRssiAcc/16)
            else:
                return

        self.rssiLineEdit_0.setText(str(chRssi[0]))
        self.rssiLineEdit_1.setText(str(chRssi[1]))
        self.rssiLineEdit_2.setText(str(chRssi[2]))
        self.rssiLineEdit_3.setText(str(chRssi[3]))


class VideoThread(QThread):
    ImageUpdate = pyqtSignal(np.ndarray)
    def run(self):
        self.ThreadActive = True
        Capture = cv2.VideoCapture(0)
        while self.ThreadActive:
            ret, frame = Capture.read()
            if ret:
                Image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                FlippedImage = cv2.flip(Image, 1)
                # ConvertToQtFormat = QImage(Image.data, Image.shape[1], Image.shape[0], QImage.Format_RGB888)
                # Pic = ConvertToQtFormat.scaled(640, 480, Qt.KeepAspectRatio)
                self.ImageUpdate.emit(FlippedImage)
                time.sleep(1)

    def stop(self):
        self.ThreadActive = False
        self.quit()

if __name__ == "__main__":
    App = QtWidgets.QApplication(sys.argv)
    Root = myApp()
    Root.show()
    sys.exit(App.exec())