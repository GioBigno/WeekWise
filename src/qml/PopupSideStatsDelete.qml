import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12


Popup {
    id: deleteBarPopup
    width: text.contentWidth * 1.5
    height: implicitHeight
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Qt.rgba(Universal.background.r, Universal.background.g, Universal.background.b, 0.7)
        border.color: Universal.background
        radius: 4
    }



    MouseArea{
        anchors.fill: parent

        onClicked: {

            //weekLoggedHours.set(selectActivityPopup.indexCell, {macroarea_color: cellBackground})

            //db.execute("DELETE FROM logged_hours
            //                WHERE date_logged = '" + Qt.formatDateTime(dateFromIndex(selectActivityPopup.indexCell), "yyyy-MM-dd hh:mm:ss") + "';")


            selectActivityPopup.close()
            //weekView.weekTotalPlannedHoursChanged()
        }
    }

}

