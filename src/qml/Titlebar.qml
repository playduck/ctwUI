import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14

Rectangle {
    id: titlebar
    required property string title
    required property var state

    color: "#00000000"

    // Titlebar double click maximizes/zooms window
    MouseArea {
        width: 400
        height: parent.height
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton) {
                switch (mainWindow.visibility) {
                    case Window.Windowed:
                        mainWindow.showMaximized()
                        break;
                    case Window.Maximized:
                        mainWindow.showNormal()
                        break;
                    default:
                        break;
                }
            }
            return false
        }
    }

    RowLayout {
        id: navLayout
        height: 26
        spacing: 15
        anchors.left: parent.left
        anchors.leftMargin: os === "darwin" ? 75 : 15
        // anchors.leftMargin: 75
        anchors.top: parent.top
        anchors.topMargin: 1.5

        Text {
            id: homeButton
            color: root.windowText
            text: qsTr("Home")
            font.pixelSize: 12
            opacity:  homeButtonArea.containsMouse ? 1 : 0.4
            smooth: homeButtonArea.containsMouse
            MouseArea {
                id: homeButtonArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: {
                    titlebar.state = home
                }
            }
        }

        Text {
            id: prefrencesButton
            color: root.windowText
            text: qsTr("Prefrences")
            font.pixelSize: 12
            opacity:  prefrencesButtonArea.containsMouse ? 1 : 0.4
            smooth: prefrencesButtonArea.containsMouse
            MouseArea {
                id: prefrencesButtonArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: {
                    titlebar.state = preferences
                }
            }
        }

        Text {
            id: aboutButton
            color: root.windowText
            text: qsTr("About")
            font.pixelSize: 12
            opacity:  aboutButtonArea.containsMouse ? 1 : 0.4
            smooth: aboutButtonArea.containsMouse
            MouseArea {
                id: aboutButtonArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: {
                    titlebar.state = about
                }
            }
        }
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 6
        Text {
            id: title
            color: root.windowText
            text: titlebar.title
            font.pixelSize: 13
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.Black
            opacity: 1
        }
    }

    // fancy title fade out, when title and static nav would overlap
    onWidthChanged: {
        let linearOffset = 10
        let slopeCoefficient = 0.05
        let navOffset = navLayout.width + navLayout.anchors.leftMargin
        let titleOffset = linearOffset + (mainWindow.width - title.width) / 2
        title.opacity = Math.atan(slopeCoefficient * (titleOffset - navOffset))
    }
}

/*##^##
Designer {
    D{i:0;height:24;width:800}
}
##^##*/
