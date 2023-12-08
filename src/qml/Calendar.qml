import QtQuick 2.15
import QtCore
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item {
    anchors.fill: parent

    property int startTime: 7
    property int numHours: 16
    required property date currentDay
    property date firstDay: firstDayOfTheWeek()

    function firstDayOfTheWeek(){
        const weekday = currentDay.getDay()
        const offset = (weekday - 1) % 7
        const firstDayOfWeek = currentDay
        firstDayOfWeek.setDate(currentDay.getDate() - offset)
        return firstDayOfWeek
    }


    ListModel{
        id: daysOfTheWeek
        ListElement {day: qsTr("Lunedi")}
        ListElement {day: qsTr("Martedi")}
        ListElement {day: qsTr("Mercoledi")}
        ListElement {day: qsTr("Giovedi")}
        ListElement {day: qsTr("Venerdi")}
        ListElement {day: qsTr("Sabato")}
        ListElement {day: qsTr("Domenica")}
    }

    GridLayout{
        id: grid
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.fillHeight: true

        columns: 8
        rows: numHours + 1
        columnSpacing: 5
        rowSpacing: 5

        Repeater{
            model: numHours*7

            Rectangle{
                color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)
                Layout.fillWidth: true
                Layout.fillHeight: true

                width: (grid.width) / (grid.columns)

                Layout.column: (model.index % 7) + 1
                Layout.row: (model.index % numHours) + 1

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        console.log("day: " + daysOfTheWeek.get(model.index % 7).day + ", time: " + ((model.index % numHours) + startTime))
                        console.log("date: " + firstDay)
                    }
                }
            }
        }

        Repeater{
            model: daysOfTheWeek

            Text{
                Layout.column: model.index + 1
                Layout.row: 0
                Layout.columnSpan: 1

                color: model.index+1 === currentDay.getDay() ? Universal.accent : Universal.foreground
                text: model.day.substring(0,3)

                font.pixelSize: 30
                font.family: customFont.name
            }
        }

        Repeater{
            model: numHours

            Rectangle{
                Layout.fillHeight: true
                width: (grid.width) / (grid.columns) / 2

                color: Qt.transparent

                Text{
                    Layout.column: 0
                    Layout.row: model.index + 1
                    Layout.columnSpan: 1

                    color: Universal.foreground
                    text: (model.index + startTime) + ":00"

                    font.pixelSize: 20
                    font.family: customFont.name
                }
            }
        }

        Row{
            Layout.column: 0
            Layout.row: 0

            Button{
                text: "<"
            }
            Button{
                text: ">"
            }
        }
    }
}
