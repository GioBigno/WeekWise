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

    function lastDayOfTheWeek(day){

        var d = firstDayOfTheWeek(nextWeek(day))
        var diff = d.getDate() - 1
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

    function fillMacroareas(){
        let result = db.execute("SELECT * FROM macroareas;")
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            macroAreas.append({name: row.macroarea_name, color: "#"+row.macroarea_color})
        }
    }

    function fillActivities(){
        let result = db.execute("SELECT a.activity_name, m.macroarea_color
                          FROM activities a
                          JOIN macroareas m
                          ON a.macroarea_id = m.macroarea_id;")
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            activities.append({name: row.activity_name, color: "#"+row.macroarea_color})
        }
    }

    function fillWeekHours(){

        weekHours.clear()

        for(let day = 0; day<7; day++){
            for(let hour = 0; hour < numHours; hour++){
                weekHours.append({macroarea_color: "" + Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)})
            }
        }

        let result = db.execute("SELECT lh.date_logged, lh.activity_id, ma.macroarea_color
                                 FROM logged_hours lh
                                 JOIN activities a ON lh.activity_id = a.activity_id
                                 JOIN macroareas ma ON a.macroarea_id = ma.macroarea_id
                                 WHERE lh.date_logged
                                 BETWEEN '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") +"'
                                 AND '" +  Qt.formatDateTime(lastDayOfTheWeek(firstDay), "yyyy-MM-dd") +"';")

        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            let date_logged = new Date(row.date_logged)

            if(date_logged.getHours() < startTime || date_logged.getHours() > startTime+numHours){
                continue;
            }

            let index = (date_logged.getDay()-1) + (7 * (date_logged.getHours()-startTime))
            weekHours.set(index, {macroarea_color: "#"+row.macroarea_color})
        }
    }

    BDatabase{
        id: db
        databaseType: "QSQLITE"

        Component.onCompleted: {
            connect("weekwise.db")

            fillMacroareas()
            fillActivities()
            fillWeekHours()

            console.log("ultimo giorno: " + Qt.formatDateTime(lastDayOfTheWeek(firstDay), "yyyy-MM-dd"))
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
        ListElement {name: "None"; color:"gray"}
    }

    ListModel{
        id: weekHours
    }

    Popup {
        id: popup
        width: 200
        height: listViewPopup.contentHeight < width*1.5 ? listViewPopup.contentHeight+20 : width*1.5
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: Qt.rgba(Universal.background.r, Universal.background.g, Universal.background.b, 0.7)
            border.color: Universal.background
        }

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
                        console.log("activity: " + model.name)
                    }
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
            model: weekHours

            Rectangle{
                id: rectHour
                color: model.macroarea_color
                Layout.fillWidth: true
                Layout.fillHeight: true

                width: (grid.width) / (grid.columns)

                Layout.column: (model.index % 7) + 1
                Layout.row: model.index/7 + 1

                MouseArea{
                    anchors.fill: parent

                    onClicked: (mouse) => {
                        openPopup(rectHour.x + mouse.x, rectHour.y + mouse.y, rectHour.width)

                        //console.log("date: " + Qt.formatDateTime(firstDay, "yyyy-MM-dd"))
                        console.log("index: " + model.index)
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
                    fillWeekHours()
                }
            }
            Button{
                text: ">"

                onClicked: {
                    firstDay = nextWeek(firstDay)
                    fillWeekHours()
                }
            }
        }
    }
}
