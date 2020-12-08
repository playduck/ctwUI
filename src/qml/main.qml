import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Timeline 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    color: root.window
    width: 360
    height: 700
    minimumWidth: 300
    minimumHeight: 300

    /*
    Timeout {
        id: delayTimer
    }
    Timeout {
        id: renderIntervalTimer
    }
    */

    // SystemPalette { id: style; colorGroup: SystemPalette.Active }

    SystemPalette {
        id: root
        colorGroup: SystemPalette.Active

        property color accent: "#5856D6"

        property int radius: 5
        property int divider: 2
    }

    MouseArea {
        // disable focus, when clicking anywhere else
        anchors.fill: parent
        z: -100
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            this.forceActiveFocus()
        }

    }

    Titlebar {
        id: titlebar
        height: 24
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        title: qsTr("ctw")
        state: home
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titlebar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 10

        DropArea {
            anchors.fill: parent

            onDropped: {
                if(drop.hasUrls && drop.urls.length === 1)  {
                    inputFile.file = drop.urls[0]
                    drop.accept()
                }   else    {
                    drop.cancel()
                }
            }
            onEntered: {
                if(drop.hasUrls && drop.urls.length === 1)  {
                    return // valid drop, do nothing
                }   else    {
                    drag.cancel()
                }
            }
        }

        ContentPage {
            id: home
            visible: titlebar.state === this
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            title: qsTr("Home")

            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                anchors.margins: 15
                spacing: 15
                anchors.topMargin: 40


                FileSelect {
                    id: inputFile

                    Layout.fillWidth: true

                    placeholder: qsTr("csv file")
                    suffix: "csv"

                    onFileChanged: {
                        if(!valid)
                            return
                        outputFile.file = file.replace(/(csv)$/,"wav")
                    }
                }

                FileSelect {
                    id: outputFile

                    Layout.fillWidth: true

                    enabled: inputFile.valid
                    placeholder: qsTr("wav file")
                    suffix: "wav"

                    selectExisting: false
                }

                Rectangle {
                    height: root.divider
                    color: root.accent
                    radius: root.radius
                    border.color: "#00000000"
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }

                SettingsList {
                    id: settings
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip: true
                }

                UserButton {
                    id: userButton
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom

                    text: qsTr("Konvertieren")

                    onClicked: {
                        waitingPopup.open()
                        waitingPopup.forceActiveFocus()
                    }
                }



                Popup {
                    id: waitingPopup
                    modal: true
                    dim: true
                    focus: true
                    closePolicy: Popup.CloseOnEscape

                    anchors.centerIn: parent
                    padding: 10
                    background: Rectangle {
                        color: root.dark
                        radius: root.radius
                    }

                    onAboutToShow: {
                        busyIndicator.running = true
                        busyText.text = "konvertierung läuft..."

                        let data = {
                            "inputSeperator": settings.inputSeperator,
                            "inputDecimal": settings.inputDecimal,
                            "inputGenX": settings.inputGenX,

                            "inputBPS": settings.inputBPS,
                            "inputSamplerate": settings.inputSamplerate,
                            "inputMax": settings.inputMax,
                            "inputBias": settings.inputBias,
                            "inputClipping": settings.inputClipping,
                            "inputInterpolation": settings.inputInterpolation,
                            "inputMultichannel": settings.inputMultichannel,

                            "inputFile": inputFile.file,
                            "outputFile": outputFile.file,
                        }
                        bridge.convertAction(data)
                    }
                    Component.onCompleted: {
                        popupTimer.callback = waitingPopup.close
                        bridge.onConversionDone.connect((ret) => {
                            console.log("RETURNCODE", ret)
                            if(ret != 0)    {
                                busyText.text = "Ein Fehler ist Aufgetreten!"
                            }   else    {
                                busyText.text = "Konvertierung abgeschlossen!"
                            }

                            busyIndicator.running = false
                            popupTimer.running = true
                        })
                    }

                    Timer {
                        id: popupTimer
                        running: false
                        repeat: false
                        interval: 3500

                        property var callback
                        onTriggered: callback()
                    }

                    ColumnLayout {
                        anchors.fill: parent

                        BusyIndicator {
                            id: busyIndicator
                            Layout.fillWidth: true

                            contentItem: Item {
                                implicitWidth: 64
                                implicitHeight: 64

                                Item {
                                    id: item
                                    x: parent.width / 2 - 32
                                    y: parent.height / 2 - 32
                                    width: 64
                                    height: 64
                                    opacity: busyIndicator.running ? 1 : 0

                                    Behavior on opacity {
                                        OpacityAnimator {
                                            duration: 250
                                        }
                                    }

                                    RotationAnimator {
                                        target: item
                                        running: busyIndicator.visible && busyIndicator.running
                                        from: 0
                                        to: 360
                                        loops: Animation.Infinite
                                        duration: 1250
                                    }

                                    Repeater {
                                        id: repeater
                                        model: 6

                                        Rectangle {
                                            x: item.width / 2 - width / 2
                                            y: item.height / 2 - height / 2
                                            implicitWidth: 10
                                            implicitHeight: 10
                                            radius: 5
                                            color: root.accent
                                            transform: [
                                                Translate {
                                                    y: -Math.min(item.width, item.height) * 0.5 + 5
                                                },
                                                Rotation {
                                                    angle: index / repeater.count * 360
                                                    origin.x: 5
                                                    origin.y: 5
                                                }
                                            ]
                                        }
                                    }
                                }
                            }
                        }

                        Text {
                            id: busyText
                            text: "konvertierung läuft..."
                            Layout.fillWidth: true
                        }
                    }
                }


            }
        }

        ContentPage {
            id: preferences
            visible: titlebar.state === this
            anchors.fill: parent
            title: qsTr("Preferences")

            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                anchors.margins: 15
                spacing: 15
                anchors.topMargin: 40

                Component.onCompleted: {
                    preferencesBinPath.file = bridge.binary
                    preferencesLogPath.file = bridge.logfile
                }


                FileSelect {
                    id: preferencesBinPath
                    Layout.fillWidth: true

                    placeholder: qsTr("ctw binary")
                    suffix: ""

                    selectExisting: true

                    onFileChanged: bridge.setBinary(file)
                }
                Text {
                    text: qsTr("Wenn kein Pfad zur Binary angegeben wird, wird die binary erst im gleichen Verzeichniss gesucht, dannch über die Path Variable.")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    color: root.text
                    opacity: 0.7
                }

                Rectangle {
                    height: root.divider
                    color: root.accent
                    radius: root.radius
                    border.color: "#00000000"
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }


                FileSelect {
                    id: preferencesLogPath
                    Layout.fillWidth: true

                    placeholder: qsTr("log file")
                    suffix: "log"

                    selectExisting: false
                    onFileChanged: bridge.setLog(file)
                }
                Text {
                    text: qsTr("Der Output von ctw wird in die log Datei geschrieben, wird keine angegeben, wird der Output nicht gespeichert.")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    color: root.text
                    opacity: 0.7
                }

            }
        }

        ContentPage {
            id: about
            visible: titlebar.state === this
            anchors.fill: parent
            title: qsTr("About")

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter

                spacing: 0
                anchors.margins: 50
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    color: root.accent
                    text: qsTr("CTW")
                    Layout.fillWidth: true
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 32
                }

                Text {
                    color: root.text
                    text: qsTr("csv to wav")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.italic: true
                    font.pixelSize: 12
                }

                Text {
                    color: root.text
                    text: qsTr("von robin prillwitz 2020")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    font.pixelSize: 12
                }

                TextArea {
                    text: qsTr("using:\n - PyQt\n -QML \n - Python 3.9\n - Stackoverflow <3 ")
                    horizontalAlignment: Text.AlignLeft
                    hoverEnabled: false
                    placeholderTextColor: "#00000000"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    textFormat: Text.MarkdownText
                    font.pixelSize: 12
                    Layout.fillWidth: false
                    color: root.text
                    readOnly: true
                }
            }
        }
    }
}
