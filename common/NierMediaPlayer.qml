import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Mpris

import qs.services
import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.modules.common.functions

Rectangle {
    visible: Mpris.players.values.length > 0
    width: controls.width + Variable.margin.normal
    height: columnLayout.height + Variable.margin.normal
    color: Color.colors.surface
    clip: true

    BackgroundPattern {
        anchors.fill: parent
        color: Color.colors.surface_container_highest
    }
    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        Rectangle {
            height: Variable.uiScale(100)
            Layout.fillWidth: true
            color: Color.colors.primary
            Rectangle {
                id: spectrumRoot
                property int barsCount: 16
                property list<var> values: Cava.values
                anchors.centerIn: parent
                width: Variable.uiScale(100)
                height: Variable.uiScale(80)
                color: "transparent"
                RowLayout {
                    height: Variable.uiScale(80)
                    anchors.centerIn: parent
                    Repeater {
                        model: spectrumRoot.values
                        Rectangle {
                            width: Variable.uiScale(2)
                            height: modelData * 8
                            color: Color.colors.surface
                            Layout.alignment: Qt.AlignBottom
                        }
                    }
                }
            }
        }
        SwipeView {
            id: controls
            // currentIndex: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
            currentIndex: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
            // currentIndex: 0
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
                    spacing: 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    Rectangle {
                        color: Color.colors.surface
                        anchors.fill: parent
                    }
                    Rectangle {
                        id: art
                        width: Variable.uiScale(92)
                        height: Variable.uiScale(92)
                        color: Color.colors.primary_container

                        radius: Variable.radius.normal
                        Image {
                            anchors.fill: parent
                            source: modelData.trackArtUrl
                            fillMode: Image.PreserveAspectCrop
                            // layer.enabled: true
                            // layer.effect: OpacityMask {
                            //     maskSource: Rectangle {
                            //         width: art.width
                            //         height: art.height
                            //         radius: Variable.radius.normal
                            //     }
                            // }
                        }
                    }
                    ColumnLayout {
                        Layout.minimumWidth: Variable.uiScale(340)
                        Layout.maximumWidth: Variable.uiScale(340)
                        Layout.leftMargin: Variable.margin.small
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
                                color: playHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
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
                                TapHandler {
                                    onTapped: {
                                        if (modelData.isPlaying) {
                                            console.log(modelData.isPlaying);
                                            const activePlayers = Mpris.players.values.reduce((a, b, i) => {
                                                if (i === index) {
                                                    return a;
                                                } else {
                                                    return a + b.isPlaying ? 1 : 0;
                                                }
                                            }, 0);
                                            const lastActivePlayer = Mpris.players.values.reduce((a, b, i) => {
                                                if (i === index) {
                                                    return a;
                                                } else {
                                                    return b.isPlaying ? i : a;
                                                }
                                            }, 0);
                                            if (activePlayers !== 0) {
                                                controls.currentIndex = lastActivePlayer;
                                            }
                                        }
                                        controls.currentIndex = controls.currentIndex;
                                        modelData.togglePlaying();
                                    }
                                }
                                HoverHandler {
                                    id: playHoverHandler
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                            Rectangle {
                                id: previousButton
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
                                    id: previousHoverHandler
                                }
                                LucideIcon {
                                    id: previousIcon
                                    anchors.centerIn: parent
                                    icon: "skip-back"
                                    color: previousHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                }
                            }
                            Rectangle {
                                id: nextButton
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
                                    color: nextHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                }
                                HoverHandler {
                                    id: nextHoverHandler
                                }
                                TapHandler {
                                    onTapped: {
                                        modelData.next();
                                        modelData.position = 0;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
