import QtQuick
import BDatabase

Item{

    function fillMacroareas(){
        let result = db.execute("SELECT * FROM macroareas;");

        macroareas.clear()
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            macroareas.append({id: row.macroarea_id, name: row.macroarea_name, color: "#"+row.macroarea_color});
        }
    }

    function fillActivities(){
        let result = db.execute("SELECT a.activity_id, a.activity_name, m.macroarea_id, m.macroarea_color
                          FROM activities a
                          JOIN macroareas m
                          ON a.macroarea_id = m.macroarea_id
                          ORDER BY a.macroarea_id ASC;");

        activities.clear()
        //activities.append({activity_id: -1, name: qsTr("None"), color: "gray"});
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            activities.append({activity_id: row.activity_id, name: row.activity_name, macroarea_id: row.macroarea_id, color: "#"+row.macroarea_color});
        }
    }

    function fillWeekPlannedLoggedHours(firstDay, lastDay){
        let result = db.execute("SELECT lh.date_logged, lh.activity_id, lh.done, a.activity_name, ma.macroarea_color
                                 FROM logged_hours lh
                                 JOIN activities a ON lh.activity_id = a.activity_id
                                 JOIN macroareas ma ON a.macroarea_id = ma.macroarea_id
                                 WHERE lh.date_logged
                                 BETWEEN " + controller.dateToTimestampNoTime(firstDay) +"
                                 AND " +  (controller.dateToTimestampNoTime(lastDay)-1) +";");

        weekPlannedLoggedHours.clear();
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            weekPlannedLoggedHours.append({activity_id: row.activity_id, date_logged: timeStamptoDate(row.date_logged), macroarea_color: "#"+row.macroarea_color, activity_name: row.activity_name, done: row.done === 1});
        }
    }

    function fillWeekTotalHoursStats(firstDay, lastDay){
        let result = db.execute("SELECT
                                    m.macroarea_id,
                                    m.macroarea_name,
                                    m.macroarea_color,
                                    pm.planned_macroarea_id,
                                    COALESCE(pm.planned_duration, 0) AS total_planned_hours,
                                    COALESCE(COUNT(l.logged_id), 0) AS total_logged_hours,
                                    COALESCE(COUNT(l.logged_id) * 1.0 / NULLIF(pm.planned_duration, 0), 0) AS logged_planned_ratio
                                FROM macroareas m
                                LEFT JOIN activities a ON m.macroarea_id = a.macroarea_id
                                LEFT JOIN planned_macroareas pm ON m.macroarea_id = pm.macroarea_id
                                    AND pm.week_date BETWEEN " + controller.dateToTimestampNoTime(firstDay) +" AND " + (controller.dateToTimestampNoTime(lastDay)-1) +"
                                LEFT JOIN logged_hours l ON a.activity_id = l.activity_id AND l.done = 1
                                    AND l.date_logged BETWEEN " + controller.dateToTimestampNoTime(firstDay) +" AND " + (controller.dateToTimestampNoTime(lastDay)-1) +"
                                GROUP BY m.macroarea_id, m.macroarea_color
                                HAVING total_planned_hours != 0
                                ORDER BY logged_planned_ratio ASC;")

        weekTotalHoursStats.clear()
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];



            weekTotalHoursStats.append({macroarea_id: row.macroarea_id,
                                        macroarea_name: row.macroarea_name,
                                        macroarea_color: "#"+row.macroarea_color,
                                        total_planned_hours: row.total_planned_hours,
                                        total_logged_hours: row.total_logged_hours,
                                        planned_macroarea_id: row.planned_macroarea_id});
        }
    }

    function addPlannedHour(date, activity_id){
        db.execute("INSERT OR REPLACE INTO logged_hours (activity_id, date_logged, done)
                    VALUES (" + activity_id + ", '" + controller.dateToTimestamp(date) +"', 0);");
    }

    function deletePlannedHour(date){
        db.execute("DELETE FROM logged_hours
                    WHERE date_logged = " + controller.dateToTimestamp(date) + ";");
    }

    function deleteLoggedHour(date){
        db.execute("DELETE FROM logged_hours
                    WHERE date_logged = " + controller.dateToTimestamp(date) + ";");
    }

    function addLoggedHour(date, activity_id){
        db.execute("INSERT OR REPLACE INTO logged_hours (activity_id, date_logged, done)
                    VALUES (" + activity_id + ", '" + controller.dateToTimestamp(date) +"', 1);");
    }

    function addPlannedMacroarea(macroarea_id, numHours, firstDay){
        db.execute("INSERT OR REPLACE INTO planned_macroareas (macroarea_id, planned_duration, week_date)
                    VALUES (" + macroarea_id + ", " + numHours + ", " + controller.dateToTimestampNoTime(firstDay) + ");");
    }

    function deletePlannedMacroareas(planned_macroarea_id){
        db.execute("DELETE FROM planned_macroareas
                    WHERE planned_macroarea_id = " + planned_macroarea_id + ";");
    }

    function getMacroareas(){
        return macroareas;
    }

    function getActivities(){
        return activities;
    }

    function getWeekPlannedLoggedHours(){
        return weekPlannedLoggedHours;
    }

    function getWeekTotalHoursStats(){
        return weekTotalHoursStats;
    }

    function getAcvitityById(id){
        for(let i=0; i < activities.count; i++){
            if(activities.get(i).activity_id === id){
                return activities.get(i);
            }
        }
        return null;
    }

    function getMacroareaById(id){
        for(let i=0; i < macroareas.count; i++){
            if(macroareas.get(i).id === id){
                return macroareas.get(i);
            }
        }
        return null;
    }

    ListModel{
        id: macroareas
        //{id, name, color}
    }

    ListModel{
        id: activities
        //{activity_id, name, macroarea_id, color}
    }

    ListModel{
        id: weekPlannedLoggedHours
        //logged hours of the week
        //{activity_id, date_logged, macroarea_color, activity_name, done}
    }

    ListModel{
        id: weekTotalHoursStats
        //{macroarea_id, macroarea_name, macroarea_color, total_planned_hours, total_logged_hours, planned_macroarea_id}
    }

    BDatabase{
        id: db
        databaseType: "QSQLITE"

        Component.onCompleted: {
            connect("weekwise.db")
        }
    }

}

