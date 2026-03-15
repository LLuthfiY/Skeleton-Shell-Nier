import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.modules.common.functions

Rectangle {
    id: trayItem
    required property SystemTrayItem modelData
    color: Color.colors[Config.options.bar.foreground]
    width: Variable.size.large
    height: Variable.size.large

    Component.onCompleted: BarMenuUtils.barWindow = barWindow

    IconImage {
        id: trayIcon
        visible: true
        source: modelData.icon
        anchors.fill: parent
        anchors.margins: Variable.size.large * 0.1
    }

    TapHandler {
        onTapped: {
            modelData.activate();
        }
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: mouse => {
            GlobalState.barMenuOpen = true;
            menuOpener.menu = modelData.menu;
            BarMenuUtils.barWindow = barWindow;
            BarMenuUtils.item = trayItem;
            BarMenuUtils.barMenuComponent = menuComponent;
        }
    }

    QsMenuOpener {
        id: menuOpener
        menu: modelData.menu
    }

    Component {
        id: menuComponent
        ColumnLayout {
            id: col
            spacing: 0
            Repeater {
                model: menuOpener.children
                delegate: Rectangle {
                    id: listButton
                    height: loader.height
                    width: loader.width + Variable.margin.normal
                    Layout.fillWidth: true
                    color: "transparent"

                    Component {
                        id: listButtonComponent
                        ToggledListButton {
                            mData: modelData
                            text: modelData.text
                            toggled: listButtonHoverHandler.hovered
                            width: Math.max(contentWidth, listButton.width)
                            animationDuration: 150
                            HoverHandler {
                                id: listButtonHoverHandler
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                    Component {
                        id: separatorComponent
                        Rectangle {
                            height: Variable.margin.normal
                            width: listButton.width
                            color: "transparent"
                            Rectangle {
                                height: 1
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter
                                color: Color.colors.primary
                            }
                        }
                    }
                    Loader {
                        id: loader
                        active: true
                        sourceComponent: modelData.isSeparator ? separatorComponent : listButtonComponent
                    }
                    TapHandler {
                        onTapped: {
                            if (modelData.hasChildren) {
                                menuOpener.menu = modelData.menu;
                            } else {
                                modelData.triggered();
                            }
                            GlobalState.barMenuOpen = false;
                        }
                    }
                }
                // delegate: Rectangle {
                //     height: modelData.isSeparator ? 2 : row.height + Variable.margin.small
                //     width: row.width + Variable.margin.small
                //     Layout.fillWidth: true
                //     Layout.margins: modelData.isSeparator ? Variable.margin.small : 0
                //     HoverHandler {
                //         id: menuItemHover
                //     }
                //     color: modelData.isSeparator ? Color.colors.surface_container_high : menuItemHover.hovered ? Color.colors.surface_container : Color.colors.surface
                //     radius: Variable.radius.small
                //     Behavior on color {
                //         ColorAnimation {
                //             duration: 200
                //         }
                //     }
                //     TapHandler {
                //         enabled: modelData.enabled
                //         onTapped: {
                //             if (modelData.hasChildren) {
                //                 menuOpener.menu = modelData.menu;
                //             } else {
                //                 modelData.triggered();
                //             }
                //             GlobalState.barMenuOpen = false;
                //         }
                //     }
                //     RowLayout {
                //         id: row
                //         anchors.verticalCenter: parent.verticalCenter
                //         Rectangle {
                //             height: Variable.size.large
                //             width: Variable.size.large
                //             color: "transparent"
                //             Image {
                //                 source: modelData.icon
                //                 // To get the best image quality, set the image source size to the same size
                //                 // as the rendered image.
                //                 sourceSize.width: width
                //                 sourceSize.height: height
                //                 anchors.centerIn: parent
                //             }
                //         }
                //         Text {
                //             text: modelData.text
                //             color: Color.colors.on_surface
                //             font.pixelSize: Variable.font.pixelSize.small
                //             font.family: Variable.font.family.main
                //             font.weight: Font.Normal
                //         }
                //         Item {
                //             Layout.fillWidth: true
                //         }
                //         LucideIcon {
                //             property int state: modelData.checkState
                //             property var type: modelData.buttonType
                //             icon: {
                //                 if (type === QsMenuButtonType.CheckBox) {
                //                     if (state === 0) {
                //                         return "square";
                //                     }
                //                     if (state === 1) {
                //                         return "square-slash";
                //                     }
                //                     return "square-check";
                //                 }
                //                 if (type === QsMenuButtonType.RadioButton) {
                //                     if (state === 0) {
                //                         return "circle";
                //                     }
                //                     if (state === 1) {
                //                         return "circle-slash";
                //                     }
                //                     return "circle-check";
                //                 }
                //                 return "";
                //             }
                //         }
                //     }
                // }
            }
        }
    }

    // QsMenuAnchor {
    //     id: styledMenu
    //     anchor.window: barWindow
    //     menu: modelData.menu
    // }
}
