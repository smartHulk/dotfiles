import QtQuick
import QtQuick.Layouts
import Quickshell
import "."

PopupWindow {
    id: waffle
    required property Item anchorItem

    anchor.item: anchorItem
    anchor.rect.x: 0
    anchor.rect.y: anchorItem.height + 5

    implicitWidth: 420
    implicitHeight: 520
    color: "transparent"

    AppFinder {
        id: appFinder
    }

    property var filteredApps: {
        if (!appFinder.loaded) return []
        if (searchInput.text.length === 0) return appFinder.apps
        return appFinder.apps.filter(app =>
            app.name.toLowerCase().includes(searchInput.text.toLowerCase())
        )
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#e01e1e2e"
        border.color: "#45475a"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Barre de recherche
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 36
                radius: 8
                color: "#313244"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        text: "🔍"
                        color: "#cdd6f4"
                        font.pixelSize: 14
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        clip: true

                        Text {
                            anchors.fill: parent
                            text: "Rechercher une application"
                            color: "#6c7086"
                            font.pixelSize: 13
                            visible: searchInput.text.length === 0
                        }
                    }
                }
            }

            Text {
                text: appFinder.loaded
                      ? waffle.filteredApps.length + " application(s)"
                      : "Chargement..."
                color: "#cdd6f4"
                font.pixelSize: 13
                font.bold: true
            }

            // Grille d'applications avec scroll
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: appGrid.implicitHeight
                clip: true

                GridLayout {
                    id: appGrid
                    width: parent.width
                    columns: 4
                    rowSpacing: 16
                    columnSpacing: 8

                    Repeater {
                        model: waffle.filteredApps

                        delegate: ColumnLayout {
                            id: appDelegate
                            required property var modelData
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 6

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 56
                                height: 56
                                radius: 10
                                color: appMouse.containsMouse ? "#45475a" : "#313244"

                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    source: "image://icon/" + appDelegate.modelData.icon
                                    width: 32
                                    height: 32
                                }

                                MouseArea {
                                    id: appMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        appFinder.launch(appDelegate.modelData.exec)
                                        waffle.visible = false
                                        searchInput.text = ""
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.maximumWidth: 80
                                text: appDelegate.modelData.name
                                color: "#cdd6f4"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                            }
                        }
                    }
                }
            }

            // Séparateur
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: "#45475a"
            }

            // Pied de menu
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#89b4fa"

                    Text {
                        anchors.centerIn: parent
                        text: "👤"
                        font.pixelSize: 14
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: Quickshell.env("USER") || "Utilisateur"
                    color: "#cdd6f4"
                    font.pixelSize: 13
                }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: powerMouse.containsMouse ? "#45475a" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        color: "#f38ba8"
                        font.pixelSize: 15
                    }

                    MouseArea {
                        id: powerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                    }
                }
            }
        }
    }
}