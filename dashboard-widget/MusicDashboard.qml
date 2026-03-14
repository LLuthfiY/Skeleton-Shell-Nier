import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Mpris

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

import Qt5Compat.GraphicalEffects

SwipeView {
    id: controls
    property bool active: Mpris.players.values.length > 0
    // currentIndex: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
    Component.onCompleted: {
        // Schedule the index selection after the component is fully ready
        controls.currentIndex = Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0);
    }

    Repeater {
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: ScriptModel {
            values: Mpris.players.values
        }
        delegate: RowLayout {
            opacity: controls.currentIndex == index ? 1 : 0
            property bool needUpdate: false
            property bool afterOpen: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: Variable.margin.normal
            property real pos: 0
            spacing: Variable.margin.large
            Rectangle {
                id: art
                width: Variable.uiScale(92)
                height: Variable.uiScale(92)

                radius: Variable.radius.normal
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: modelData.trackArtUrl
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: art.width
                            height: art.height
                            radius: Variable.radius.normal
                        }
                    }
                }
            }
            ColumnLayout {
                Layout.minimumWidth: Variable.uiScale(340)
                Layout.maximumWidth: Variable.uiScale(340)
                spacing: Variable.margin.small
                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: modelData.trackTitle
                    elide: Text.ElideRight
                    font.pixelSize: Variable.font.pixelSize.normal
                    Layout.maximumWidth: Variable.uiScale(340)
                    font.family: Variable.font.family.main
                    font.weight: Font.Medium
                    color: Color.colors.on_surface
                    onTextChanged: {
                        if (!afterOpen) {
                            needUpdate = true;
                        }
                        afterOpen = false;
                    }
                }
                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: modelData.trackArtist
                    elide: Text.ElideRight
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    Layout.maximumWidth: Variable.uiScale(340)

                    font.weight: Font.Medium
                    color: Color.colors.on_surface
                }
                RowLayout {
                    spacing: Variable.margin.small
                    Rectangle {
                        id: playButton
                        implicitWidth: Variable.size.larger
                        implicitHeight: Variable.size.larger
                        visible: modelData.canPlay
                        radius: Variable.radius.small
                        color: playHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        LucideIcon {
                            id: playIcon
                            anchors.centerIn: parent
                            icon: modelData.isPlaying ? "pause" : "play"
                            color: playHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                        }
                        HoverHandler {
                            id: playHoverHandler
                            cursorShape: Qt.PointingHandCursor
                        }
                        TapHandler {
                            onTapped: {
                                if (modelData.isPlaying) {
                                    const activePlayers = Mpris.players.values.reduce((a, b, i) => {
                                        if (i == index) {
                                            return a;
                                        } else {
                                            return a + b.isPlaying ? 1 : 0;
                                        }
                                    }, 0);
                                    const lastActivePlayer = Mpris.players.values.reduce((a, b, i) => {
                                        if (i == index) {
                                            return a;
                                        } else {
                                            return b.isPlaying ? i : a;
                                        }
                                    }, 0);
                                    if (activePlayers !== 0) {
                                        controls.currentIndex = lastActivePlayer;
                                    }
                                }
                                // controls.currentIndex = controls.currentIndex;
                                modelData.togglePlaying();
                            }
                        }
                    }
                    Rectangle {
                        id: previousButton
                        property bool isHovered: false
                        implicitWidth: Variable.size.large
                        implicitHeight: Variable.size.large
                        visible: modelData.canGoPrevious
                        radius: Variable.radius.small
                        color: "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        TapHandler {
                            onTapped: {
                                modelData.previous();
                                modelData.position = 0;
                            }
                        }
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                        LucideIcon {
                            id: previousIcon
                            anchors.centerIn: parent
                            icon: "skip-back"
                            color: Color.colors.on_surface_variant
                        }
                    }
                    Rectangle {
                        id: nextButton
                        property bool isHovered: false
                        implicitWidth: Variable.size.large
                        implicitHeight: Variable.size.large
                        visible: modelData.canGoNext
                        radius: Variable.radius.small
                        color: "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        LucideIcon {
                            id: nextIcon
                            anchors.centerIn: parent
                            icon: "skip-forward"
                            color: nextButton.isHovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                        }
                        TapHandler {
                            onTapped: {
                                modelData.next();
                                modelData.position = 0;
                            }
                        }
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
                // Slider {
                //     id: slider
                //     visible: modelData.canSeek
                //     Layout.alignment: Qt.AlignVCenter
                //     from: 0
                //     Layout.fillWidth: true
                //     stepSize: 1
                //     onMoved: {
                //         modelData.position = value;
                //     }
                //     // onVisibleChanged: {
                //     //     if (!mediaPlayerRoot.afterOpen) {
                //     //         modelData.position = 0;
                //     //     }
                //     //
                //     //     mediaPlayerRoot.afterOpen = false;
                //     // }
                //
                //     background: Rectangle {
                //         color: "transparent"
                //         height: 4
                //         radius: Variable.radius.normal
                //         anchors.verticalCenter: parent.verticalCenter
                //
                //         Rectangle {
                //             id: activeProgress
                //             color: Color.colors.primary
                //             width: modelData.position / modelData.length * parent.width - 10
                //             height: 8
                //             radius: 4
                //             anchors.verticalCenter: parent.verticalCenter
                //         }
                //
                //         Rectangle {
                //             id: inactiveProgress
                //             color: Color.colors.primary_container
                //             width: parent.width - activeProgress.width - 20
                //             height: 4
                //             radius: Variable.radius.normal
                //             anchors.verticalCenter: parent.verticalCenter
                //             anchors.right: parent.right
                //         }
                //     }
                //     handle: Rectangle {
                //         color: Color.colors.primary
                //         radius: 4
                //         width: 4
                //         height: 16
                //         anchors.verticalCenter: parent.verticalCenter
                //         x: modelData.position / modelData.length * parent.width - width / 2
                //     }
                //     // Component.onCompleted: {
                //     //     modelData.position = 0;
                //     // }
                // }
                // Timer {
                //     interval: 1000
                //     running: modelData.isPlaying
                //     repeat: true
                //     triggeredOnStart: true
                //     onTriggered: {
                //         modelData.positionChanged();
                //         slider.value = modelData.position;
                //         if (slider.to != modelData.length) {
                //             slider.to = modelData.length;
                //         }
                //         if (needUpdate) {
                //             needUpdate = false;
                //             // modelData.position = 0;
                //         }
                //     }
                // }
                // Timer {
                //     interval: 100
                //     running: modelData.isPlaying && needUpdate
                //     triggeredOnStart: true
                //     repeat: true
                //     onTriggered: {
                //         modelData.positionChanged();
                //         slider.value = modelData.position;
                //         if (slider.to != modelData.length) {
                //             slider.to = modelData.length;
                //         }
                //
                //         needUpdate = false;
                //         modelData.position = 0;
                //     }
                // }
            }
        }
    }
}
