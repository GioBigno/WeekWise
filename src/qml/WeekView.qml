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
            calendar.fillWeekHours()
        }
    }

    Calendar{
        id: calendar
        anchors.fill: parent
        width: parent.width

        currentDay: new Date()
    }
}
