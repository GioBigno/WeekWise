import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Popup {
    id: popUpNewGoalDetail
    width: 200
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

    ColumnLayout{
        anchors.fill: parent

        RowLayout{
            id: rowLayout
            height: implicitHeight
            width: parent.width

            Text{
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                text: qsTr("Hours:")

                color: Universal.foreground
                font.pixelSize: 30
                font.family: customFont.name
            }

            SpinBox{
                id: hoursSpinBox
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                background: Rectangle{
                    color: "transparent"
                }

                font.pixelSize: 25
                font.family: customFont.name

                from: 1
                to: 24*7
                value: 5

                onValueChanged: {
                    numHours = value
                }
            }
        }

        RoundButton{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            implicitHeight: 30
            radius: 4

            background: Rectangle{
                anchors.fill: parent
                color: parent.hovered ? Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.6) :
                                        Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.4)
                radius: 4
            }

            text: qsTr("Confirm")
            font.pixelSize: 23
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
}

