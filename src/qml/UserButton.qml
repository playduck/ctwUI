import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3

Button {
    id: button
    
    contentItem: Text {
        text: button.text
        font: button.font
        opacity: enabled ? 1.0 : 0.3
        color: button.hovered ? root.highlightedText : root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        implicitWidth: 60
        implicitHeight: 30
        opacity: enabled ? 1 : 0.3
        color: button.hovered ? root.accent : root.button
        border.color: button.down ? root.accent : root.alternateBase
        border.width: 1
        radius: root.radius
    }
}
