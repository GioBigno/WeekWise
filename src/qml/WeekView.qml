import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item{
    id: weekView

    function weekLoggedHoursChanged(){
        calendar.weekLoggedHoursChanged()
    }

    function weekTotalHoursStatsChanged(){
        sideStats.weekTotalHoursStatsChanged()
    }

    RowLayout{
        anchors.fill: parent

        Calendar{
            id: calendar
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
        }

        SideStats{
            id: sideStats
            //Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: parent.width/4
        }
    }
}
