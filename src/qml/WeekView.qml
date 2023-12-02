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

        columns: 7
        columnSpacing: 5
        rowSpacing: 5

        Repeater{

            model: [Universal.theme, Universal.accent, Universal.foreground, Universal.background];

            Rectangle{
                color: modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
