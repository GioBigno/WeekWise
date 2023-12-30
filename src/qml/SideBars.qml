import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item{

    function getNumber(){
        return weekTotalHours.count
    }

    function weekTotalHoursStatsChanged(){
        let result = controller.getWeekTotalHoursStats()
        weekTotalHours.clear()
        for (let i = 0; i < result.count; ++i) {
            let row = result.get(i);

            weekTotalHours.append({planned_macroarea_id: row.planned_macroarea_id, macroarea_id: row.macroarea_id, macroarea_name: row.macroarea_name, macroarea_color: row.macroarea_color,
                                   total_logged_hours: row.total_logged_hours, total_planned_hours: row.total_planned_hours});
        }
    }

    height: (listViewSideBars.fontSize*2 + listViewSideBars.barHeight + listViewSideBars.space) * (weekTotalHours.count)

    ListModel{
        id: weekTotalHours
        //{planned_macroarea_id, macroarea_id, macroarea_name, macroarea_color, total_logged_hours, total_planned_hours}
    }

    Column{
        id: listViewSideBars
        anchors.margins: 5
        anchors.fill: parent
        spacing: space

        property int fontSize: 30
        property int barHeight: 15
        property int space: 10

        Repeater{
            model: weekTotalHours
            clip: true

            delegate: Rectangle{
                id: rectGoal
                Layout.fillHeight: true
                Layout.fillWidth: true
                width: listViewSideBars.width
                height: listViewSideBars.fontSize*2 + listViewSideBars.barHeight
                //anchors.fill: parent
                color: "transparent"
                radius: 8

                HoverHandler{
                    id: hoverHandler

                    onHoveredChanged: {
                        if(hovered){
                            goalButtons.visible = true
                        }else{
                            goalButtons.visible = false
                        }
                    }
                }

                RowLayout{
                    anchors.fill: parent

                    Text{
                        id: textLabel
                        y: -(listViewSideBars.fontSize/2)
                        //horizontalAlignment: Text.AlignLeft
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.maximumWidth: parent.width - textRatio.width - 10

                        color: Universal.accent
                        text: model.macroarea_name
                        clip: true
                        elide: Text.ElideRight

                        font.pixelSize: listViewSideBars.fontSize
                        font.family: customFont.name
                    }

                    Text{
                        id: textRatio
                        y: -(listViewSideBars.fontSize/2)
                        //horizontalAlignment: Text.AlignRight
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop


                        color: Universal.foreground
                        text: "" + model.total_logged_hours + " / " + model.total_planned_hours
                        clip: true

                        font.pixelSize: listViewSideBars.fontSize
                        font.family: customFont.name
                    }
                }

                BProgressBar{
                    id: bPrograssBar
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    width: parent.width
                    height: listViewSideBars.barHeight

                    borderColor: Universal.foreground
                    backgroundColor: Universal.background
                    fillColor: model.macroarea_color
                    borderWidth: 1
                    radius: 25
                    progress: (model.total_logged_hours/model.total_planned_hours) > 1 ? 1 : (model.total_logged_hours/model.total_planned_hours)
                }

                Rectangle{
                    id: goalButtons
                    anchors.fill: parent
                    color: Qt.rgba(Universal.Dark.r, Universal.Dark.g, Universal.Dark.b, 0.7)
                    visible: false
                    radius: parent.radius

                    RowLayout{
                        anchors.fill: parent
                        visible: true
                        spacing: 20

                        RoundButton{
                            id: buttonDelete
                            visible: true

                            Layout.preferredHeight: parent.height - 20
                            Layout.preferredWidth: height
                            Layout.topMargin: 10
                            Layout.bottomMargin: 10
                            Layout.leftMargin: (parent.width - 2*height)/3
                            Layout.rightMargin: (parent.width - 2*height)/12
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                            radius: 4
                            padding: 10

                            icon.source: "qrc:/icons/icons/trash.svg"
                            icon.color: Universal.accent
                            icon.width: parent.height - 2*padding
                            icon.height: parent.height - 2*padding

                            onClicked: {
                                controller.deletePlannedMacroareas(model.planned_macroarea_id);
                            }
                        }

                        RoundButton{
                            id: buttonEdit
                            visible: true

                            Layout.preferredHeight: parent.height - 20
                            Layout.preferredWidth: height
                            Layout.topMargin: 10
                            Layout.bottomMargin: 10
                            Layout.rightMargin: (parent.width - 2*height)/3
                            Layout.leftMargin: (parent.width - 2*height)/12
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                            radius: 4
                            padding: 10

                            icon.source: "qrc:/icons/icons/pencil.svg"
                            icon.color: Universal.accent
                            icon.width: parent.height - 2*padding
                            icon.height: parent.height - 2*padding

                            onClicked: {
                                popupNewGoalDetailEdit.x = 0;
                                popupNewGoalDetailEdit.y = y;
                                popupNewGoalDetailEdit.width = x - 5;
                                popupNewGoalDetailEdit.macroarea_id = model.macroarea_id;
                                popupNewGoalDetailEdit.setStartValue(model.total_planned_hours);
                                popupNewGoalDetailEdit.open();
                            }
                        }
                    }
                }
                PopupSideStatsNewGoalDetail{
                    id: popupNewGoalDetailEdit
                }
            }
        }
    }
}
