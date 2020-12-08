import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14

// shameless rip from:
// https://github.com/219-design/qt-qml-project-template-with-ci/blob/4832d8b3dcd7ee1320f932d91e4abb6a53e10f0d/src/lib/qml/ImageSvgHelper.qml

// (apparently because constantly resizing an SVG would be expensive in an app
// that allows a user to resize the screen at any time...) QML has made an
// "interesting" (at times annoying) choice to first render an SVG to
// essentially create a PNG from it, and then AFTER THAT only this PNG is scaled,
// which means IT WILL SCALE INTO A PIXELATED JAGGED MESS, which is the opposite
// of what you expect from an SVG!
// https://forum.qt.io/topic/52161/properly-scaling-svg-images/5
Image {
    // Thanks to this hack, qml can now only DOWN-SCALE/SHRINK the SVG, which won't cause blurriness/pixelation
    property real ratio: hiddenImg.sourceSize.width / hiddenImg.sourceSize.height
    // fillMode: Image.PreserveAspectFit
    sourceSize: Qt.size(
        // first "trick" qml that the SVG is larger than we EVER NEED
        // Math.max(hiddenImg.sourceSize.width, 300 * ratio),
        // Math.max(hiddenImg.sourceSize.height, 300
        300,300
    )

    Image {
        id: hiddenImg
        source: parent.source
        width: 0
        height: 0
    }
}
