import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

Item {

    function weekTotalHoursStatsChanged(){
        //currently useless
        //can be usefull if you want to add animation when stats changes
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

        delegate: Rectangle{
            id: rectGoal
            width: listViewSideStats.width
            height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
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

                    }
                }

            }
        }

        footer: Rectangle{
                    id: footerRect
                    width: listViewSideStats.width
                    height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
                    color: "transparent"

                    Rectangle{
                        y: listViewSideStats.spacing
                        width: listViewSideStats.width
                        height: listViewSideStats.fontSize*2 + listViewSideStats.barHeight
                        //anchors.fill: parent
                        color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.1)
                        radius: 8

                        Button{
                            id: buttonAddSideStatsProgressBar
                            anchors.centerIn: parent

                            width: parent.height / 1.5
                            height: parent.height / 1.5

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

                            }
                        }
                    }
                }
    }
}
