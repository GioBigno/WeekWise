import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

Popup {
    id: macroareaOptions

    width: 150
    height: implicitHeight
    padding: 0
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: Universal.background
        border.color: Universal.background
        radius: 2
    }

    property int iconsSize: 10
    property var renameMacroarea
    property var deleteMacroarea
    property var popupDeleteMacroarea

    Column {
        id: optionsMenu
        anchors.fill: parent
        spacing: 10

        OptionElement{
            anchors{
                left: parent.left
                right: parent.right
            }

            height: 22
            iconSource: "qrc:/icons/pencil.svg"
            textContent: qsTr("Rename")
            textColor: Universal.accent
            hoveredColor: Universal.foreground

            function clicked(mouse){
                macroareaOptions.renameMacroarea();
                macroareaOptions.close();
            }
        }

        OptionElement{
            anchors{
                left: parent.left
                right: parent.right
            }

            height: 22
            iconSource: "qrc:/icons/color-bucket.svg"
            textContent: qsTr("Change color")
            textColor: Universal.accent
            hoveredColor: Universal.foreground

            function clicked(mouse){
                //TODO
            }
        }

        OptionElement{
            anchors{
                left: parent.left
                right: parent.right
            }

            height: 22
            iconSource: "qrc:/icons/trash.svg"
            textContent: qsTr("Delete")
            textColor: Universal.accent
            hoveredColor: Universal.foreground

            function clicked(mouse){
                macroareaOptions.close();

                popupDeleteMacroarea.width = 300;
                popupDeleteMacroarea.height = 150;
                popupDeleteMacroarea.text = qsTr("Are you sure you want to delete this Macroareas and all the activities related to it?");
                popupDeleteMacroarea.fontText = fontLight.font;
                popupDeleteMacroarea.button1Text = qsTr("Yes");
                popupDeleteMacroarea.button2Text = qsTr("No");
                popupDeleteMacroarea.button1Clicked = deleteMacroarea;
                popupDeleteMacroarea.button2Clicked = nothing;
                popupDeleteMacroarea.open();
            }

            function deleteMacroarea(){
                macroareaOptions.deleteMacroarea();
                popupDeleteMacroarea.close();
            }

            function nothing(){
                popupDeleteMacroarea.close();
            }

        }

        OptionElement{
            anchors{
                left: parent.left
                right: parent.right
            }

            height: 22
            iconSource: "qrc:/icons/plus.svg"
            textContent: qsTr("Add Activity")
            textColor: Universal.accent
            hoveredColor: Universal.foreground

            function clicked(mouse){
                //TODO
            }
        }
    }
}
