import QtQuick 2.15
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls.Universal 2.12

Item {

    function weekTotalHoursStatsChanged(){
        pieSeries.clear();
        let result = controller.getWeekTotalHoursStats();

        let total_logged_hours=0;
        let total_planned_hours=0;
        let i =0;
        for (i = 0; i < result.count; ++i) {
            let row = result.get(i);
            total_planned_hours += row.total_planned_hours;
            total_logged_hours += row.total_logged_hours;
        }

        for (i = 0; i < result.count; ++i) {
            let row = result.get(i);
            pieSeries.append(row.macroarea_color, row.total_planned_hours / total_planned_hours);
            pieSeries.find(row.macroarea_color).color = row.macroarea_color;
        }

        if(total_planned_hours != 0){
            console.log("planned: " + total_planned_hours + ", logged: " + total_logged_hours)
            pieSeries.append("gray", (total_planned_hours-total_logged_hours) / total_planned_hours);
            pieSeries.find("gray").color = "gray";
        }
    }

    function changeAlpha(color, x){
        return Qt.rgba(color.r, color.g, color.b, x)
    }

    ListModel{
        id: pieModel
        //{macroarea_color, percentage}
    }

    ScrollView{
        id: scrollView
        anchors.fill: parent

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            parent: scrollView.parent
            policy: ScrollBar.AsNeeded
            x: scrollView.mirrored ? 0 : scrollView.width - width
            y: scrollView.topPadding
            height: scrollView.availableHeight

            background: Rectangle{
                color: "transparent"
            }

            contentItem: Rectangle {
                implicitWidth: 10
                implicitHeight: 50
                radius: width/2
                color: (scrollBar.hovered || scrollBar.pressed) ? Qt.rgba(Qt.color("gray").r, Qt.color("gray").g, Qt.color("gray").b, 0.6) :
                                           Qt.rgba(Qt.color("gray").r, Qt.color("gray").g, Qt.color("gray").b, 0.1)
            }
        }

        ColumnLayout{
            id: sideStatslayout
            anchors.fill: parent

            spacing: 0

            property int barHeight: 15
            property int fontSize: 30

            Rectangle{
                id: headerRect
                Layout.alignment: Qt.AlignTop
                width: sideStatslayout.width
                height: sideStatslayout.fontSize*2
                color: "transparent"

                Text{
                    y: -(sideStatslayout.fontSize)
                    text: qsTr("Weekly goal")

                    elide: Text.ElideRight
                    color: Universal.foreground
                    font.pixelSize: sideStatslayout.fontSize * 2
                    font.family: customFont.name
                }
            }

            SideBars{
                Layout.fillHeight: true
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignBottom
            }

            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color:"red"
                height: 100
            }

            ChartView {
                id: chart
                height: 250
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                antialiasing: true
                backgroundColor: "transparent"
                legend.visible: false

                plotAreaColor: "transparent"

                margins { right: 0; bottom: 0; left: 0; top: 0 }
                anchors.margins: 0
                Layout.margins: 0

                PieSeries {
                    id: pieSeries
                }

            }

        }
    }

}
