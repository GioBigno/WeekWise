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

    height: (weekTotalHours.count * (columnSideBars.rectHeight + columnSideBars.spacing)) + footerRect.height

    ListModel{
        id: weekTotalHours
        //{planned_macroarea_id, macroarea_id, macroarea_name, macroarea_color, total_logged_hours, total_planned_hours}
    }

    Column{
        id: columnSideBars
        anchors.margins: 5
        anchors.fill: parent
        spacing: space

        property int fontSize: 26
        property int barHeight: 15
        property int space: 8
        property int rectHeight: columnSideBars.fontSize*2 + columnSideBars.barHeight

        Repeater{
            model: weekTotalHours

            delegate: Rectangle{
                id: rectGoal

                anchors{
                    left: parent.left
                    right: parent.right
                }

                height: columnSideBars.rectHeight

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

                Text{
                    id: textLabel

                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    width: parent.width - textRatio.width - 10

                    color: Universal.accent
                    text: model.macroarea_name
                    clip: true
                    elide: Text.ElideRight

                    font.pixelSize: columnSideBars.fontSize
                    font.family: customFont.name
                }

                Text{
                    id: textRatio

                    anchors {
                        right: parent.right
                        top: parent.top
                    }

                    color: Universal.foreground
                    text: "" + model.total_logged_hours + " / " + model.total_planned_hours
                    clip: true

                    font.pixelSize: columnSideBars.fontSize
                    font.family: customFont.name
                }


                BProgressBar{
                    id: bPrograssBar
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    width: parent.width
                    height: columnSideBars.barHeight

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

                    property double buttonDim: height * 2/3
                    property double spaceBeetWeen: (width - 2*buttonDim) / 11
                    property double sideMargin: spaceBeetWeen*5
                    property double verticalMargin: height / 6

                    RoundButton{
                        id: buttonDelete
                        visible: true

                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: parent.left
                            topMargin: goalButtons.verticalMargin
                            bottomMargin: goalButtons.verticalMargin
                            leftMargin: goalButtons.spaceBeetWeen*5
                            rightMargin: goalButtons.spaceBeetWeen
                        }

                        height: goalButtons.buttonDim
                        width: goalButtons.buttonDim

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

                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                            topMargin: goalButtons.verticalMargin
                            bottomMargin: goalButtons.verticalMargin
                            leftMargin: goalButtons.spaceBeetWeen
                            rightMargin: goalButtons.spaceBeetWeen*5
                        }

                        height: goalButtons.buttonDim
                        width: goalButtons.buttonDim

                        radius: 4
                        padding: 10

                        icon.source: "qrc:/icons/icons/pencil.svg"
                        icon.color: Universal.accent
                        icon.width: parent.height - 2*padding
                        icon.height: parent.height - 2*padding

                        onClicked: {
                            popupNewGoalDetailEdit.x = x - 200;
                            popupNewGoalDetailEdit.y = y;
                            popupNewGoalDetailEdit.width = 200;
                            popupNewGoalDetailEdit.height = 130;
                            popupNewGoalDetailEdit.macroarea_id = model.macroarea_id;
                            popupNewGoalDetailEdit.setStartValue(model.total_planned_hours);
                            popupNewGoalDetailEdit.open();
                        }
                    }

                }
                PopupSideStatsNewGoalDetail{
                    id: popupNewGoalDetailEdit
                }
            }
        }

        Rectangle{
            id: footerRect

            anchors{
                left: parent.left
                right: parent.right
            }

            height: 65

            color: "transparent"
            radius: 8

            Button{
                id: buttonAddSideStatsProgressBar

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: 10
                }

                width: parent.height / 1.5
                height: parent.height / 1.5

                background: Rectangle{
                    color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.5  )
                    opacity: buttonAddSideStatsProgressBar.hovered ? 0.6 : 1
                    radius: 10
                }

                IconImage{
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "qrc:/icons/icons/plus.svg"
                    color: Universal.background
                }

                onClicked:{
                    popupNewGoal.x = 0;
                    popupNewGoal.y = y;
                    popupNewGoal.width = x - 5;
                    popupNewGoalDetail.x = 0;
                    popupNewGoalDetail.y = y;
                    popupNewGoalDetail.width = x - 5;
                    popupNewGoalDetail.height = 130;
                    popupNewGoal.open();
                }
            }

            PopupSideStatsNewGoal{
                id: popupNewGoal
            }

            PopupSideStatsNewGoalDetail{
                id: popupNewGoalDetail
            }
        }
    }
}
