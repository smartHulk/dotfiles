import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    implicitHeight: 32
    color: "#1e1e2e"

    anchors {
        top: true
        left: true
        right: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 6

        RowLayout {
            id: workspaces
            spacing: 6

            Repeater {
                model: Hyprland.workspaces.values

                delegate: Rectangle {
                    id: wsDelegate
                    required property var modelData

                    implicitWidth: 28
                    implicitHeight: 24
                    radius: 6
                    color: modelData.active ? "#89b4fa" : "#313244"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: wsDelegate.modelData.id
                        color: wsDelegate.modelData.active ? "#11111b" : "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: wsDelegate.modelData.active
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + wsDelegate.modelData.id)
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm:ss - dd/MM/yyyy")
            color: "#cdd6f4"
            font.pixelSize: 13

            SystemClock {
                id: clock
                precision: SystemClock.Seconds
            }
        }
    }
}
