import QtQuick 2.15
import QtCore
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

import BDatabase

Item {
    anchors.fill: parent

    property int startTime: 7
    property int numHours: 16
    required property date currentDay
    property date firstDay: firstDayOfTheWeek(currentDay)
    property int popupPosX: 0
    property int popupPosy: 0

    function firstDayOfTheWeek(day){

        var d = day
        var weekday = d.getDay()
        var diff = d.getDate() - weekday + 1
        return new Date(d.setDate(diff))
    }

    function nextWeek(day){

        var d = day
        return new Date(d.getTime() + 7 * 24 * 60 * 60 * 1000);
    }

    function prevWeek(day){
        var d = day
        return new Date(d.getTime() - 7 * 24 * 60 * 60 * 1000);
    }

    function openPopup(mouseX, mouseY, w){


        if(mouseX + popup.width > parent.width){
            mouseX -= popup.width
        }

        if(mouseY + popup.height > parent.height){
            mouseY -= popup.height
        }

        popup.x = mouseX
        popup.y = mouseY

        popup.width = w
        //popup.height = w*1.5

        popup.open()
    }

    BDatabase{
        id: db

        Component.onCompleted: {
            connect("dbconfig.ini")

            let result = execute("SELECT * FROM macroareas;")
            for (var i = 0; i < result.length; ++i) {
                var row = result[i];
                console.log("ID:", row.macroarea_id, "color:", row.macroarea_color);
                macroAreas.append({name: row.macroarea_name, color: "#"+row.macroarea_color})
            }

            result = execute("SELECT a.activity_name, m.macroarea_color
                              FROM activities a
                              JOIN macroareas m
                              ON a.macroarea_id = m.macroarea_id;")
            for (i = 0; i < result.length; ++i) {
                row = result[i];
                console.log("name:", row.activity_name, "m_color:", row.macroarea_color);
                activities.append({name: row.activity_name, color: "#"+row.macroarea_color})
            }
        }
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

    ListModel{
        id: macroAreas
    }

    ListModel{
        id: activities
    }

    Popup {
        id: popup
        width: 200
        height: listViewPopup.contentHeight < width*1.5 ? listViewPopup.contentHeight+20 : width*1.5
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

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
            }
        }
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
                id: rectHour
                color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)
                Layout.fillWidth: true
                Layout.fillHeight: true

                width: (grid.width) / (grid.columns)

                Layout.column: (model.index % 7) + 1
                Layout.row: (model.index % numHours) + 1

                MouseArea{
                    anchors.fill: parent

                    onClicked: (mouse) => {
                        openPopup(rectHour.x + mouse.x, rectHour.y + mouse.y, rectHour.width)
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
                text: model.day.substring(0,3) + "  " + (firstDay.getDate() + model.index)

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
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

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

                onClicked: {
                    firstDay = prevWeek(firstDay)
                }
            }
            Button{
                text: ">"

                onClicked: {
                    firstDay = nextWeek(firstDay)
                }
            }
        }
    }
}
