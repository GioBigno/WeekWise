import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

// popup of an existing hour (planned or logged)

Popup {
    id: selectLoggedPopup
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Universal.background
        border.color: Universal.background
        radius: 4
    }

    property date dateCell: new Date()
    property int activity_id: -1
    property string activity_name: ""
    property string note: ""
    property bool done: false

    property double buttonHeight: 30
    property color noteBackground: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)

    onOpened: {
        editNote.text = note;

        console.log("[popup] date: " + dateCell)
        console.log("[popup] note: " + note)
    }

    Text{
        id: titleActivityText

        anchors{
            top: parent.top
            left: parent.left
        }

        text: qsTr(selectLoggedPopup.activity_name)

        elide: Text.ElideRight
        color: Universal.foreground
        font.pointSize: 26
        font.family: fontMedium.name
    }

    Text{
        id: titleTimeText

        anchors{
            top: parent.top
            bottom: noteRect.top
            left: titleActivityText.right
            right: parent.right
        }

        text: qsTr(Qt.formatDateTime(selectLoggedPopup.dateCell, "dd/MM hh:mm"))

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        color: Universal.foreground
        font.pointSize: 18
        font.family: fontMedium.name
    }

    Rectangle{
        id: noteRect
        //height: selectLoggedPopup.noteHeight;
        color: selectLoggedPopup.noteBackground

        anchors {
            top: titleActivityText.bottom
            bottom: buttonSaveNote.top
            left: parent.left
            right: parent.right
            bottomMargin: selectLoggedPopup.padding
        }

        Flickable {
            id: flick
            contentWidth: editNote.paintedWidth
            contentHeight: editNote.paintedHeight
            clip: true
            interactive: true

            anchors.fill: parent
            anchors.margins: 5

            function ensureVisible(r){
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

            TextEdit {
                id: editNote
                width: flick.width
                focus: true
                selectByMouse: true
                selectByKeyboard: true
                wrapMode: TextEdit.Wrap
                color: Universal.accent
                font.pointSize: 12
                font.family: fontLight.font
                text: selectLoggedPopup.note

                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            }
        }
    }

    RoundButton{
        id: buttonSaveNote
        visible: true

        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        height: selectLoggedPopup.buttonHeight

        radius: 4
        padding: 10

        text: "Save Note"

        onClicked: {
            if(editNote.text !== selectLoggedPopup.note){
                //note edited
                selectLoggedPopup.note = editNote.text
                controller.addNoteLoggedHour(dateCell, selectLoggedPopup.note);
            }
        }
    }

    RoundButton{
        id: buttonDelete
        visible: true

        anchors {
            bottom: parent.bottom
            left: parent.left
        }

        height: selectLoggedPopup.buttonHeight

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
            left: buttonDelete.right
            leftMargin: selectLoggedPopup.padding
        }

        height: selectLoggedPopup.buttonHeight

        radius: 4
        padding: 10

        text: selectLoggedPopup.done === true ? "To do" : "Done";

        onClicked: {

            if(selectLoggedPopup.done === true) {
                controller.setPlannedHour(selectLoggedPopup.dateCell);
            }else{
                controller.setLoggedHour(selectLoggedPopup.dateCell);
            }

            selectLoggedPopup.close();
        }
    }
}
