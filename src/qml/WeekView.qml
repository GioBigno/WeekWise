import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

import BDatabase

Item{
    id: weekView

    property date currentDay: new Date()
    property date firstDay: firstDayOfTheWeek(currentDay)
    property date lastDay: lastDayOfTheWeek(firstDay)

    function firstDayOfTheWeek(day){
        var d = day
        var weekday = d.getDay() - 1
        if(weekday < 0)
            weekday = 6
        var diff = d.getDate() - weekday
        return new Date(d.setDate(diff))
    }

    function lastDayOfTheWeek(day){
        var d = firstDayOfTheWeek(day)
        var diff = d.getDate() + 6
        return new Date(d.setDate(diff))
    }

    function prevWeek(){
        firstDay = new Date(firstDay.getTime() - 7 * 24 * 60 * 60 * 1000);

        calendar.fillWeekLoggedHours()

        sideStats.fillWeekHours()
    }

    function nextWeek(){
        firstDay = new Date(firstDay.getTime() + 7 * 24 * 60 * 60 * 1000)

        calendar.fillWeekLoggedHours()

        sideStats.fillWeekHours()
    }

    function weekTotalPlannedHoursChanged(){
        sideStats.fillWeekHours()
    }

    BDatabase{
        id: db
        databaseType: "QSQLITE"

        Component.onCompleted: {
            connect("weekwise.db")

            calendar.fillMacroareas()
            calendar.fillActivities()
            calendar.fillWeekLoggedHours()

            sideStats.fillWeekHours()
        }
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
