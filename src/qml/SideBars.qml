import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12


ColumnLayout{
    id: listViewSideBars
    anchors.margins: 5
    spacing: 10

    property int fontSize: 30
    property int barHeight: 15
    property int space: 10

    Repeater{
        model: controller.getWeekTotalHoursStats()
        clip: true

        delegate: Rectangle{
            id: rectGoal
            Layout.fillHeight: true
            Layout.fillWidth: true
            width: listViewSideBars.width
            height: listViewSideBars.fontSize*2 + listViewSideBars.barHeight
            //anchors.fill: parent
            color: hoverHandler.hovered ? Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.2) : "transparent"
            radius: 8

            HoverHandler{
                id: hoverHandler
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
                width: parent.width
                height: listViewSideBars.barHeight

                borderColor: Universal.foreground
                backgroundColor: Universal.background
                fillColor: model.macroarea_color
                borderWidth: 1
                radius: 25
                progress: (model.total_logged_hours/model.total_planned_hours) > 1 ? 1 : (model.total_logged_hours/model.total_planned_hours)
            }
        }
    }

    Rectangle{
        id: footerRect
        Layout.fillHeight: true
        Layout.fillWidth: true
        width: listViewSideBars.width
        height: listViewSideBars.fontSize*2 + listViewSideBars.barHeight
        color: "transparent"

        Button{
            id: buttonAddSideStatsProgressBar
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 10

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
