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

    // Loader {
    //     active: GlobalState.dashboardOpen
    //
    //     sourceComponent: PanelWindow {
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

        property var windowMargin: Margin.windowMargin()

        margins {
            top: windowMargin.top
            bottom: windowMargin.bottom
            left: windowMargin.left
            right: windowMargin.right
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

        Loader {
            active: GlobalState.dashboardOpen
            anchors.right: parent.right
            anchors.top: parent.top
            sourceComponent: NierMediaPlayer {}
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
// }
