import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

Item {

    GridLayout{
        id: grid
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.fillHeight: true

        columns: 8
        rows: 16
        columnSpacing: 5
        rowSpacing: 5

        Repeater{

            model: 16

            Text {
                Layout.column: 0
                Layout.row: model.index

                color: Universal.accent
                text: (model.index + 7) + ":00"

                font.pixelSize: 20
                font.family: customFont.name
            }
        }

        Repeater{

            model: 16*7

            Rectangle{
                color: "gray"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.column: (model.index % 7)+1
                Layout.row: model.index % 16
            }
        }
    }
}
