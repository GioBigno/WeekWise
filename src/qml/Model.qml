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
                          ON a.macroarea_id = m.macroarea_id;");

        activities.clear()
        activities.append({activity_id: -1, name: qsTr("None"), color: "gray"});
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            activities.append({activity_id: row.activity_id, name: row.activity_name, macroarea_id: row.macroarea_id, color: "#"+row.macroarea_color});
        }
    }

    function fillWeekLoggedHours(firstDay, lastDay){
        let result = db.execute("SELECT lh.date_logged, lh.activity_id, a.activity_name, ma.macroarea_color
                                 FROM logged_hours lh
                                 JOIN activities a ON lh.activity_id = a.activity_id
                                 JOIN macroareas ma ON a.macroarea_id = ma.macroarea_id
                                 WHERE lh.date_logged
                                 BETWEEN '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") +"'
                                 AND '" +  Qt.formatDateTime(lastDay, "yyyy-MM-dd") +"';");

        weekLoggedHours.clear();
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            weekLoggedHours.append({date_logged: row.date_logged, macroarea_color: "#"+row.macroarea_color, activity_name: row.activity_name});
        }
    }

    function fillWeekTotalHoursStats(firstDay, lastDay){
        let result = db.execute("SELECT
                                     m.macroarea_id,
                                     m.macroarea_name,
                                     m.macroarea_color,
                                     COALESCE(pm.planned_duration, 0) AS total_planned_hours,
                                     COALESCE(COUNT(l.logged_id), 0) AS total_logged_hours,
                                     COALESCE(COUNT(l.logged_id) * 1.0 / NULLIF(pm.planned_duration, 0), 0) AS logged_planned_ratio
                                 FROM macroareas m
                                 LEFT JOIN activities a ON m.macroarea_id = a.macroarea_id
                                 LEFT JOIN planned_macroareas pm ON m.macroarea_id = pm.macroarea_id
                                 LEFT JOIN logged_hours l ON a.activity_id = l.activity_id
                                 WHERE pm.week_date
                                 BETWEEN '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") +"'
                                 AND '" + Qt.formatDateTime(lastDay, "yyyy-MM-dd") +"'
                                 GROUP BY m.macroarea_id, m.macroarea_color
                                 ORDER BY logged_planned_ratio ASC;")

        weekTotalHoursStats.clear()
        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            weekTotalHoursStats.append({macroarea_id: row.macroarea_id,
                                        macroarea_name: row.macroarea_name,
                                        macroarea_color: "#"+row.macroarea_color,
                                        total_planned_hours: row.total_planned_hours,
                                        total_logged_hours: row.total_logged_hours});
        }
    }

    function deleteLoggedHour(date){
        db.execute("DELETE FROM logged_hours
                    WHERE date_logged = '" + date + "';");

        for(let i=0; i < weekLoggedHours.count; i++){
            if(weekLoggedHours.get(i).date_logged === date){
                weekLoggedHours.remove(i);
                break;
            }
        }
    }

    function addLoggedHour(date, activity_id){
        db.execute("INSERT OR REPLACE INTO logged_hours (activity_id, date_logged)
                    VALUES (" + activity_id + ", '" + date +"');");

        let find=-1
        let i=0;
        for(i=0; i < weekLoggedHours.count; i++){
            if(weekLoggedHours.get(i).date_logged === date){
                find = i;
                break;
            }
        }

        let activity = getAcvitityById(activity_id);
        if(find == -1){
            weekLoggedHours.append({date_logged: date, macroarea_color: getMacroareaById(activity.macroarea_id).color, activity_name: activity.name});
        }else{
            weekLoggedHours.set(find, {date_logged: date, macroarea_color: getMacroareaById(activity.macroarea_id).color, activity_name: activity.name});
        }
    }

    function addPlannedMacroarea(macroarea_id, numHours, firstDay){
        db.execute("INSERT INTO planned_macroareas (macroarea_id, planned_duration, week_date)
                    VALUES (" + macroarea_id + ", " + numHours + ", '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") + "');");

        console.log("query:  " + "INSERT INTO planned_macroareas (macroarea_id, planned_duration, week_date)
                    VALUES (" + macroarea_id + ", " + numHours + ", '" + Qt.formatDateTime(firstDay, "yyyy-MM-dd") + "');")

        fillWeekTotalHoursStats(controller.firstDay, controller.lastDay);
    }

    function getMacroareas(){
        return macroareas;
    }

    function getActivities(){
        return activities;
    }

    function getWeekLoggedHours(){
        return weekLoggedHours;
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
        id: weekLoggedHours
        //logged hours of the week
        //{date_logged, macroarea_color, activity_name}
    }

    ListModel{
        id: weekTotalHoursStats
        //{macroarea_id, macroarea_name, macroarea_color, total_planned_hours, total_logged_hours}
    }

    BDatabase{
        id: db
        databaseType: "QSQLITE"

        Component.onCompleted: {
            connect("weekwise.db")
        }
    }

}

