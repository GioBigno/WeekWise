import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

import BDatabase

Item{

    BDatabase{
        id: db
        databaseType: "QSQLITE"

        Component.onCompleted: {
            connect("weekwise.db")

            calendar.fillMacroareas()
            calendar.fillActivities()
            calendar.fillWeekLoggedHours()
        }
    }

    RowLayout{
        anchors.fill: parent

        Calendar{
            id: calendar
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50

            currentDay: new Date()
            firstDay: firstDayOfTheWeek(currentDay)
        }

        SideStats{
            id: sideStats
            //Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: parent.width/4

            //TODO
            firstDay: calendar.firstDay

            //color: "red"
        }
    }
}
