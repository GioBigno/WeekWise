import QtQuick 2.15
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls.Universal 2.12

Item {
    function weekTotalHoursStatsChanged(){
        sideBars.weekTotalHoursStatsChanged();


        pieSeries.clear();
        let result = controller.getWeekTotalHoursStats();

        let total_planned_hours=0;
        let i =0;
        for (i = 0; i < result.count; ++i) {
            let row = result.get(i);
            total_planned_hours += row.total_planned_hours;
        }

        if(total_planned_hours == 0){
            return;
        }

        for (i = 0; i < result.count; ++i) {
            let row = result.get(i);

            let ratio_done = 0;
            let ratio_todo = 0;
            if(row.total_logged_hours > row.total_planned_hours){
                ratio_done = row.total_planned_hours / total_planned_hours;
                ratio_todo = 0;
            }else{
                ratio_done = row.total_logged_hours / total_planned_hours;
                ratio_todo = (row.total_planned_hours - row.total_logged_hours) / total_planned_hours;
            }

            if(ratio_done != 0){
                pieSeries.append(row.macroarea_color, ratio_done);
                pieSeries.find(row.macroarea_color).color = row.macroarea_color;
            }

            if(ratio_todo != 0){

                let color = Qt.color(row.macroarea_color)
                let colorDark = Qt.rgba(color.r, color.g, color.b, 0.6);

                pieSeries.append(row.macroarea_color + "dark", ratio_todo);
                pieSeries.find(row.macroarea_color+"dark").color = Qt.color(row.macroarea_color).darker();
            }
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
        anchors.rightMargin: 5

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
                                                                  "transparent"
            }
        }

        contentHeight: headerRect.height + sideBars.height + chart.height;

        Rectangle{
            id: headerRect

            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            height: textWeeklygoal.implicitHeight

            color: "transparent"

            Text{
                id: textWeeklygoal

                anchors.centerIn: parent

                text: qsTr("Weekly goal")

                elide: Text.ElideRight
                color: Universal.foreground
                font.pointSize: 40
                font.family: fontMedium.name
            }
        }

        SideBars{
            id: sideBars

            anchors{
                left: parent.left
                right: parent.right
                top: headerRect.bottom
                topMargin: 10
            }
        }

        ChartView {
            id: chart

            anchors {
                left: parent.left
                right: parent.right
                top: sideBars.bottom
            }

            height: width

            antialiasing: true
            backgroundColor: "transparent"
            plotAreaColor: "transparent"
            legend.visible: false

            margins { right: 0; bottom: 0; left: 0; top: 0 }
            anchors.margins: 0
            Layout.margins: 0

            PieSeries {
                id: pieSeries
            }
        }
    }
}
