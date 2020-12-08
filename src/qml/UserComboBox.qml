import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Timeline 1.0

ComboBox {
    id: control

    delegate: ItemDelegate {
            width: control.width

            background: Rectangle {
                color: control.highlightedIndex === index ? root.alternateBase : root.base
            }

            contentItem: Text {
                text: modelData
                color: root.text
                font: control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            //highlighted: control.highlightedIndex === index
        }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 8
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            if(control.down) {
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
            }   else    {
                context.moveTo(width, 0);
                context.lineTo(width, height);
                context.lineTo(0, height / 2);
            }
            context.closePath();
            context.fillStyle = control.pressed ? root.accent : root.alternateBase;
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 7
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: control.pressed ? root.accent: root.text
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 30

        color: root.base

        border.color: control.pressed ? root.accent : root.alternateBase
        border.width: control.visualFocus ? 2 : 1
        radius: root.radius
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: root.base
            border.color: root.accent
            radius: root.radius
        }
    }
}

/*##^##
Designer {
    D{i:0;height:32;width:120}
}
##^##*/
