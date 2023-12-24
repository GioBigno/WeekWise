import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

Item {

    function fillWeekHours(){

        weekTotalHours.clear()

        let result = db.execute("SELECT
                                     m.macroarea_id,
                                     m.macroarea_name,
                                     m.macroarea_color,
                                     p.planned_id,
                                     COALESCE(p.planned_duration, 0) AS total_planned_hours,
                                     COALESCE(COUNT(l.logged_id), 0) AS total_logged_hours,
                                     COALESCE(COUNT(l.logged_id) * 1.0 / NULLIF(p.planned_duration, 0), 0) AS logged_planned_ratio
                                 FROM macroareas m
                                 LEFT JOIN activities a ON m.macroarea_id = a.macroarea_id
                                 LEFT JOIN planned_hours p ON a.activity_id = p.activity_id
                                 LEFT JOIN logged_hours l ON a.activity_id = l.activity_id
                                 WHERE p.week_date
                                 BETWEEN '" + Qt.formatDateTime(weekView.firstDay, "yyyy-MM-dd") +"'
                                 AND '" + Qt.formatDateTime(weekView.lastDay, "yyyy-MM-dd") +"'
                                 GROUP BY m.macroarea_id, m.macroarea_color
                                 ORDER BY logged_planned_ratio DESC;")

        for (let i = 0; i < result.length; ++i) {
            let row = result[i];
            weekTotalHours.append({macroarea_id: row.macroarea_id,
                                   macroarea_name: row.macroarea_name,
                                   macroarea_color: "#" + row.macroarea_color,
                                   planned_id: row.planned_id,
                                   total_planned_hours: row.total_planned_hours,
                                   total_logged_hours: row.total_logged_hours})
        }
    }

    ListModel{
        id: weekTotalHours
        //{macroarea_id, macroarea_name, macroarea_color, planned_id, total_planned_hours, total_logged_hours}
    }



    ListView{
        id: listViewSideStats
        anchors.fill: parent
        model: weekTotalHours
        spacing: 10
        clip: true

        property int fontSize: 30
        property int barHeight: 15
        property int space: 10

        delegate: Rectangle{
            id: rectGoal
            width: listViewSideStats.width
            height: listViewSideStats.fontSize*2 + bPrograssBar.height
            //anchors.fill: parent
            color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.1)
            radius: 8

            HoverHandler{

                onHoveredChanged: {
                    if(hovered){
                        parent.opacity = 0.6
                        buttonDelete.visible = true
                    }else{
                        parent.opacity = 1
                        buttonDelete.visible = false
                    }
                }
            }

            Rectangle{
                width: listViewSideStats.width
                height: listViewSideStats.fontSize + listViewSideStats.barHeight + listViewSideStats.space
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter

                Text{
                    y: -(listViewSideStats.fontSize/2)
                    //anchors.fill: parent
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    //verticalAlignment: Text.AlignTop

                    color: Universal.accent
                    text: model.macroarea_name

                    font.pixelSize: listViewSideStats.fontSize
                    font.family: customFont.name
                }

                Text{
                    y: -(listViewSideStats.fontSize/2)
                    //anchors.fill: parent
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight
                    //verticalAlignment: Text.AlignTop


                    color: Universal.foreground
                    text: "" + model.total_logged_hours + " / " + model.total_planned_hours

                    font.pixelSize: listViewSideStats.fontSize
                    font.family: customFont.name
                }

                BProgressBar{
                    id: bPrograssBar
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: listViewSideStats.barHeight

                    borderColor: Universal.foreground
                    backgroundColor: Universal.background
                    fillColor: model.macroarea_color
                    borderWidth: 1
                    radius: 25
                    progress: (model.total_logged_hours/model.total_planned_hours)
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: (mouse) => {

                    }
                }

                RoundButton{
                    id: buttonDelete
                    visible: false
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.height
                    height: parent.height

                    radius: 4
                    padding: 10

                    icon.source: "qrc:/icons/icons/trash.svg"
                    icon.color: Universal.accent
                    icon.width: parent.height
                    icon.height: parent.height

                    onClicked: {
                        //eliminare da db
                        db.execute("DELETE FROM planned_hours
                                    WHERE planned_id = " + model.planned_id + ";")
                    }
                }

            }
        }

        footer: Rectangle{
                    width: listViewSideStats.width
                    height: listViewSideStats.fontSize*2 + 10
                    //anchors.fill: parent
                    color: "transparent"

                    Button{
                        id: buttonAddSideStatsProgressBar
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left

                        width: 40
                        height: 40

                        background: Rectangle{
                                        color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.5)
                                        opacity: buttonAddSideStatsProgressBar.hovered ? 0.6 : 1
                                        radius: 10
                                    }

                        IconImage{
                            anchors.fill: parent
                            source: "qrc:/icons/icons/plus.svg"
                            color: Universal.background
                        }

                        onClicked: {
                            weekView.prevWeek()
                        }
                    }
                }
    }
}
