import QtQuick
import QtQuick.Layouts
import qs.modules.common.user
import qs.modules.common

Rectangle {
    id: root
    property var mData: {
        name: "test";
    }
    property bool toggled: false
    property Component contentComponent: contentComponent
    property int animationDuration: 200
    property string text: mData.name
    property color fontColor: Color.colors.on_surface
    property int contentWidth: loader.implicitWidth
    property int contentHeight: loader.implicitHeight

    color: "transparent"
    height: Variable.uiScale(48)

    onWidthChanged: {
        if (root.toggled) {
            background.width = root.width;
            root.fontColor = Color.colors.on_primary;
        }
    }
    Timer {
        id: animationToggledTimer
        interval: root.animationDuration
        repeat: false
        onTriggered: {
            topLine.visible = true;
            bottomLine.visible = true;
            topLine.anchors.topMargin = 0;
            bottomLine.anchors.bottomMargin = 0;
        }
    }
    Timer {
        id: animationUnToggledTimer
        interval: root.animationDuration
        repeat: false
        onTriggered: {
            topLine.visible = false;
            bottomLine.visible = false;
            background.width = 0;
            animationUnToggledFontColorTimer.running = true;
        }
    }
    Timer {
        id: animationUnToggledFontColorTimer
        interval: root.animationDuration
        repeat: false
        onTriggered: {
            root.fontColor = Color.colors.on_surface;
        }
    }
    onToggledChanged: {
        if (root.toggled) {
            background.width = root.width;
            root.fontColor = Color.colors.on_primary;
            animationToggledTimer.running = true;
        } else {
            topLine.anchors.topMargin = Variable.margin.small / 2;
            bottomLine.anchors.bottomMargin = Variable.margin.small / 2;
            animationUnToggledTimer.running = true;
        }
    }

    Rectangle {
        id: background
        height: root.height - Variable.margin.small
        width: 0
        color: Color.colors.primary
        anchors.verticalCenter: parent.verticalCenter

        Behavior on width {
            NumberAnimation {
                duration: root.animationDuration
            }
        }
    }

    Rectangle {
        id: topLine
        visible: false
        height: 1
        width: parent.width
        color: Color.colors.primary
        anchors.top: parent.top
        anchors.topMargin: Variable.margin.small / 2
        Behavior on anchors.topMargin {
            NumberAnimation {
                duration: root.animationDuration
            }
        }
    }

    Rectangle {
        id: bottomLine
        visible: false
        height: 1
        width: parent.width
        color: Color.colors.primary
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Variable.margin.small / 2
        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: root.animationDuration
            }
        }
    }

    Loader {
        id: loader
        active: true
        sourceComponent: root.contentComponent
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Variable.margin.small
    }

    Component {
        id: contentComponent
        // Text {
        //     text: root.text
        //     font.family: Variable.font.family.main
        //     font.weight: Font.Normal
        //     color: root.fontColor
        // }
        RowLayout {
            spacing: Variable.margin.small
            Rectangle {
                width: Variable.uiScale(16)
                height: width
                color: root.fontColor
            }
            Text {
                text: root.text
                Layout.fillWidth: true
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: root.fontColor
            }
        }
    }
}
