import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item{
    //id: weekView

    function weekLoggedHoursChanged(){
        calendar.weekLoggedHoursChanged()
    }

    function weekTotalHoursStatsChanged(){
        sideStats.weekTotalHoursStatsChanged()
    }

    Calendar{
        id: calendar

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 5
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
