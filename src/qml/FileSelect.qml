import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3

Item {
    id: fileSelect
    required property string placeholder
    required property string suffix
    property bool selectExisting: true

    property bool valid: false
    property bool enabled: true

    property string file: ""
    onFileChanged: {
        file = file.replace(/^(file:\/\/)/,"");

        console.log(suffix, "changed", file)
        if(file == "")  {
            valid = false
        }   else    {
            valid = true // maybe perfom more validation
        }
    }

    implicitHeight: 50

    UserTextInput {
        id: userTextInput

        enabled: fileSelect.enabled
        placeholderText: fileSelect.placeholder
        text: fileSelect.file

        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.top: title.bottom
        anchors.topMargin: 5

        onEditingFinished: {
            fileSelect.file = this.text
        }
    }

    UserButton {
        id: button

        anchors.bottom: userTextInput.bottom
        anchors.bottomMargin: 0
        anchors.left: userTextInput.right
        anchors.leftMargin: 10

        text: qsTr("Select")
        onClicked: fileDialog.open()
        enabled: fileSelect.enabled
    }


    FileDialog {
        id: fileDialog
        title: qsTr("Choose Input File")

        selectExisting: fileSelect.selectExisting
        nameFilters: [ fileSelect.suffix != "" ? fileSelect.placeholder + " (*."+fileSelect.suffix+")" : "*" , "All Files (*)"]
        defaultSuffix: fileSelect.suffix || "*"
        folder: shortcuts.documents

        onAccepted: {
            fileSelect.file = fileDialog.fileUrls.toString()
        }
    }

    Text {
        id: title
        color: root.text
        text: fileSelect.placeholder
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 12
        anchors.topMargin: 0
        anchors.leftMargin: 9
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";height:0;width:570}
}
##^##*/
