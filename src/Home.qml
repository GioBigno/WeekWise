import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Universal 2.12

Item {

    Universal.theme: Universal.Dark
    Universal.accent: Universal.Violet

    RowLayout{
        anchors.fill: parent

        RoundButton {

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            Layout.margins: 100
            radius: 5

            text: "Week"
            font.pixelSize: 30
        }

        RoundButton {

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            Layout.margins: 100
            radius: 5

            text: "Stats"
            font.pixelSize: 30
        }
    }

}
