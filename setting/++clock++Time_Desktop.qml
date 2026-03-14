import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

import qs.modules.common
import qs.modules.common.user
import qs.modules.common.widgets
import qs.modules.common.functions

// ScrollView {
//     clip: true
//     height: parent.height
//     width: parent.width * Config.options.appearance.uiScale
ColumnLayout {
    id: root
    spacing: Variable.margin.small
    width: stackWrapper.width - Variable.uiScale(32)
    // height: parent.height
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.title
        font.weight: Font.Bold
        font.family: Variable.font.family.main
        label: "Time Desktop"
    }
    RowLayout {
        Layout.preferredWidth: root.width
        LucideIcon {
            label: "Opacity"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
            icon: "blend"
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: UserConfig.options.timedesktop.opacity
            min: 0
            max: 1
            step: 0.05
            onValueChanged: {
                UserConfig.options.timedesktop.opacity = value;
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        LucideIcon {
            label: "Font Size"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
            icon: "a-large-small"
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: UserConfig.options.timedesktop.fontSize
            min: 0
            max: 10000
            step: 10
            onValueChanged: {
                UserConfig.options.timedesktop.fontSize = value;
            }
        }
    }
}
// }

