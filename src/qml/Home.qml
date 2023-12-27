import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Universal 2.12

Item {

    RowLayout{
        anchors.fill: parent

        RoundButton {

            implicitWidth: 200
            implicitHeight: 200

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            Layout.rightMargin: 50
            Layout.topMargin: 100
            Layout.bottomMargin: 100
            Layout.leftMargin: 100
            radius: 5

            text: "Week"
            font.pixelSize: Math.min(width, height)/6
            font.family: customFont.name

            onPressed: {
                controller.pushWeekView()
            }
        }

        RoundButton {

            implicitWidth: 200
            implicitHeight: 200

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            Layout.rightMargin: 100
            Layout.topMargin: 100
            Layout.bottomMargin: 100
            Layout.leftMargin: 50
            radius: 5

            text: "Stats"
            font.pixelSize: Math.min(width, height)/6
            font.family: customFont.name

            onPressed: {
                controller.pushStatsView()
            }
        }
    }

    Component{
        id: weekViewComponent
        WeekView{}
    }

}
