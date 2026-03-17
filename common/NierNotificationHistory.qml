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

ColumnLayout {
    Rectangle {
        anchors.fill: parent
        color: Color.colors.surface_container_highest
    }
    spacing: 0

    Rectangle {
        id: header
        Layout.fillWidth: true
        Layout.preferredHeight: headerRow.height + Variable.margin.normal
        Layout.preferredWidth: notificationsList.width
        color: Color.colors.primary
        RowLayout {
            id: headerRow
            width: parent.width
            anchors.centerIn: parent
            Text {
                text: "Notifications"
                color: Color.colors.surface
                font.pixelSize: Variable.font.pixelSize.normal
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: Variable.margin.normal
            }
            Item {
                Layout.fillWidth: true
            }
            Rectangle {
                height: Variable.size.large
                width: Variable.size.large

                // color: deleteALlHoverHandler.hovered ? Color.colors.error_container : Color.colors.primary
                color: "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                LucideIcon {
                    id: icon
                    icon: "trash"
                    color: Color.colors.error
                    font.pixelSize: Variable.font.pixelSize.normal
                    anchors.centerIn: parent
                }
                HoverHandler {
                    id: deleteALlHoverHandler
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: {
                        Notification.discardAllNotifications();
                    }
                }
            }
            Item {
                width: Variable.margin.small
            }
        }
    }
    Rectangle {
        id: notificationsList
        // height: scrollView.height
        // width: scrollView.width
        color: Color.colors.surface_container_highest
        Layout.preferredHeight: scrollView.height + Variable.margin.normal
        Layout.preferredWidth: scrollView.width + Variable.margin.normal

        ListView {
            id: scrollView
            height: Variable.uiScale(700)
            spacing: Variable.margin.small
            clip: true
            width: contentItem.childrenRect.width
            anchors.centerIn: parent
            model: ScriptModel {
                values: [...Notification.listSorted]
            }
            delegate: NierNotificationItem {
                popup: false
                notificationObject: modelData
            }
        }
    }
}
