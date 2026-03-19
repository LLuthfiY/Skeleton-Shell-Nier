import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Quickshell

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.services

Rectangle {
    id: root
    property int size: Variable.size.large
    property var date: systemClock.date
    SystemClock {
        id: systemClock
        precision: SystemClock.Hours
    }
    height: gridLayout.height
    width: gridLayout.width
    color: Color.colors.surface
    GridLayout {
        id: gridLayout
        columns: 2
        rows: 3
        Rectangle {
            id: buttons
            Layout.fillWidth: true
            height: Variable.uiScale(48)
            Layout.columnSpan: 2
            Layout.row: 0
            color: Color.colors.primary
            Rectangle {
                id: prevMonthButton
                width: prevMonthIcon.width + Variable.margin.small
                height: prevMonthIcon.height + Variable.margin.small
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                LucideIcon {
                    id: prevMonthIcon
                    icon: "chevron-left"
                    color: Color.colors.surface
                    anchors.centerIn: parent
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: {
                        root.date = new Date(root.date.getFullYear(), root.date.getMonth() - 1, root.date.getDate());
                    }
                }
            }
            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: nextMonthIcon.width + Variable.margin.small
                height: nextMonthIcon.height + Variable.margin.small
                color: "transparent"
                LucideIcon {
                    id: nextMonthIcon
                    icon: "chevron-right"
                    color: Color.colors.surface
                    anchors.centerIn: parent
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: {
                        root.date = new Date(root.date.getFullYear(), root.date.getMonth() + 1, root.date.getDate());
                    }
                }
            }
            Rectangle {
                anchors.centerIn: parent
                width: currentMonthText.width + Variable.margin.small
                height: currentMonthText.height + Variable.margin.small
                color: "transparent"
                Text {
                    id: currentMonthText
                    text: Qt.formatDate(root.date, "MMMM yyyy")
                    font.family: Variable.font.family.main
                    font.weight: Font.Bold
                    color: Color.colors.surface
                    anchors.centerIn: parent
                    font.pixelSize: Variable.font.pixelSize.small
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: {
                        root.date = systemClock.date;
                    }
                }
            }
        }
        Rectangle {
            id: rowOfWeekdays
            Layout.column: 0
            Layout.row: 1
            height: root.size
            width: root.size
            color: "transparent"
        }
        DayOfWeekRow {
            id: dayOfWeekRow
            locale: Qt.locale("en_US")
            height: root.size
            width: root.size * 7
            Layout.column: 1
            Layout.row: 1
            Layout.leftMargin: Variable.margin.small

            delegate: Rectangle {
                radius: Variable.radius.small
                color: "transparent"
                height: root.size
                width: root.size
                Text {
                    text: model.shortName
                    font.pixelSize: Variable.font.pixelSize.small
                    color: Color.colors.on_surface
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    anchors.centerIn: parent
                }
            }
        }
        WeekNumberColumn {
            year: root.date.getFullYear()
            month: root.date.getMonth()
            Layout.column: 0
            Layout.row: 2
            height: root.size * 6
            width: root.size
            clip: true
            delegate: Rectangle {
                radius: Variable.radius.small
                color: "transparent"
                height: root.size
                width: root.size
                Text {
                    text: model.weekNumber
                    font.pixelSize: Variable.font.pixelSize.small
                    color: Color.colors.on_surface
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    anchors.centerIn: parent
                }
            }
        }
        MonthGrid {
            year: root.date.getFullYear()
            month: root.date.getMonth()
            padding: Variable.margin.small
            background: Rectangle {
                color: Color.colors.surface_container_high
            }
            Layout.column: 1
            Layout.row: 2
            delegate: Rectangle {
                width: root.size
                height: root.size
                property bool isCurrentDay: model.day === systemClock.date.getDate() && model.month === systemClock.date.getMonth() && model.year === systemClock.date.getFullYear()
                property bool isCurrentMonth: model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                color: isCurrentDay ? Color.colors.primary : "transparent"
                Text {
                    text: model.day
                    font.pixelSize: isCurrentMonth ? Variable.font.pixelSize.small : Variable.font.pixelSize.smallest
                    color: isCurrentDay ? Color.colors.on_primary : isCurrentMonth ? Color.colors.on_surface : "#777777"
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    anchors.centerIn: parent
                }
            }
        }
    }
}
