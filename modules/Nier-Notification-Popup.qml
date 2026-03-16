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
        visible: (Notification.popupList.length > 0) && !GlobalState.screenLocked && !GlobalState.dashboardOpen

        WlrLayershell.namespace: "quickshell:notificationPopup"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        property string position: Config.options.notification.position.toLowerCase()

        anchors {
            top: true
            bottom: true
            left: position.includes("left")
            right: position.includes("right")
        }

        margins {
            top: (Config.options.bar.position === "top" ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
            bottom: (Config.options.bar.position === "bottom" ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
            left: (Config.options.bar.position === "left" ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
            right: (Config.options.bar.position === "right" ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
        }

        mask: Region {
            item: listview.contentItem
        }

        color: "transparent"
        implicitWidth: Variable.size.notificationPopupWidth

        ListView {
            id: listview
            spacing: Variable.margin.small
            anchors.fill: parent
            anchors.margins: 0

            model: ScriptModel {
                values: Notification.popupList
            }
            delegate: NierNotificationItem {
                height: 0
                Component.onCompleted: height = content.height
                Behavior on height {
                    NumberAnimation {
                        duration: Variable.animation.duration
                        easing.type: Easing.OutQuad
                    }
                }
                notificationObject: modelData
            }
        }
    }
}
