import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3

Item {
    id: contentPage
    implicitHeight: 30

    required property string title

    Text {
        id: header
        text: parent.title
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 24
        font.bold: true
        anchors.topMargin: 0
        anchors.leftMargin: 15
        color: root.text
    }

    Rectangle {
        id: rectangle
        height: root.divider
        color: root.accent
        border.color: "#00000000"
        radius: root.radius
        anchors.left: header.right
        anchors.right: parent.right
        anchors.bottom: header.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 15
        anchors.leftMargin: 5
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
