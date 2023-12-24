import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

Popup {
    id: selectActivityPopup
    width: 200
    height: listViewPopup.contentHeight < width*1.5 ? listViewPopup.contentHeight+20 : width*1.5
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Qt.rgba(Universal.background.r, Universal.background.g, Universal.background.b, 0.7)
        border.color: Universal.background
        radius: 4
    }

    property int indexCell: -1

    ListView {
        id: listViewPopup
        anchors.fill: parent
        model: activities
        spacing: 10
        clip: true

        delegate: Rectangle {
            width: listViewPopup.width
            height: textActivityPopup.font.pixelSize + 10
            radius: 3
            color: model.color

            Text {
                id: textActivityPopup
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 5
                }
                width: parent.width
                clip: true
                text: model.name

                font.pixelSize: 25
                font.family: customFont.name
            }

            MouseArea{
                anchors.fill: parent

                onClicked: {

                    if(model.activity_id === -1){
                        weekLoggedHours.set(selectActivityPopup.indexCell, {macroarea_color: cellBackground})

                        db.execute("DELETE FROM logged_hours
                                    WHERE date_logged = '" + Qt.formatDateTime(dateFromIndex(selectActivityPopup.indexCell), "yyyy-MM-dd hh:mm:ss") + "';")

                    }else{
                        weekLoggedHours.set(selectActivityPopup.indexCell, {macroarea_color: model.color})

                        db.execute("INSERT OR REPLACE INTO logged_hours (activity_id, date_logged)
                                    VALUES (" + model.activity_id + ", '" + Qt.formatDateTime(dateFromIndex(selectActivityPopup.indexCell), "yyyy-MM-dd hh:mm:ss") +"');")
                    }

                    selectActivityPopup.close()
                    weekView.weekTotalPlannedHoursChanged()
                }
            }
        }
    }
}
