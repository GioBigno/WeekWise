import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item {
    anchors.fill: parent

    GridLayout{
        id: grid
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.fillHeight: true

        columns: 8
        rows: 17
        columnSpacing: 5
        rowSpacing: 5

        Repeater{
            model: 16*7

            Rectangle{
                color: Qt.rgba(Universal.foreground.r, Universal.foreground.g, Universal.foreground.b, 0.3)
                Layout.fillWidth: true
                Layout.fillHeight: true

                width: (grid.width) / (grid.columns/2)

                Layout.column: (model.index % 7) + 1
                Layout.row: (model.index % 16) + 1
            }
        }

        Repeater{
            model: [qsTr("Lunedi"),
                    qsTr("Martedi"),
                    qsTr("Mercoledi"),
                    qsTr("Giovedi"),
                    qsTr("Venerdi"),
                    qsTr("Sabato"),
                    qsTr("Domenica")]

            Text {
                Layout.column: model.index + 1
                Layout.row: 0
                Layout.columnSpan: 1

                color: Universal.accent
                text: modelData.substring(0,3)

                font.pixelSize: 30
                font.family: customFont.name
            }
        }

        Repeater{
            model: 16

            Rectangle{
                Layout.fillHeight: true
                width: (grid.width - (grid.columnSpacing * (grid.columns - 1))) / (grid.columns)

                color: Qt.transparent

                Text{
                    Layout.column: 0
                    Layout.row: model.index + 1
                    Layout.columnSpan: 1

                    color: Universal.accent
                    text: (model.index + 7) + ":00"

                    font.pixelSize: 20
                    font.family: customFont.name
                }
            }
        }
    }
}
