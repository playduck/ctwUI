import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Timeline 1.0

Image {
    required property string text
    source: "../icons/icons8-help-96.png"

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    fillMode: Image.PreserveAspectFit
    sourceSize.width: 20
    sourceSize.height: 20

    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
    
    ToolTip {
        parent: parent
        visible: mouseArea.containsMouse
        text: parent.text
    }
}
