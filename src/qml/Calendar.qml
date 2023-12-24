import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

import Qt.labs.platform 1.0

Item {
    //anchors.fill: parent

    property int startTime: 7
    property int numHours: 16
    property string cellBackground: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)

    function dateFromIndex(indexCell){
        let d = weekView.firstDay
        let indexDay = indexCell % 7
        let indexHour = (indexCell / 7) + startTime
        let diffDay = d.getDate() + indexDay
        d.setDate(diffDay)
        d.setHours(indexHour)
        d.setMinutes(0)
        d.setSeconds(0)
        return new Date(d)
    }

    function openPopup(mouseX, mouseY, w){

        if(mouseX + selectActivityPopup.width > parent.width){
            mouseX -= selectActivityPopup.width
        }

        if(mouseY + selectActivityPopup.height > parent.height){
            mouseY -= selectActivityPopup.height
        }

        selectActivityPopup.x = mouseX
        selectActivityPopup.y = mouseY

        selectActivityPopup.width = w
        //selectActivityPopup.height = w*1.5

        selectActivityPopup.open()
    }

    function fillMacroareas(){
        let result = db.execute("SELECT * FROM macroareas;")
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            macroAreas.append({name: row.macroarea_name, color: "#"+row.macroarea_color})
        }
    }

    function fillActivities(){

        activities.append({activity_id: -1, name: "None", color: "gray"})

        let result = db.execute("SELECT a.activity_id, a.activity_name, m.macroarea_color
                          FROM activities a
                          JOIN macroareas m
                          ON a.macroarea_id = m.macroarea_id;")
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            activities.append({activity_id: row.activity_id, name: row.activity_name, color: "#"+row.macroarea_color})
        }
    }

    function fillWeekLoggedHours(){

        weekLoggedHours.clear()

        for(let day = 0; day<7; day++){
            for(let hour = 0; hour < numHours; hour++){
                weekLoggedHours.append({macroarea_color: cellBackground})
            }
        }

        let result = db.execute("SELECT lh.date_logged, lh.activity_id, ma.macroarea_color
                                 FROM logged_hours lh
                                 JOIN activities a ON lh.activity_id = a.activity_id
                                 JOIN macroareas ma ON a.macroarea_id = ma.macroarea_id
                                 WHERE lh.date_logged
                                 BETWEEN '" + Qt.formatDateTime(weekView.firstDay, "yyyy-MM-dd") +"'
                                 AND '" +  Qt.formatDateTime(weekView.lastDay, "yyyy-MM-dd") +"';")

        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            let date_logged = new Date(row.date_logged)

            if(date_logged.getHours() < startTime || date_logged.getHours() > startTime+numHours){
                continue;
            }

            let index = (date_logged.getDay()-1) + (7 * (date_logged.getHours()-startTime))
            weekLoggedHours.set(index, {macroarea_color: "#"+row.macroarea_color})
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
        //{name, color}
    }

    ListModel{
        id: activities
        //{activity_id, name, color}
    }

    ListModel{
        id: weekLoggedHours
        //{macroarea_color}
    }

    PopupCalendarCell{
        id: selectActivityPopup
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
            model: weekLoggedHours

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
                    hoverEnabled: true

                    onClicked: (mouse) => {
                        selectActivityPopup.indexCell = model.index
                        openPopup(rectHour.x + mouse.x, rectHour.y + mouse.y, rectHour.width)
                    }

                    onEntered: {
                        rectHour.opacity = 0.6
                    }

                    onExited: {
                        rectHour.opacity = 1
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

                color: {
                    if(Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd") === Qt.formatDateTime(currentDay, "yyyy-MM-dd")){
                       return Universal.accent
                    }else{
                       return Universal.foreground
                    }
                }

                text: model.day.substring(0,3) + "  " + (weekView.firstDay.getDate() + model.index)

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
                    //horizontalAlignment: Text.AlignHCenter
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
                width: 30
                height: 30

                background: Rectangle{color: "transparent"}

                IconImage{
                    anchors.fill: parent
                    source: "qrc:/icons/icons/arrow10.svg"
                    color: Universal.accent
                }

                onClicked: {
                    weekView.prevWeek()
                }
            }
            Button{
                width: 30
                height: 30

                background: Rectangle{color: "transparent"}

                IconImage{
                    anchors.fill: parent
                    source: "qrc:/icons/icons/arrow9.svg"
                    color: Universal.accent
                }

                onClicked: {
                    weekView.nextWeek()
                }
            }
        }
    }
}
