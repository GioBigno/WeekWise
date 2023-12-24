import QtQuick 2.15

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

        color: bProgressBarItem.backgroundColor
        radius: bProgressBarItem.radius
    }

    //fill
    Rectangle{
        z: 1
        width: parent.width * bProgressBarItem.progress
        height: parent.height

        color: bProgressBarItem.fillColor
        radius: bProgressBarItem.radius
    }

    //border
    Rectangle{
        z: 2
        anchors.fill: parent

        color: "transparent"
        radius: bProgressBarItem.radius

        border.color: bProgressBarItem.borderColor
        border.width: bProgressBarItem.borderWidth
    }
}
