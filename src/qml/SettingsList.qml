import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Timeline 1.0

Rectangle {
    color: root.base
    radius: root.radius

    property string inputSeperator: inputSeperator.text || inputSeperator.placeholderText
    property string inputDecimal: inputDecimal.text || inputDecimal.placeholderText
    property bool inputGenX: inputGenX.checked

    property string inputBPS: inputBPS.currentValue
    property string inputSamplerate: inputSamplerate.text || inputSamplerate.placeholderText
    property string inputMax: inputMax.text || inputMax.placeholderText
    property string inputBias: inputBias.text || inputBias.placeholderText
    property string inputClipping: inputClipping.currentValue
    property string inputInterpolation: inputInterpolation.currentValue
    property bool inputMultichannel: inputMultichannel.checked

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.bottomMargin: 15
        anchors.topMargin: 15
        
        
        GridLayout {
            id: gridLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            columnSpacing: 15
            rowSpacing: 8
            anchors.rightMargin: 25
            anchors.leftMargin: 0
            Layout.fillWidth: true
            columns: 3
            
            layoutDirection: Qt.LeftToRight
            
            Text {
                text: qsTr("Seperator")
                color: root.text
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserTextInput {
                id: inputSeperator
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                placeholderText: ";"
            }
            InfoButton {
                text: qsTr("Trennzeichen zwischen Werten")
            }
            
            
            Text {
                text: qsTr("Dezimalstelle")
                color: root.text
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserTextInput {
                id: inputDecimal
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                placeholderText: "."
            }
            InfoButton {
                text: qsTr("Zeichen gibt die Dezimalstelle an")
            }
            
            
            Text {
                text: qsTr("X-Achse erstellen")
                color: root.text
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserCheckbox {
                id: inputGenX
                rightPadding: 0
                leftPadding: 0
                bottomPadding: 0
                topPadding: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }      
            InfoButton {
                text: qsTr("Eigene X-Achse erstellen. Jedes Sample wird eine Sekunde gehalten.")
            }
                    
            
            Text {
                color: root.text
                text: qsTr("Bits pro Sample")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserComboBox {
                id: inputBPS
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                model: [ "u8", "16", "32", "32f" ]
                currentIndex: 1
            }
            InfoButton {
                text: qsTr("Bits in einem Sample. u8 ist unsigned. 32f ist floating point.")
            }
            
            
            Text {
                color: root.text
                text: qsTr("Samplerate")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserTextInput {
                id: inputSamplerate
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                placeholderText: "44100"
                validator: IntValidator { bottom:1 }
            }
            InfoButton {
                text: qsTr("Samplerate in Hz")
            }
            
            
            Text {
                color: root.text
                text: qsTr("Max Input")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserTextInput {
                id: inputMax
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                placeholderText: "None"
                validator: DoubleValidator {}
            }
            InfoButton {
                text: qsTr("Wert in der CSV der 100% ausgabe der wav entspricht. Bei None wird der größte Wert der Eingabe dafür genutzt.")
            }
            
            
            Text {
                color: root.text
                text: qsTr("DC Bias")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserTextInput {
                id: inputBias
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                placeholderText: "0.0"
                validator: DoubleValidator {}

            }
            InfoButton {
                text: qsTr("Wert der allen Samples hinzugefügt wird.")
            }
            
            
            Text {
                color: root.text
                text: qsTr("Clipping")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserComboBox {
                id: inputClipping
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                model: [ "hard", "soft" ]
                currentIndex: 0
            }
            InfoButton {
                text: qsTr("Methode mit der Daten geclipped werden.")
            }
            
            
            Text {
                color: root.text
                text: qsTr("Interpolation")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserComboBox {
                id: inputInterpolation
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                model: [ "nearest", "linear", "quadratic", "cubic" ]
                currentIndex: 1
            }
            InfoButton {
                text: qsTr("Methode um Sample zu interpolieren.")
            }
            
            
            Text {
                text: qsTr("Multichannel")
                color: root.text
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
            UserCheckbox {
                id: inputMultichannel
                rightPadding: 0
                leftPadding: 0
                bottomPadding: 0
                topPadding: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                
            }
            InfoButton {
                text: qsTr("Verschiedene Y-Achsen werden als weitere Kanäle hinzugefügt. Sonst seperate Dateien.")
            }
            
        }
    }
    
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
