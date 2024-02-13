import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

Rectangle{
    id: element
    color: "transparent"

    required property string iconSource
    required property string textContent
    required property color textColor
    required property color hoveredColor

    IconImage{
        id: icon

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 3
        }

        width: element.height
        height: element.height

        source: element.iconSource
        color: element.textColor
    }

    Text{

        anchors{
            top: parent.top
            bottom: parent.bottom
            left: icon.right
            right: parent.right
            margins: 5
        }

        verticalAlignment: Text.AlignVCenter

        text: textContent
        color: textColor
        font.pointSize: height
        font.family: fontLight.font
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: element.color = hoveredColor
        onExited: element.color = "transparent"

        onClicked: (mouse) => {
            element.clicked(mouse);
        }
    }

}
