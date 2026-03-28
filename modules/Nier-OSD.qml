import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets

Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false
    property int percentage: Math.round(Pipewire.defaultAudioSink?.audio.volume * 100)
    property bool muted: Pipewire.defaultAudioSink?.audio.muted

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // The OSD window will be created and destroyed based on shouldShowOsd.
    // PanelWindow.visible could be set instead of using a loader, but using
    // a loader will reduce the memory overhead when the window isn't open.
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors.bottom: true
            margins.bottom: Variable.margin.large
            exclusiveZone: 0

            implicitWidth: Variable.uiScale(200)
            implicitHeight: Variable.uiScale(50)

            color: "transparent"
            Rectangle {
                anchors.fill: parent
                // radius: Variable.radius.larger
                color: Color.colors.surface
                border.color: Color.colors.surface_container_high
                border.width: Variable.uiScale(1)
                BackgroundPattern {

                    anchors.fill: parent
                    color: Color.colors.surface_container_high
                }
            }
            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Variable.uiScale(4)

                Rectangle {
                    color: "transparent"
                    width: Variable.uiScale(160)
                    height: Variable.uiScale(18)
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: Variable.uiScale(2)
                        height: parent.height
                        color: Color.colors.primary
                    }
                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: Variable.uiScale(2)
                        height: parent.height
                        color: Color.colors.primary
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * 0.8
                        width: parent.width * Math.min(1, Pipewire.defaultAudioSink?.audio.volume ?? 0)
                        color: Color.colors.primary
                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
                Rectangle {
                    color: Color.colors.primary
                    width: Variable.uiScale(160)
                    height: Variable.uiScale(2)
                }
                Rectangle {
                    color: "transparent"
                    width: Variable.uiScale(160)
                    height: Variable.uiScale(8)
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: Variable.uiScale(8)
                        height: Variable.uiScale(8)
                        color: Color.colors.primary
                    }
                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: Variable.uiScale(8)
                        height: Variable.uiScale(8)
                        color: Color.colors.primary
                    }
                }
            }

            // CircularProgress {
            //     anchors.centerIn: parent
            //     anchors.margins: Variable.margin.large
            //     lineWidth: Variable.size.small
            //     implicitSize: Variable.uiScale(100)
            //     value: Pipewire.defaultAudioSink?.audio.volume ?? 0
            //     inside: LucideIcon {
            //         icon: root.muted ? "volume-off" : root.percentage > 50 ? "volume-2" : root.percentage > 0 ? "volume-1" : "volume-x"
            //         font.pixelSize: Variable.uiScale(48)
            //         color: Color.colors.primary
            //     }
            // }
        }
    }
}
