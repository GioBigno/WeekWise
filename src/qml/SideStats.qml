import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

Item {

    function weekTotalHoursStatsChanged(){
        //currently useless
        //can be usefull if you want to add animation when stats changes
    }

    function changeAlpha(color, x){
        return Qt.rgba(color.r, color.g, color.b, x)
    }

    function openPopup(mouseX, mouseY, w){

        if(mouseX + selectMacroareaPopup.width > parent.width){
            mouseX -= selectMacroareaPopup.width;
        }

        if(mouseY + selectMacroareaPopup.height > parent.height){
            mouseY -= selectMacroareaPopup.height;
        }

        selectMacroareaPopup.x = mouseX;
        selectMacroareaPopup.y = mouseY;

        selectMacroareaPopup.width = w;
        //selectActivityPopup.height = w*1.5

        selectMacroareaPopup.open();
    }

    ListView{
        id: listViewSideStats
        anchors.fill: parent
        model: controller.getWeekTotalHoursStats()
        spacing: 10
        clip: true

        property int fontSize: 30
        property int barHeight: 15
        property int space: 10

        header: Rectangle{
            id: headerRect
            width: listViewSideStats.width
            height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
            color: "transparent"

            Text{
                y: -(listViewSideStats.fontSize)
                text: qsTr("Weekly goal")

                color: Universal.foreground
                font.pixelSize: listViewSideStats.fontSize * 2
                font.family: customFont.name
            }
        }

        delegate: Rectangle{
            id: rectGoal
            width: listViewSideStats.width
            height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
            //anchors.fill: parent
            color: hoverHandler.hovered ? changeAlpha(Universal.foreground, 0.2) : "transparent"
            radius: 8

            HoverHandler{
                id: hoverHandler
            }

            Text{
                y: -(listViewSideStats.fontSize/2)
                //anchors.fill: parent
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                //verticalAlignment: Text.AlignTop

                color: Universal.accent
                text: model.macroarea_name
                clip: true

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
                clip: true

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
        }

        footer: Rectangle{
            id: footerRect
            width: listViewSideStats.width
            height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
            color: "transparent"

            Button{
                id: buttonAddSideStatsProgressBar
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 10

                width: parent.height / 1.5
                height: parent.height / 1.5

                background: Rectangle{
                                color: changeAlpha(Universal.foreground, 0.5)
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
