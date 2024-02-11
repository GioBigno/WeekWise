import QtQuick

Item{

    property date currentDay: new Date()
    property date firstDay: firstDayOfTheWeek(currentDay)
    property date lastDay: lastDayOfTheWeek(firstDay)

    property QtObject weekView

    Model{
        id: modelLogic
    }

    // view functions ------------------------------------------------

    function pushWeekView(){

        modelLogic.fillMacroareas();
        modelLogic.fillActivities();
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));

        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        weekView = weekViewComponent.createObject(stackView);
        stackView.push(weekView);

        weekView.weekTotalHoursStatsChanged();
        weekView.weekPlannedLoggedHoursChanged();
    }

    function pushStatsView(){
        //TODO
    }

    Component{
        id: weekViewComponent
        WeekView{}
    }

    // ----------------------------------------------------------------


    // utils functions ------------------------------------------------

    function dateToTimestamp(d){
        let dd = new Date(d);
        return dd.getTime();
    }

    function dateToTimestampNoTime(d){
        let dd = new Date(d);
        dd.setHours(0);
        dd.setMinutes(0);
        dd.setSeconds(0);
        d.setMilliseconds(0);
        return dd.getTime();
    }

    function timeStamptoDate(t){
        return new Date(t);
    }

    function firstDayOfTheWeek(day){
        var d = day;
        var weekday = d.getDay() - 1;
        if(weekday < 0)
            weekday = 6;
        var diff = d.getDate() - weekday;
        d.setHours(0);
        d.setMinutes(0);
        d.setSeconds(0);
        d.setMilliseconds(0);
        return new Date(d.setDate(diff));
    }

    function lastDayOfTheWeek(day){
        var d = firstDayOfTheWeek(day);
        var diff = d.getDate() + 6;
        d.setHours(0);
        d.setMinutes(0);
        d.setSeconds(0);
        d.setMilliseconds(0);
        return new Date(d.setDate(diff));
    }

    function nextDay(day){
        let d = new Date(day);
        d.setUTCDate(d.getUTCDate() + 1);
        return d;
    }

    function noTime(day){
        let d = new Date(day);
        d.setHours(0);
        d.setMinutes(0);
        d.setSeconds(0);
        d.setMilliseconds(0);
        return d;
    }

    // -----------------------------------------------------------------

    // data ------------------------------------------------------------

    function prevWeek(){
        firstDay = new Date(firstDay.getTime() - 7 * 24 * 60 * 60 * 1000);
        lastDay = lastDayOfTheWeek(firstDay);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function nextWeek(){
        firstDay = new Date(firstDay.getTime() + 7 * 24 * 60 * 60 * 1000);
        lastDay = lastDayOfTheWeek(firstDay);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function addPlannedHour(date, activity_id){
        modelLogic.addPlannedHour(date, activity_id);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function setPlannedHour(date){
        modelLogic.setPlannedHour(date);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function deletePlannedHour(date){
        modelLogic.deletePlannedHour(date);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function deleteLoggedHour(date){
        modelLogic.deleteLoggedHour(date);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function setLoggedHour(date){
        modelLogic.setLoggedHour(date);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function addNoteLoggedHour(date, note){
        modelLogic.addNoteLoggedHour(date, note);

        //update
        modelLogic.fillWeekPlannedLoggedHours(firstDay, nextDay(lastDay));

        //notify
        weekView.weekPlannedLoggedHoursChanged();
    }

    function addPlannedMacroareas(macroarea_id, numHours){
        modelLogic.addPlannedMacroarea(macroarea_id, numHours, noTime(firstDay));

        //update
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekTotalHoursStatsChanged();
    }

    function deletePlannedMacroareas(planned_macroarea_id){
        modelLogic.deletePlannedMacroareas(planned_macroarea_id);

        //update
        modelLogic.fillWeekTotalHoursStats(firstDay, nextDay(lastDay));

        //notify
        weekView.weekTotalHoursStatsChanged();
    }

    function getMacroareas(){
        return modelLogic.getMacroareas();
    }

    function getActivities(){
        return modelLogic.getActivities();
    }

    function getWeekPlannedLoggedHours(){
        return modelLogic.getWeekPlannedLoggedHours();
    }

    function getWeekTotalHoursStats(){
        return modelLogic.getWeekTotalHoursStats();
    }

    // -----------------------------------------------------------------


}
