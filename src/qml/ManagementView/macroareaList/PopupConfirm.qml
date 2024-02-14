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

    property string button1Text
    property string button2Text
    property font fontText
    property string text
    property var button1Clicked
    property var button2Clicked

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

    RoundButton{
        id: button1
        visible: true

        anchors {
            bottom: parent.bottom
            right: button2.left
            margins: 10
        }

        height: 30

        radius: 4
        padding: 10
        highlighted: true

        text: popup.button1Text

        onClicked: {
            popup.button1Clicked();
        }
    }

    RoundButton{
        id: button2
        visible: true

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 10
        }

        height: 30

        radius: 4
        padding: 10

        text: popup.button2Text

        onClicked: {
            popup.button2Clicked();
        }
    }
}
