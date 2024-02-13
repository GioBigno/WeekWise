import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12
import "calendar"
import "sideStats"

Item{
    id: weekView

    function weekPlannedLoggedHoursChanged(){
        calendar.weekPlannedLoggedHoursChanged()
    }

    function weekTotalHoursStatsChanged(){
        sideStats.weekTotalHoursStatsChanged()
    }

    function collapseSideStats(){
        //currently not used
        calendar.width = parent.width;
        sideStats.width= 0;
    }

    function expandSideStats(){
        //currently not used
        calendar.width = parent.width * 3/4;
        sideStats.width = parent.width * 1/4;
    }

    Calendar{
        id: calendar

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 5
            rightMargin: 50
        }

        width: parent.width * 3/4
    }

    SideStats{
        id: sideStats

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: calendar.right
            right: parent.right
        }

        width: parent.width * 1/4
    }

}
