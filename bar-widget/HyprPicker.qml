import QtQuick

import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Rectangle {
    height: icon.height + Variable.margin.small
    width: icon.width + Variable.margin.small
    // color: ColorUtils.transparentize(Color.colors[Config.options.bar.foreground], 0.5)
    color: hoverHandler.hovered ? ColorUtils.transparentize(Color.colors[Config.options.bar.foreground], 0.4) : Color.colors[Config.options.bar.background]
    radius: Variable.radius.small
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
    Behavior on color {
        ColorAnimation {
            duration: Variable.animation.duration
            easing.type: Easing.InOutQuad
        }
    }

    TapHandler {
        // onTapped: Quickshell.execDetached(["hyprpicker"])
        onTapped: hyprpicker.running = true
    }
    LucideIcon {
        id: icon
        icon: "pipette"
        font.pixelSize: Variable.font.pixelSize.small
        anchors.centerIn: parent
        color: Color.colors[Config.options.bar.foreground]
    }

    Process {
        id: hyprpicker
        command: ["hyprpicker"]
        stdout: StdioCollector {
            onStreamFinished: {
                Quickshell.execDetached(["wl-copy", this.text]);
            }
        }
    }
}
