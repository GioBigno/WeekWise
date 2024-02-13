import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

//popup to insert a new goal into sidestats

Popup {
    id: popUpNewGoal
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
        model: controller.getMacroareas()
        spacing: 10
        clip: true

        delegate: Rectangle {
            width: listViewPopup.width
            height: textActivityPopup.font.pointSize + 10
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

                font.pointSize: 12
                font.family: fontMedium.name
            }

            MouseArea{
                anchors.fill: parent

                onClicked: {
                    popupNewGoalDetail.macroarea_id = model.id;
                    popupNewGoalDetail.setStartValue(5);
                    popUpNewGoal.close();
                    popupNewGoalDetail.open();
                }
            }
        }
    }
}

