import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: app
    width: screen.width
    height: screen.height
    visible: true
    title: qsTr("Week Planner")

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
