import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Universal 2.12

Item {

    RowLayout{
        anchors.fill: parent

        Column {
            //anchors.fill: parent

            TabButton {
                text: "Tab 1"
                onClicked: console.log("Tab 1 clicked")
            }

            TabButton {
                text: "Tab 2"
                onClicked: console.log("Tab 2 clicked")
            }

            TabButton {
                text: "Tab 3"
                onClicked: console.log("Tab 3 clicked")
            }
        }
    }



}
