import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Timeline 1.0

CheckBox {
    id: control
    implicitWidth: 31
    implicitHeight: 31

    indicator: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: root.radius
        color: root.base
        border.color: control.down ? root.accent : root.alternateBase

        Rectangle {
            width: 16
            height: 16
            x: 7
            y: 7
            radius: root.radius
            color: control.down ? root.accent : root.alternateBase
            visible: control.checked
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:4;height:42;width:50}
}
##^##*/
