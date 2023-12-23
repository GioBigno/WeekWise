import QtQuick 2.15

Item {

    required property date firstDay

    function fillWeekHours(){

        weekTotalHours.clear()

        let result = db.execute("SELECT lh.date_logged, lh.activity_id, ma.macroarea_color
                                 FROM logged_hours lh
                                 JOIN activities a ON lh.activity_id = a.activity_id
                                 JOIN macroareas ma ON a.macroarea_id = ma.macroarea_id
                                 WHERE lh.date_logged
                                 BETWEEN '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") +"'
                                 AND '" +  Qt.formatDateTime(lastDayOfTheWeek(firstDay), "yyyy-MM-dd") +"';")

        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            let date_logged = new Date(row.date_logged)

            if(date_logged.getHours() < startTime || date_logged.getHours() > startTime+numHours){
                continue;
            }

            let index = (date_logged.getDay()-1) + (7 * (date_logged.getHours()-startTime))
            weekHours.set(index, {macroarea_color: "#"+row.macroarea_color})
        }
    }

    function weekTotalHoursChanged(){

    }

    ListModel{
        id: weekTotalHours
        //{macroarea_id, macroarea_color, num_hours_week}
    }


    ListView {
        id: listViewSideStats
        anchors.fill: parent
        model: 10
        spacing: 10
        clip: true

        delegate: Rectangle{

            width: listViewSideStats.width
            height: 100
            //anchors.fill: parent
            color: "green"
        }

    }
}
