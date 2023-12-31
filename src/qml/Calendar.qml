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
        let diffDay = d.getDate() + indexDay;
        d.setDate(diffDay);
        d.setHours(indexHour);
        d.setMinutes(0);
        d.setSeconds(0);
        return new Date(d);
    }

    function openPopup(mouseX, mouseY, w){

        selectActivityPopup.width = w;

        if(mouseX + selectActivityPopup.width > parent.width){
            mouseX -= selectActivityPopup.width;
        }

        if(mouseY + selectActivityPopup.height > parent.height){
            mouseY -= selectActivityPopup.height;
        }

        selectActivityPopup.x = mouseX;
        selectActivityPopup.y = mouseY;

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

            let day = date_logged.getDay()-1
            if(day < 0)
                day = 6;
            let index = (day) + (7 * (date_logged.getHours()-startTime));
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

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: model.macroarea_color }
                    GradientStop { position: 2; color: model.macroarea_color === cellBackground ? cellBackground :
                                                                                                  cellBackground }
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

                    font.pixelSize: parent.height * 0.6
                    font.family: customFont.name
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: (mouse) => {
                                   selectActivityPopup.dateCell = Qt.formatDateTime(dateFromIndex(model.index), "yyyy-MM-dd hh:mm:ss");
                                   openPopup(rectHour.x + mouse.x, rectHour.y + mouse.y, rectHour.width*1.5);
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

                text: model.day.substring(0,3) + "  " + (controller.firstDay.getDate() + model.index)

                font.pixelSize: calendar.cellPreferredWidth / 4.5
                font.family: customFont.name
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

                    font.pixelSize: calendar.cellPreferredWidth / 8
                    font.family: customFont.name
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
                    source: "qrc:/icons/icons/arrow10.svg"
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
