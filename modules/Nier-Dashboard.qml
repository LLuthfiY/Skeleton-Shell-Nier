import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.services
import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.modules.common.functions

Scope {
    PanelWindow {
        id: root
        visible: GlobalState.dashboardOpen

        WlrLayershell.namespace: "quickshell:NierDashboard"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        property string position: Config.options.notification.position.toLowerCase()

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
        }

        margins {
            top: (Config.options.bar.position === "top" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
            bottom: (Config.options.bar.position === "bottom" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
            left: (Config.options.bar.position === "left" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
            right: (Config.options.bar.position === "right" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
        }

        color: "transparent"
        implicitWidth: Variable.size.notificationPopupWidth

        MouseArea {
            anchors.fill: parent
            onClicked: GlobalState.dashboardOpen = false
        }

        NierNotificationHistory {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        NierMediaPlayer {
            anchors.right: parent.right
            anchors.top: parent.top
        }

        NierDashboardSystem {
            anchors.left: parent.left
            anchors.top: parent.top
        }

        NierCalendar {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
    }
}
