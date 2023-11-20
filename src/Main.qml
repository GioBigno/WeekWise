import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    width: 1000
    height: 600
    visible: true
    title: qsTr("Week Planner")

    Universal.theme: Universal.Dark
    Universal.accent: Universal.Violet

    Image{
        id: image
        source: "qrc:/fonts/gameoflife.png"
    }

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
