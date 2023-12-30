import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: app
    width: screen.width/2
    height: screen.height/2
    visible: true
    title: qsTr("WeekWise")

    Universal.theme: Universal.Dark
    Universal.accent: Qt.color("#D6D5A8")
    Universal.foreground:  Qt.color("#8370A0")
    Universal.background: Qt.color("#192128")

    FontLoader{
        id: customFont
        source: "qrc:/fonts/font.ttf"
    }

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle{

            Layout.preferredWidth: 40
            Layout.fillHeight: true
            color: Qt.rgba(Qt.color("black").r, Qt.color("black").g, Qt.color("black").b, 0.15)

            ColumnLayout{
                id: tabBarLayout
                anchors.fill: parent
                spacing: 10

                Rectangle{
                    // !! this rectangle is here just for padding !!
                    Layout.alignment: Qt.AlignTop
                    Layout.fillHeight: true
                    Layout.preferredHeight: parent.width
                    Layout.preferredWidth: parent.width

                    color: "transparent"
                }

                TabButton {
                    //Layout.alignment: Qt.AlignBottom
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: parent.width
                    Layout.preferredWidth: parent.width
                    Layout.maximumHeight: parent.width

                    IconImage{
                        anchors.fill: parent
                        anchors.margins: 5
                        source: "qrc:/icons/icons/calendar.svg"
                        color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
                    }

                    checked: true
                    onClicked: console.log("calendar")
                }

                TabButton {
                    //Layout.alignment: Qt.AlignBottom
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: parent.width
                    Layout.preferredWidth: parent.width
                    Layout.maximumHeight: parent.width

                    IconImage{
                        anchors.fill: parent
                        anchors.margins: 5
                        source: "qrc:/icons/icons/statistics.png"
                        color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
                    }

                    onClicked: console.log("stats")
                }

                TabButton {
                    Layout.alignment: Qt.AlignBottom
                    Layout.fillHeight: true
                    Layout.preferredHeight: parent.width
                    Layout.preferredWidth: parent.width
                    Layout.maximumHeight: parent.width
                    Layout.bottomMargin: 10

                    IconImage{
                        anchors.fill: parent
                        anchors.margins: 5
                        source: "qrc:/icons/icons/task_management.svg"
                        color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
                    }

                    onClicked: console.log("management")
                }
            }

        }

        StackView {
            id: stackView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 5
            //initialItem: homeComponent
            focus: true

            Component.onCompleted: {
                controller.pushWeekView();
            }
        }
    }

    Component{
        id: weekView
        WeekView{}
    }

    Controller{
        id: controller
    }
}
