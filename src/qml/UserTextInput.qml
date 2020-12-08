import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3

TextField {
    id: userTextInput
    
    overwriteMode: false
    selectByMouse: true
    
    height: 30
    padding: 5
    color: root.text
    font.pixelSize: 12
    selectedTextColor: root.base
    selectionColor: root.accent
    
    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        opacity: enabled ? 1 : 0.3
        color: root.base
        border.color: userTextInput.focus ? root.accent : root.alternateBase
        border.width: 1
        baselineOffset: 21
        radius: root.radius
    }
}
