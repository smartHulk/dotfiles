// modules/Clock.qml
import QtQuick
import "../services"
import "."

Item {
    id: root
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight
    property alias popupVisible: waffle.visible

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        color: "#ffffff"
        font.pixelSize: 14
        // font.bold: true
        text: Time.time
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: waffle.visible = !waffle.visible
    }

    WaffleMenu {
        id: waffle
        visible: false
        anchorItem: root
    }
}