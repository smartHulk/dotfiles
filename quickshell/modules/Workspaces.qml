import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    required property string screenName

    implicitWidth: layout.implicitWidth
    implicitHeight: 24

    // Mapping numéro de workspace -> icône
    // Modifiez selon vos besoins (émoji, glyphes Nerd Font, etc.)
    readonly property var workspaceIcons: ({
        1: "",   // web
        2: "",
        3: "󰒘",
        11: "",
        12: ""
            })

    function iconFor(id) {
        return root.workspaceIcons[id] !== undefined ? root.workspaceIcons[id] : id.toString()
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: Hyprland.workspaces.values

            delegate: Rectangle {
                id: wsDelegate
                required property var modelData

                property bool onThisScreen: {
                    if (!modelData.monitor) return true
                    if (typeof modelData.monitor === "string")
                        return modelData.monitor === root.screenName
                    return modelData.monitor.name === root.screenName
                }

                property int windowCount: modelData.toplevels
                    ? modelData.toplevels.values.length
                    : (modelData.windows || 0)

                visible: onThisScreen && (windowCount > 0 || modelData.active)
                implicitWidth: 24
                implicitHeight: 24
                color: modelData.active ? "#89b4fa" : "#313244"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    text: root.iconFor(wsDelegate.modelData.id)
                    color: wsDelegate.modelData.active ? "#11111b" : "#cdd6f4"
                    font.pixelSize: 18
                    font.bold: wsDelegate.modelData.active
                    font.family: "Symbols Nerd Font"  // important pour les glyphes
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + wsDelegate.modelData.id)
                }
            }
        }
    }
}