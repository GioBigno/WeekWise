import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

Popup {
    id: selectLoggedPopup
    height: 100
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Universal.background
        border.color: Universal.background
        radius: 4
    }

    property string dateCell: ""
    property int activity_id: -1
    property bool done: false

    property double buttonHeight: 30
    property double buttonWidth: 50

    RoundButton{
        id: buttonDelete
        visible: true

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: selectLoggedPopup.buttonHeight
        width: selectLoggedPopup.buttonWidth

        radius: 4
        padding: 10

        text: "Delete"

        onClicked: {
            controller.deletePlannedHour(dateCell);

            selectLoggedPopup.close();
        }
    }

    RoundButton{
        id: buttonEdit
        visible: true

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: selectLoggedPopup.buttonHeight
        width: selectLoggedPopup.buttonWidth

        radius: 4
        padding: 10

        text: selectLoggedPopup.done === true ? "To do" : "Done";

        onClicked: {

            if(selectLoggedPopup.done === true) {
                controller.addPlannedHour(selectLoggedPopup.dateCell, selectLoggedPopup.activity_id);
            }else{
                controller.addLoggedHour(selectLoggedPopup.dateCell, selectLoggedPopup.activity_id);
            }

            selectLoggedPopup.close();
        }
    }
}
