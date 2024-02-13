import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item{

    ScrollView{
        id: scrollView
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 10

            Repeater{

                model: controller.getMacroareas()

                Column{
                    id: macroarea

                    property int macroarea_id: model.id
                    property bool expanded: false

                    spacing: 15

                    Rectangle{
                        id: macroareaRect
                        width:  macroareaTitle.contentWidth + icon.width + macroareaTitle.anchors.leftMargin
                        height: 25

                        color: "transparent"

                        function rename(){
                            macroareaMouseArea.enabled = false;
                            macroareaTitle.readOnly = false;
                            macroareaTitle.selectByMouse = true;
                        }

                        IconImage{
                            id: icon

                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                left: parent.left
                            }

                            width: 10
                            height: 10

                            source: "qrc:/icons/triangle.svg"
                            color: model.color
                            rotation: macroarea.expanded ? 180 : 90
                        }

                        TextInput{
                            id: macroareaTitle

                            anchors{
                                top: parent.top
                                bottom: parent.bottom
                                left: icon.right
                                right: parent.right
                                leftMargin: 10
                            }

                            verticalAlignment: Text.AlignVCenter

                            readOnly: true
                            selectByMouse: false

                            onEditingFinished: {
                                        readOnly = true;
                                        selectByMouse = false;
                                        macroareaMouseArea.enabled = true;

                                        controller.renameMacroarea(model.id, macroareaTitle.text.trim());
                            }

                            text: model.name
                            color: Universal.accent
                            font.pointSize: 15
                            font.family: fontMedium.name
                        }

                        MouseArea{
                            id: macroareaMouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: (mouse) => {
                                           if (mouse.button === Qt.RightButton) {

                                               let pos = mapToItem(scrollView, mouse.x, mouse.y)

                                               popupMacroareaOptions.x = pos.x;
                                               popupMacroareaOptions.y = pos.y;
                                               popupMacroareaOptions.rename = macroareaRect.rename;

                                               popupMacroareaOptions.open();
                                           } else if (mouse.button === Qt.LeftButton) {
                                               macroarea.expanded = !macroarea.expanded;
                                           }
                                       }
                        }
                    }


                    Repeater{

                        model: controller.getActivities()

                        Rectangle{

                            visible: (macroarea.expanded  && model.macroarea_id === macroarea.macroarea_id)
                            x: 40

                            width:  activityTitle.implicitWidth
                            height: 25

                            color: "transparent"

                            Text{
                                id: activityTitle

                                anchors.fill:parent

                                verticalAlignment: Text.AlignVCenter

                                text: model.name
                                color: Universal.accent
                                font.pointSize: 15
                                font.family: fontMedium.name
                            }
                        }

                    }
                }
            }
        }
    }

    PopupMacroareaOptions{
        id: popupMacroareaOptions
    }

}
