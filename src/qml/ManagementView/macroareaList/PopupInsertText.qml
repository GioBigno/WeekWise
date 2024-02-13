import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

Popup {
    id: popup

    padding: 0
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Universal.background
        border.color: Universal.background
        radius: 2
    }

    property string text
    property font fontText
    property var callback

    Text{
        id: text
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 20
        }

        wrapMode: Text.Wrap

        text: popup.text
        color: Universal.accent
        font.family: popup.fontText
        font.pointSize: 12
    }

    Rectangle{

        anchors {
            top: text.bottom
            left: parent.left
            right: parent.right
            topMargin: 20
            leftMargin: 30
            rightMargin: 30
        }

        height: 30
        color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)


        TextInput {
            id: input

            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            focus: true
            selectByMouse: true
            clip: true
            color: Universal.accent
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 12
            font.family: fontLight.font
        }
    }

    RoundButton{
        id: buttonSave
        visible: true

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 15
        }

        height: 30

        radius: 4
        padding: 10

        text: "Save"

        onClicked: {
            if(input.text !== ""){
                callback(input.text.trim());
                popup.close();
            }
        }
    }
}
