import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item {
    id: calendar

    property int startTime: 7
    property int numHours: 16
    property int calendarRows: numHours+1
    property int calendarColumns: 8
    property string cellBackground: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)
    property double cellPreferredWidth: ((width - (calendarColumns * 4)) / calendarColumns)
    property double cellPreferredHeight: ((height - (calendarRows *4)) / calendarRows)

    function dateFromIndex(indexCell){
        let d = new Date(controller.firstDay);
        let indexDay = indexCell % 7;
        let indexHour = Math.trunc(indexCell / 7) + startTime;

        for(let i=0; i<indexDay; i++)
            d = controller.nextDay(d);

        d.setHours(indexHour);
        d.setMinutes(0);
        d.setSeconds(0);
        d.setMilliseconds(0);
        return new Date(d);
    }

    function openPopup(popup, mouseX, mouseY, w){

        popup.width = w;

        if(mouseX + popup.width > width){
            mouseX -= popup.width;
        }

        if(mouseY + popup.height > height){
            mouseY -= popup.height;
        }

        popup.x = mouseX;
        popup.y = mouseY;

        popup.open();
    }

    function weekPlannedLoggedHoursChanged(){
        cellsHours.clear();

        for(let day = 0; day<7; day++){
            for(let hour = 0; hour < numHours; hour++){
                cellsHours.append({activity_id: -1, activity_name: "", macroarea_color: cellBackground, note: "", done: false});
            }
        }

        let result = controller.getWeekPlannedLoggedHours()
        for (let i = 0; i < result.count; ++i) {
            let row = result.get(i);
            let date_logged = new Date(row.date_logged);

            if(date_logged.getHours() < startTime || date_logged.getHours() > startTime+numHours){
                continue;
            }

            let day = date_logged.getDay()-1
            if(day < 0)
                day = 6;
            let index = (day) + (7 * (date_logged.getHours()-startTime));
            cellsHours.set(index, {activity_id: row.activity_id, activity_name: row.activity_name, macroarea_color: row.macroarea_color, note: row.note, done: row.done});
        }
    }

    Component.onCompleted: {
        weekPlannedLoggedHoursChanged()
    }

    ListModel{
        id: daysOfTheWeek
        ListElement {day: qsTr("Monday")}
        ListElement {day: qsTr("Tuesday")}
        ListElement {day: qsTr("Wednesday")}
        ListElement {day: qsTr("Thursday")}
        ListElement {day: qsTr("Friday")}
        ListElement {day: qsTr("Saturday")}
        ListElement {day: qsTr("Sunday")}
    }

    ListModel{
        id: cellsHours
        //{activity_id, activity_name, macroarea_color, note, done}
    }

    PopupNewHour{
        id: newHourPopup
    }

    PopupLoggedHour{
        id: selectLoggedPopup
    }

    GridLayout{
        id: grid
        anchors.fill: parent

        columns: calendar.calendarColumns
        rows: calendar.calendarRows
        columnSpacing: 4
        rowSpacing: 4

        Repeater{
            model: cellsHours

            Rectangle{
                id: rectHour

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: calendar.cellPreferredWidth

                Layout.column: (model.index % 7) + 1
                Layout.row: model.index/7 + 1

                property color cellColor: (model.done || activity_id === -1) ? model.macroarea_color : Qt.color(model.macroarea_color).darker()

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: cellColor }
                    GradientStop { position: 2; color: cellBackground }
                }
                smooth: true

                Text{
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    //horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: model.activity_name
                    clip: true
                    elide: Text.ElideRight
                    color: Universal.background

                    font.pointSize: 14
                    font.family: fontMedium.name
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: (mouse) => {

                                if(model.activity_id === -1){
                                    newHourPopup.dateCell = Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd hh:mm:ss");
                                    openPopup(newHourPopup, rectHour.x + mouse.x + 1, rectHour.y + mouse.y, rectHour.width*1.5);
                                }else{
                                    selectLoggedPopup.dateCell = Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd hh:mm:ss");
                                    selectLoggedPopup.activity_id = model.activity_id;
                                    selectLoggedPopup.activity_name = model.activity_name;
                                    selectLoggedPopup.done = model.done;
                                    selectLoggedPopup.note = model.note;
                                    selectLoggedPopup.height = calendar.height / 2;
                                    selectLoggedPopup.width = calendar.width / 2;
                                    selectLoggedPopup.x = calendar.width / 4;
                                    selectLoggedPopup.y = calendar.height / 4;
                                    selectLoggedPopup.open();
                                }
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
                Layout.fillWidth: true
                //Layout.fillHeight: true
                Layout.preferredWidth: calendar.cellPreferredWidth / 2

                Layout.column: model.index + 1
                Layout.row: 0

                elide: Text.ElideRight

                color: {
                    if(Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd") === Qt.formatDateTime(controller.currentDay, "yyyy-MM-dd")){
                        return Universal.accent
                    }else{
                        return Universal.foreground
                    }
                }

                text: model.day.substring(0,3) + "  " + (dateFromIndex(model.index).getDate())

                font.pixelSize: 22
                font.family: fontMedium.name
            }
        }

        Repeater{
            model: numHours

            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.column: 0
                Layout.row: model.index + 1

                Layout.preferredWidth: textHours.implicitWidth
                Layout.preferredHeight: calendar.cellPreferredHeight

                color: "transparent"

                Text{
                    id: textHours
                    anchors.fill: parent
                    //horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    elide: Text.ElideRight
                    color: Universal.foreground
                    text: (model.index + startTime) + ":00"

                    font.pixelSize: 15
                    font.family: fontMedium.name
                }
            }
        }

        Rectangle{
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.column: 0
            Layout.row: 0

            // same of textHour
            Layout.preferredWidth: calendar.cellPreferredWidth / 8
            Layout.preferredHeight: calendar.cellPreferredHeight

            color: "transparent"

            property double buttonDim: width < height ? width/2 : height/2

            Button{

                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

                width: parent.buttonDim

                background: Rectangle{color: "transparent"}

                IconImage{
                    anchors.fill: parent
                    source: "qrc:/icons/arrow10.svg"
                    color: Universal.accent
                }

                onClicked: {
                    controller.prevWeek()
                }
            }
            Button{

                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                width: parent.buttonDim

                background: Rectangle{color: "transparent"}

                IconImage{
                    anchors.fill: parent
                    source: "qrc:/icons/arrow9.svg"
                    color: Universal.accent
                }

                onClicked: {
                    controller.nextWeek()
                }
            }
        }
    }
}
