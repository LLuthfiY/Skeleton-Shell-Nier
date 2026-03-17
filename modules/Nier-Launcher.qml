import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services

Scope {
    id: root
    // property var application: ScriptModel {
    //     values: AppSearch.fuzzyQuery(searchInput.text)
    //     // values: searchInput.text != "" ? DesktopEntries.applications.values.filter(app => app.name.toLowerCase().includes(searchInput.text.toLowerCase())).sort((a, b) => a.name.localeCompare(b.name)).sort((a, b) => a.name.toLowerCase().indexOf(searchInput.text.toLowerCase()) - b.name.toLowerCase().indexOf(searchInput.text.toLowerCase())) : DesktopEntries.applications.values.filter(a => true).sort((a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase()))
    // }
    Loader {
        active: GlobalState.launcherOpen
        sourceComponent: PanelWindow {
            id: launcherWindow
            property var application: AppSearch.fuzzyQuery(searchInput.text)
            // screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

            WlrLayershell.namespace: "quickshell:NierLauncher"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.layer: WlrLayer.Overlay
            exclusiveZone: 0

            implicitWidth: Variable.uiScale(500)
            implicitHeight: Variable.uiScale(500)
            color: "transparent"

            // HyprlandFocusGrab {
            //     id: grab
            //     active: true
            //     windows: [launcherWindow]
            // }
            margins {
                top: (Config.options.bar.position === "top" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
                bottom: (Config.options.bar.position === "bottom" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
                left: (Config.options.bar.position === "left" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
                right: (Config.options.bar.position === "right" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: Config.options.bar.position !== "right"
            anchors.right: Config.options.bar.position === "right"

            Rectangle {
                anchors.fill: parent
                color: Color.colors.surface
                border.color: Color.colors.surface_container_high
                border.width: 1
                BackgroundPattern {
                    anchors.fill: parent
                    color: Color.colors.surface_container_high
                }
            }
            ColumnLayout {
                anchors.fill: parent
                spacing: Variable.margin.small
                RowLayout {
                    Rectangle {
                        anchors.fill: parent
                        color: Color.colors.surface_container
                    }
                    LucideIcon {
                        icon: "search"
                    }
                    TextField {
                        id: searchInput
                        Layout.fillWidth: true
                        height: Variable.uiScale(40)
                        width: parent.width
                        padding: Variable.margin.small
                        font.pixelSize: Variable.font.pixelSize.normal
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        focus: true
                        background: Rectangle {
                            color: Color.colors.surface_container
                            radius: Variable.radius.small
                        }
                        color: Color.colors.on_surface_variant

                        onAccepted: {
                            launcherList.currentItem.execute();
                            GlobalState.launcherOpen = false;
                        }
                        // onTextChanged: {
                        //     launcherList.currentIndex = 0;
                        // }
                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                GlobalState.launcherOpen = false;
                            }
                            if (event.key === Qt.Key_Tab) {
                                if (launcherList.currentIndex + 1 >= launcherList.count) {
                                    launcherList.currentIndex = 0;
                                } else {
                                    launcherList.currentIndex += 1;
                                }
                            }
                            if (event.key === Qt.Key_Backtab) {
                                if (launcherList.currentIndex - 1 < 0) {
                                    launcherList.currentIndex = launcherList.count - 1;
                                } else {
                                    launcherList.currentIndex -= 1;
                                }
                            }
                        }
                    }
                }
                ListView {
                    id: launcherList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: launcherWindow.application

                    delegate: Rectangle {
                        width: parent.parent.width ?? 0
                        height: appDelegate.height
                        color: "transparent"
                        ToggledListButton {
                            id: appDelegate
                            anchors.verticalCenter: parent.verticalCenter
                            mData: modelData
                            toggled: launcherList.currentIndex === index || listButtonHoverHandler.hovered
                            width: parent.width ?? 0
                            animationDuration: 150
                            HoverHandler {
                                id: listButtonHoverHandler
                                cursorShape: Qt.PointingHandCursor
                            }
                            // contentComponent: RowLayout {
                            //     spacing: Variable.margin.small
                            //     property bool toggled: launcherList.currentIndex === index || listButtonHoverHandler.hovered
                            //     Rectangle {
                            //         id: square
                            //         width: Variable.uiScale(16)
                            //         height: width
                            //         color: Color.colors.primary
                            //     }
                            //     Text {
                            //         id: appName
                            //         text: modelData.name
                            //         Layout.fillWidth: true
                            //         font.family: Variable.font.family.main
                            //         font.weight: Font.Normal
                            //         color: Color.colors.primary
                            //     }
                            //     Timer {
                            //         id: titleUnToggledTimer
                            //         interval: 150
                            //         repeat: false
                            //         onTriggered: {
                            //             appName.color = Color.colors.primary;
                            //             square.color = Color.colors.primary;
                            //         }
                            //     }
                            //     onToggledChanged: {
                            //         if (toggled) {
                            //             appName.color = Color.colors.surface;
                            //             square.color = Color.colors.surface;
                            //         } else {
                            //             titleUnToggledTimer.running = true;
                            //         }
                            //     }
                            // }
                        }
                        function execute() {
                            GlobalState.launcherOpen = false;
                            if (modelData.runInTerminal) {
                                Quickshell.execDetached(["kitty", "-d", Directory.home.replace("file://"), "bash", "-c", modelData.execString]);
                            } else {
                                modelData.execute();
                            }
                        }
                        TapHandler {
                            onTapped: {
                                execute();
                            }
                        }
                    }
                    // delegate: Rectangle {
                    //     id: appDelegate
                    //     required property DesktopEntry modelData
                    //     required property int index
                    //     color: "transparent"
                    //     height: row.height
                    //     width: parent?.parent.width ?? 0
                    //     radius: Variable.radius.small
                    //     function execute() {
                    //         GlobalState.launcherOpen = false;
                    //         if (modelData.runInTerminal) {
                    //             Quickshell.execDetached(["kitty", "-d", Directory.home.replace("file://"), "bash", "-c", modelData.execString]);
                    //         } else {
                    //             modelData.execute();
                    //         }
                    //     }
                    //     Rectangle {
                    //         anchors.left: parent.left
                    //         width: Variable.uiScale(2)
                    //         height: parent.height / 2
                    //         anchors.verticalCenter: parent.verticalCenter
                    //         color: launcherList.currentIndex === index || hoverHandler.hovered ? Color.colors.primary : "transparent"
                    //         Behavior on color {
                    //             ColorAnimation {
                    //                 duration: 200
                    //             }
                    //         }
                    //     }
                    //     RowLayout {
                    //         id: row
                    //         spacing: 0
                    //         width: parent.width
                    //         height: Variable.size.huge
                    //
                    //         IconImage {
                    //             Layout.margins: Variable.margin.small
                    //             Layout.leftMargin: Variable.margin.normal
                    //             Layout.fillHeight: true
                    //             Layout.preferredWidth: Variable.size.larger
                    //             source: Quickshell.iconPath(appDelegate.modelData.icon, "image-missing")
                    //         }
                    //         Text {
                    //             text: appDelegate.modelData.name
                    //             Layout.fillWidth: true
                    //             Layout.leftMargin: Variable.margin.small
                    //             font.family: Variable.font.family.main
                    //             font.weight: Font.Normal
                    //             color: ListView.isCurrentItem ? Color.colors.on_primary : Color.colors.on_surface
                    //         }
                    //     }
                    //     TapHandler {
                    //         onTapped: {
                    //             appDelegate.execute();
                    //         }
                    //     }
                    //
                    //     HoverHandler {
                    //         id: hoverHandler
                    //     }
                    //     Behavior on color {
                    //         ColorAnimation {
                    //             duration: 200
                    //         }
                    //     }
                    // }
                }
            }
        }
    }
}
