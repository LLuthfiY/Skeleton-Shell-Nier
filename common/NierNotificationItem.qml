import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.services
import qs.modules.common
import qs.modules.common.user
import qs.modules.common.functions
import qs.modules.common.widgets

Item {
    id: root
    property var notificationObject
    property bool pendingClose: notificationObject.pendingClose
    property bool popup: true
    property var content: contentNotification
    width: Variable.size.notificationPopupWidth
    height: contentNotification.height
    clip: true

    onPendingCloseChanged: {
        opacity = 0;
        height = 0;
        closeTimer.start();
    }

    Timer {
        id: closeTimer
        interval: 210
        onTriggered: {
            if (popup) {
                notificationObject.popup = false;
            }
            if (!popup) {
                Notification.discardNotification(notificationObject.notificationId);
            }
        }
    }

    // Component.onCompleted: {
    //     opacity = 1;
    //     implicitHeight = content.implicitHeight;
    // }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Color.colors.surface
        border.color: Color.colors.primary_container
        border.width: Variable.uiScale(1)
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                root.opacity = 0;
                root.height = 0;
                closeTimer.start();
            }
        }
    }

    ColumnLayout {
        id: contentNotification
        spacing: 0
        Rectangle {
            id: appNameBackground

            color: Color.colors.primary
            Layout.preferredWidth: Variable.size.notificationPopupWidth
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: appName.implicitHeight + (Variable.uiScale(8))
            Layout.bottomMargin: Variable.margin.small
            Text {
                id: appName
                text: notificationObject.appName ?? "System"
                color: Color.colors.on_primary
                font.pixelSize: Variable.font.pixelSize.normal
                font.family: Variable.font.family.main
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: Variable.margin.normal
            }
        }

        RowLayout {
            spacing: Variable.margin.normal
            Layout.fillWidth: true
            Layout.bottomMargin: Variable.margin.small
            NierAppIcon {
                id: appIcon
                notificationObject: root.notificationObject
                Layout.preferredWidth: Variable.size.notificationAppIconSize - Variable.margin.small
                Layout.preferredHeight: Variable.size.notificationAppIconSize
                Layout.alignment: Qt.AlignTop
                Layout.leftMargin: Variable.margin.small
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Label {
                    id: summary
                    text: notificationObject.summary
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                    // Layout.preferredWidth: Variable.size.notificationPopupWidth - (Variable.uiScale(16))
                    wrapMode: Text.Wrap
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.preferredWidth: parent.width
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                    wrapMode: Text.Wrap
                }
            }
        }
        Flow {
            id: actionsFlow
            Layout.fillWidth: true
            Layout.preferredWidth: Variable.size.notificationPopupWidth - Variable.margin.small * 2
            Layout.leftMargin: Variable.margin.small
            Layout.bottomMargin: notificationObject.actions.length > 0 ? Variable.margin.small : 0
            Layout.preferredHeight: notificationObject.actions.length > 0 ? childrenRect.height : 0
            spacing: Variable.margin.normal
            clip: true
            onWidthChanged: {
                actionsFlow.forceLayout();
            }
            Repeater {
                model: notificationObject.actions
                delegate: Rectangle {
                    id: actionDelegate
                    width: buttonText.width + (Variable.margin.small * 2)
                    height: buttonText.height + (Variable.margin.small)
                    color: Color.colors.surface_container_highest

                    Rectangle {
                        id: actionBackground
                        width: actionHoverHandler.hovered ? actionDelegate.width : 0
                        height: actionDelegate.height
                        color: Color.colors.primary
                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }

                    RowLayout {
                        id: buttonText
                        anchors.centerIn: parent
                        spacing: Variable.margin.large
                        Rectangle {
                            width: Variable.uiScale(16)
                            height: width
                            color: actionHoverHandler.hovered ? Color.colors.surface : Color.colors.primary
                        }

                        Text {
                            text: modelData.text
                            color: actionHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.small
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            anchors.centerIn: parent
                        }
                    }

                    HoverHandler {
                        id: actionHoverHandler
                    }

                    TapHandler {
                        onTapped: {
                            Notification.attemptInvokeAction(notificationObject.notificationId, modelData.identifier);
                        }
                    }
                }
                // delegate: Rectangle {
                //
                //     width: buttonText.implicitWidth + (Variable.uiScale(16))
                //     height: buttonText.implicitHeight + (Variable.uiScale(8))
                //     radius: Variable.radius.small
                //     color: hoverHandler.hovered ? Color.colors.primary_container : Color.colors.surface
                //     border.color: Color.colors.primary_container
                //     border.width: Variable.uiScale(1)
                //     Behavior on color {
                //         ColorAnimation {
                //             duration: 200
                //         }
                //     }
                //     Text {
                //         id: buttonText
                //         text: modelData.text
                //         color: Color.colors.on_surface
                //         font.pixelSize: Variable.font.pixelSize.smallest
                //         font.family: Variable.font.family.main
                //         font.weight: Font.Normal
                //         anchors.centerIn: parent
                //     }
                //     TapHandler {
                //         onTapped: {
                //             Notification.attemptInvokeAction(notificationObject.notificationId, modelData.identifier);
                //         }
                //     }
                //     HoverHandler {
                //         id: hoverHandler
                //     }
                // }
            }
        }
    }
}
