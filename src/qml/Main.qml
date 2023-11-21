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
    Universal.accent: Universal.Violet

    FontLoader {
        id: customFont
        source: "qrc:/fonts/Monocraft.ttf"
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homeComponent
        focus: true

        property var back: function(){
            if(stackView.depth > 1) {
                stackView.pop();
            }
            if(stackView.depth === 1){
                // niente
            }
        }

        Keys.onBackPressed: back()
    }

    Component{
        id: homeComponent
        Home{}
    }

}
