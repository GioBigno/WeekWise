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
        id: fontMedium
        source: "qrc:/fonts/Roboto-Medium.ttf"
    }

    FontLoader{
        id: fontLight
        source: "qrc:/fonts/Roboto-Light.ttf"
    }

    property int currentPage: 0

    function loadPage(page){

        if(page === currentPage){
            return;
        }

        stackView.clear();
        currentPage = page;

        switch(page){
        case 1:
            controller.pushWeekView();
            break;
        case 2:
            controller.pushStatsView();
            break;
        case 3:
            controller.pushManagementView();
            break;
        }
    }

    Rectangle{
        id: tabBar

        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: 40

        color: Qt.rgba(Qt.color("black").r, Qt.color("black").g, Qt.color("black").b, 0.15)

        TabButton {
            id: tabButtonCalendar

            anchors {
                left: parent.left
                right: parent.right
                bottom: tabButtonStats.top
                bottomMargin: 10
            }

            width: parent.width
            height: parent.width

            IconImage{
                anchors.fill: parent
                anchors.margins: 5
                source: "qrc:/icons/calendar.svg"
                color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
            }

            checked: true
            onClicked: {
                loadPage(1);
            }

        }

        TabButton {
            id: tabButtonStats

            anchors {
                left: parent.left
                right: parent.right
                bottom: tabButtonManagement.top
                bottomMargin: 10
            }

            width: parent.width
            height: parent.width

            IconImage{
                anchors.fill: parent
                anchors.margins: 5
                source: "qrc:/icons/statistics.png"
                color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
            }

            onClicked: {
                loadPage(2);
            }
        }

        TabButton {
            id: tabButtonManagement

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 10
            }

            width: parent.width
            height: parent.width

            IconImage{
                anchors.fill: parent
                anchors.margins: 5
                source: "qrc:/icons/task_management.svg"
                color: (parent.hovered || parent.checked) ? Universal.accent : Universal.foreground
            }

            onClicked: {
                loadPage(3);
            }
        }
    }

    StackView {
        id: stackView

        anchors {
            top: parent.top
            bottom: parent.bottom
            left:tabBar.right
            right: parent.right
            leftMargin: 5
        }

        focus: true

        Component.onCompleted: {
            loadPage(1);
        }
    }

    Controller{
        id: controller
    }
}
