import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets

import qs.services

ColumnLayout {
    id: root
    spacing: Variable.margin.small
    RowLayout {

        Rectangle {
            id: powerButton
            width: Variable.size.larger
            height: Variable.size.larger
            // border.width: Variable.uiScale(2)
            // border.color: powerHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
            // color: powerHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
            color: powerHoverHandler.hovered ? Color.colors.surface : Color.colors.primary
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: powerHoverHandler
            }
            TapHandler {
                onTapped: {
                    powerMenu.open();
                }
            }
            // Behavior on border.color {
            //     ColorAnimation {
            //         duration: 200
            //     }
            // }
            LucideIcon {
                id: powerIcon
                anchors.centerIn: parent
                icon: "power"
                // color: powerHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                color: powerHoverHandler.hovered ? Color.colors.on_surface : Color.colors.surface
                // color: Color.colors.primary
            }
            Menu {
                id: powerMenu
                padding: Variable.margin.small
                implicitWidth: Variable.uiScale(200)
                y: powerButton.height + Variable.margin.small
                background: Rectangle {
                    id: backgroundMenu
                    color: Color.colors.surface
                }

                Instantiator {
                    model: [
                        {
                            "icon": "power",
                            "text": "Power Off",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "poweroff"]);
                            }
                        },
                        {
                            "icon": "rotate-ccw",
                            "text": "Restart",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "reboot"]);
                            }
                        },
                        {
                            "icon": "moon",
                            "text": "Suspend",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "suspend"]);
                            }
                        },
                        {
                            "icon": "log-out",
                            "text": "Logout",
                            "action": function () {
                                Quickshell.execDetached(["hyprctl", "dispatch", "exit"]);
                            }
                        },
                        {
                            "icon": "lock",
                            "text": "Lock",
                            "action": function () {
                                // Quickshell.execDetached(["hyprlock"]);
                                if (Config.options.modules.lockscreen) {
                                    GlobalState.screenLocked = true;
                                }
                            }
                        }
                    ].reverse()

                    onObjectAdded: function (index, item) {
                        powerMenu.addItem(item);
                    }

                    onObjectRemoved: function (index, item) {
                        powerMenu.removeItem(item);
                    }

                    delegate: MenuItem {
                        background: Rectangle {
                            color: Color.colors.surface

                            Rectangle {
                                width: menuHoverHandler.hovered ? parent.width : 0
                                height: parent.height
                                color: Color.colors.primary
                                Behavior on width {
                                    NumberAnimation {
                                        duration: 200
                                    }
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            TapHandler {
                                onTapped: modelData.action()
                            }
                        }
                        HoverHandler {
                            id: menuHoverHandler
                            onHoveredChanged: {
                                if (hovered) {
                                    icon.color = Color.colors.surface;
                                } else {
                                    unHoverTimer.running = true;
                                }
                            }
                        }
                        Timer {
                            id: unHoverTimer
                            interval: 200
                            onTriggered: {
                                icon.color = Color.colors.on_surface;
                            }
                        }
                        contentItem: RowLayout {
                            id: icon
                            property string color: Color.colors.on_surface
                            // LucideIcon {
                            //     id: icon
                            //     Layout.fillWidth: true
                            //     icon: modelData.icon
                            //     label: modelData.text
                            //     // color: Color.colors.on_surface
                            // }
                            Rectangle {
                                id: iconBackground
                                width: Variable.size.normal
                                height: Variable.size.normal
                                color: icon.color
                            }
                            Text {
                                id: text
                                Layout.fillWidth: true
                                text: modelData.text
                                color: icon.color
                                font.pixelSize: Variable.font.pixelSize.normal
                                font.family: Variable.font.family.main
                                font.weight: Font.Normal
                            }
                        }
                        onTriggered: modelData.action()
                    }
                }
            }
        }
        Rectangle {
            width: Variable.size.larger
            height: Variable.size.larger

            HoverHandler {
                id: settingsHoverHandler
            }
            color: settingsHoverHandler.hovered ? Color.colors.surface : Color.colors.primary
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            TapHandler {
                onTapped: {
                    GlobalState.dashboardOpen = false;
                    GlobalState.settingsOpen = true;
                }
            }
            LucideIcon {
                id: settingsIcon
                anchors.centerIn: parent
                icon: "settings"
                // color: powerHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                color: settingsHoverHandler.hovered ? Color.colors.on_surface : Color.colors.surface
                // color: Color.colors.primary
            }
        }
    }
    ColumnLayout {
        Rectangle {
            id: graphSystem
            width: Variable.uiScale(300)
            height: Variable.uiScale(150)
            color: Color.colors.surface

            property list<real> cpuUsage: [0, 0, 0, 0, 0, 0, 0, 0]
            property list<real> ramUsage: [0, 0, 0, 0, 0, 0, 0, 0]

            Connections {
                target: CPU
                function onCpuUpdated() {
                    graphSystem.cpuUsage = [...graphSystem.cpuUsage, CPU.cpuUsage].slice(1);
                }
            }

            Connections {
                target: RAM
                function onRamUpdated() {
                    graphSystem.ramUsage = [...graphSystem.ramUsage, RAM.ramUsage].slice(1);
                }
            }

            LineChart {
                color: Color.colors.secondary
                anchors.fill: parent
                points: graphSystem.ramUsage
                drawBottomLine: true
                outline: true
                outlineColor: Color.colors.primary
            }
            LineChart {
                color: Color.colors.tertiary
                anchors.fill: parent
                points: graphSystem.cpuUsage
                drawBottomLine: true
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: usageSystemText.height + Variable.margin.normal
            color: Color.colors.primary
            RowLayout {
                id: usageSystemText
                anchors.centerIn: parent
                Text {
                    text: "CPU: " + CPU.cpuUsage + "%"
                    color: Color.colors.tertiary
                    font.pixelSize: Variable.font.pixelSize.normal
                    font.family: Variable.font.family.main
                    font.weight: Font.Normal
                }
                Text {
                    text: "RAM: " + RAM.ramUsage + "%"
                    color: Color.colors.secondary
                    font.pixelSize: Variable.font.pixelSize.normal
                    font.family: Variable.font.family.main
                    font.weight: Font.Normal
                }
            }
        }
    }
}
