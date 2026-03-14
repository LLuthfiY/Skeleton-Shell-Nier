import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland

import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.user

import Qt5Compat.GraphicalEffects

Scope {
    Variants {
        model: Quickshell.screens
        Loader {
            active: UserConfig.ready
            sourceComponent: PanelWindow {
                id: root
                SystemClock {
                    id: systemClock
                    precision: SystemClock.Minutes
                }
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                WlrLayershell.layer: WlrLayer.Bottom
                WlrLayershell.namespace: "TimeDesktop"
                exclusionMode: ExclusionMode.Ignore
                color: "transparent"
                Rectangle {
                    id: background
                    anchors.fill: parent
                    color: ColorUtils.transparentize(Color.colors.background, UserConfig.options.timedesktop.opacity || 0.8)

                    layer.enabled: true

                    layer.effect: MultiEffect {
                        maskInverted: true
                        maskEnabled: true
                        maskSource: holeMaskSource
                        source: background
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }
                Item {
                    id: holeMaskSource
                    anchors.fill: parent

                    layer.enabled: true
                    visible: false
                    Text {
                        anchors.fill: parent

                        color: Color.colors.on_surface
                        text: Qt.formatTime(systemClock.date, "hh:mm")
                        font.weight: Font.Bold
                        font.pixelSize: Variable.uiScale(UserConfig.options.timedesktop.fontSize)
                        font.family: Variable.font.family.main
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
