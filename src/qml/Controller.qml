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
        modelLogic.fillWeekLoggedHours(firstDay, lastDay);

        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay);

        weekView = weekViewComponent.createObject(stackView);
        stackView.push(weekView);
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

    function firstDayOfTheWeek(day){
        var d = day;
        var weekday = d.getDay() - 1;
        if(weekday < 0)
            weekday = 6;
        var diff = d.getDate() - weekday;
        return new Date(d.setDate(diff));
    }

    function lastDayOfTheWeek(day){
        var d = firstDayOfTheWeek(day);
        var diff = d.getDate() + 6;
        return new Date(d.setDate(diff));
    }

    // -----------------------------------------------------------------

    // data ------------------------------------------------------------

    function prevWeek(){
        firstDay = new Date(firstDay.getTime() - 7 * 24 * 60 * 60 * 1000);

        //update
        modelLogic.fillWeekLoggedHours(firstDay, lastDay);
        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay)

        //notify
        weekView.weekLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function nextWeek(){
        firstDay = new Date(firstDay.getTime() + 7 * 24 * 60 * 60 * 1000);

        //update
        modelLogic.fillWeekLoggedHours(firstDay, lastDay);
        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay)

        //notify
        weekView.weekLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function deleteLoggedHour(date){
        modelLogic.deleteLoggedHour(date);

        //update
        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay)

        //notify
        weekView.weekLoggedHoursChanged();
        weekView.weekTotalHoursStatsChanged();
    }

    function addLoggedHour(date, activity_id){
        modelLogic.addLoggedHour(date, activity_id);

        //update
        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay)

        //notify
        weekView.weekLoggedHoursChanged();
    }

    function addPlannedMacroareas(macroarea_id, numHours){
        modelLogic.addPlannedMacroarea(macroarea_id, numHours, firstDay);

        //update
        modelLogic.fillWeekTotalHoursStats(firstDay, lastDay)

        //notify
        weekView.weekLoggedHoursChanged();
    }

    function getMacroareas(){
        return modelLogic.getMacroareas();
    }

    function getActivities(){
        return modelLogic.getActivities();
    }

    function getWeekLoggedHours(){
        return modelLogic.getWeekLoggedHours();
    }

    function getWeekTotalHoursStats(){
        return modelLogic.getWeekTotalHoursStats();
    }

    // -----------------------------------------------------------------


}
