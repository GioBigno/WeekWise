import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

Item{
    id: bProgressBarItem

    required property color backgroundColor
    required property color fillColor
    required property color borderColor
    required property int borderWidth
    required property int radius
    required property real progress

    //background
    Rectangle{
        z: 0
        anchors.fill: parent
        antialiasing: true

        gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: bProgressBarItem.progress -0.4; color: bProgressBarItem.fillColor }
                GradientStop { position: bProgressBarItem.progress != 0 ? (bProgressBarItem.progress + 0.1) : 0; color:  bProgressBarItem.backgroundColor}
        }

        color: bProgressBarItem.backgroundColor
        radius: bProgressBarItem.radius
    }

    //fill
    Rectangle{
        z: 1
        width: parent.width * bProgressBarItem.progress
        height: parent.height
        antialiasing: true

        color: bProgressBarItem.fillColor
        radius: bProgressBarItem.radius
    }

    //border
    Rectangle{
        z: 2
        anchors.fill: parent
        antialiasing: true

        color: "transparent"
        radius: bProgressBarItem.radius

        border.color: bProgressBarItem.borderColor
        border.width: bProgressBarItem.borderWidth
    }
}
