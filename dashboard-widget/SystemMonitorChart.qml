import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Mpris

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

import qs.services

RowLayout {
    id: root
    property list<real> cpu: [0, 0, 0, 0, 0]
    property list<real> memory: [0, 0, 0, 0, 0]
    Connections {
        target: CPU
        function onCpuUpdated() {
            root.cpu = [root.cpu[1], root.cpu[2], root.cpu[3], root.cpu[4], Math.ceil(CPU.cpuUsage)];
        }
    }
    Connections {
        target: RAM
        function onRamUpdated() {
            root.memory = [root.memory[1], root.memory[2], root.memory[3], root.memory[4], Math.ceil(RAM.ramUsage)];
        }
    }
    Rectangle {
        // Layout.fillWidth: true
        Layout.preferredWidth: info.implicitWidth
        Layout.preferredHeight: Variable.uiScale(60)
        color: "transparent"
        ColumnLayout {
            id: info
            anchors.verticalCenter: parent.verticalCenter
            RowLayout {
                ColumnLayout {
                    spacing: Variable.margin.small
                    LucideIcon {
                        icon: "memory-stick"
                        label: "RAM:"
                        color: Color.colors.primary
                        font.pixelSize: Variable.font.pixelSize.smaller
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: Variable.margin.small
                    }
                    LucideIcon {
                        icon: "cpu"
                        label: "CPU:"
                        color: Color.colors.tertiary
                        font.pixelSize: Variable.font.pixelSize.smaller
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: Variable.margin.small
                    }
                }
                ColumnLayout {
                    spacing: Variable.margin.small
                    Text {
                        text: RAM.ramUsage + "%"
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.smaller
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: Variable.margin.small
                    }
                    Text {
                        text: CPU.cpuUsage + "%"
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.smaller
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: Variable.margin.small
                    }
                }
            }
        }
    }
    Rectangle {
        id: chart
        Layout.fillWidth: true
        Layout.preferredHeight: Variable.uiScale(60)
        color: "transparent"
        LineChart {
            color: Color.colors.primary
            anchors.fill: parent
            points: root.memory
            drawBottomLine: true
        }
        LineChart {
            color: Color.colors.tertiary
            anchors.fill: parent
            points: root.cpu
            drawBottomLine: true
        }
    }
}
