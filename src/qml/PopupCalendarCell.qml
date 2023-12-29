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
        color: Universal.background
        border.color: Universal.background
        radius: 4
    }

    property int indexCell: -1

    ListView {
        id: listViewPopup
        anchors.fill: parent
        model: controller.getActivities()
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
                        controller.deleteLoggedHour(Qt.formatDateTime(dateFromIndex(selectActivityPopup.indexCell), "yyyy-MM-dd hh:mm:ss"));
                    }else{
                        controller.addLoggedHour(Qt.formatDateTime(dateFromIndex(selectActivityPopup.indexCell), "yyyy-MM-dd hh:mm:ss"), model.activity_id);
                    }

                    selectActivityPopup.close();
                    //weekView.weekTotalPlannedHoursChanged()
                }
            }
        }
    }
}
