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

        ColumnLayout{
            //anchors.fill: parent
            Layout.preferredWidth: 40

            Rectangle{
                // !! this rectangle is here just for padding !!
                Layout.alignment: Qt.AlignBottom
                Layout.fillHeight: true
                Layout.preferredHeight: parent.width
                Layout.preferredWidth: parent.width

                color: "transparent"
            }

            TabButton {
                Layout.alignment: Qt.AlignBottom
                Layout.fillHeight: true
                Layout.preferredHeight: parent.width
                Layout.preferredWidth: parent.width
                Layout.maximumHeight: parent.width

                IconImage{
                    anchors.fill: parent
                    source: "qrc:/icons/icons/setting3.svg"
                    color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
                }

                onClicked: console.log("Tab 2 clicked")
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
