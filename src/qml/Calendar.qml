import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item {
    id: calendar
    //anchors.fill: parent

    property int startTime: 7
    property int numHours: 16
    property string cellBackground: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)

    function dateFromIndex(indexCell){
        let d = controller.firstDay;
        let indexDay = indexCell % 7;
        let indexHour = (indexCell / 7) + startTime;
        let diffDay = d.getDate() + indexDay;
        d.setDate(diffDay);
        d.setHours(indexHour);
        d.setMinutes(0);
        d.setSeconds(0);
        return new Date(d);
    }

    function openPopup(mouseX, mouseY, w){

        if(mouseX + selectActivityPopup.width > parent.width){
            mouseX -= selectActivityPopup.width;
        }

        if(mouseY + selectActivityPopup.height > parent.height){
            mouseY -= selectActivityPopup.height;
        }

        selectActivityPopup.x = mouseX;
        selectActivityPopup.y = mouseY;

        selectActivityPopup.width = w;
        //selectActivityPopup.height = w*1.5

        selectActivityPopup.open();
    }

    function weekLoggedHoursChanged(){
        cellsHours.clear();

        for(let day = 0; day<7; day++){
            for(let hour = 0; hour < numHours; hour++){
                cellsHours.append({activity_name: "", macroarea_color: cellBackground});
            }
        }

        let result = controller.getWeekLoggedHours()
        for (let i = 0; i < result.count; ++i) {
            let row = result.get(i);
            let date_logged = new Date(row.date_logged);

            if(date_logged.getHours() < startTime || date_logged.getHours() > startTime+numHours){
                continue;
            }

            let index = (date_logged.getDay()-1) + (7 * (date_logged.getHours()-startTime));
            cellsHours.set(index, {activity_name: row.activity_name, macroarea_color: row.macroarea_color});
        }
    }

    Component.onCompleted: {
        weekLoggedHoursChanged()
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
        //{activity_name, macroarea_color}
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
        columnSpacing: 3
        rowSpacing: 3

        Repeater{
            model: cellsHours

            Rectangle{
                id: rectHour
                color: model.macroarea_color
                Layout.fillWidth: true
                Layout.fillHeight: true

                width: (grid.width) / (grid.columns)

                Layout.column: (model.index % 7) + 1
                Layout.row: model.index/7 + 1

                Text{
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    //horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: model.activity_name
                    clip: true
                    elide: Text.ElideRight
                    color: Universal.background

                    font.pixelSize: parent.height * 0.6
                    font.family: customFont.name
                }

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
                elide: Text.ElideRight

                color: {
                    if(Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd") === Qt.formatDateTime(controller.currentDay, "yyyy-MM-dd")){
                       return Universal.accent
                    }else{
                       return Universal.foreground
                    }
                }

                text: model.day.substring(0,3) + "  " + (controller.firstDay.getDate() + model.index)

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
                    controller.prevWeek()
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
                    controller.nextWeek()
                }
            }
        }
    }
}
