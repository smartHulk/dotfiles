import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "modules"

ShellRoot {
    id: shellRoot

    // Référence globale vers l'horloge de l'écran principal (pour toggle le waffle)
    property var primaryClock: null

    GlobalShortcut {
        name: "toggle-waffle"
        description: "Ouvre/ferme le menu Démarrer"
        appid: "quickshell"

        onPressed: {
            if (shellRoot.primaryClock) {
                shellRoot.primaryClock.waffleMenu.visible = !shellRoot.primaryClock.waffleMenu.visible
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30

            color: "#e01e1e2e"

            RowLayout {
                anchors.fill: parent

                // Zone centrale : workspaces
                Workspaces {
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter
                    screenName: bar.modelData.name
                }


                Clock {
                    id: clockWidget
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    Layout.alignment: Qt.AlignVCenter

                    Component.onCompleted: {
                        // On ne garde la référence que pour l'écran principal
                        if (bar.modelData.name === Quickshell.screens[0].name) {
                            shellRoot.primaryClock = clockWidget
                        }
                    }
                }
            }
        }
    }
}