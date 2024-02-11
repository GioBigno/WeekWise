import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

//popup to select the amount of hours of a new or an existing goal

Popup {
    id: popUpNewGoalDetail
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Universal.background
        border.color: Universal.background
        radius: 4
    }

    property int macroarea_id: -1
    property int numHours: hoursSpinBox.value

    function setStartValue(x){
        hoursSpinBox.value = x;
    }

    Text{
        id: textNumHours
        anchors {
            top: parent.top
            left:parent.left
        }

        text: qsTr("Hours:")

        color: Universal.foreground
        font.pointSize: 12
        font.family: customFont.name
    }

    SpinBox{
        id: hoursSpinBox

        anchors {
            top: parent.top
            right: parent.right
            left: textNumHours.right
        }

        background: Rectangle{
            color: "transparent"
        }

        font.pointSize: 15
        font.family: customFont.name

        from: 1
        to: 24*7
        value: 5

        onValueChanged: {
            numHours = value
        }
    }

    RoundButton{

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: parent.height / 3
            rightMargin: parent.height / 3
        }

        height: 30

        radius: 4

        background: Rectangle{
            anchors.fill: parent
            color: parent.hovered ? Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.6) :
                                    Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.4)
            radius: 4
        }

        text: qsTr("Confirm")
        font.pointSize: 12
        font.family: customFont.name

        onClicked: {
            if(popUpNewGoalDetail.macroarea_id === -1){
                console.log("error: trying to add macroarea_id=-1")
            }else{
                controller.addPlannedMacroareas(popUpNewGoalDetail.macroarea_id, numHours);
            }
            popUpNewGoalDetail.close();
        }
    }

}

