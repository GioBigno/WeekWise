import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12
import "macroareaList"

Item{
    id: managementView

    Text{
        id: pageTitle
        anchors{
            top: parent.top
            left: parent.left
            margins: 10
        }

        verticalAlignment: Text.AlignVCenter

        text: qsTr("Macroareas & activities")
        color: Universal.accent
        font.pointSize: 26
        font.family: fontMedium.name
    }

    MacroareasList{
        anchors {
            top: pageTitle.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }
    }
}
