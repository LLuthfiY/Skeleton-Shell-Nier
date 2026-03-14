import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Effects

Canvas { // Visualizer
    id: root
    property int spaceX: 5
    property int spaceY: 5
    property int lineWidth: 1
    property color color: Color.colors.surface_container_highest

    anchors.fill: parent
    onPaint: {
        let ctx = getContext("2d");
        for (let i = 0; i < root.width; i += root.spaceX) {
            ctx.strokeStyle = root.color;
            ctx.lineWidth = root.lineWidth;
            ctx.beginPath();
            ctx.moveTo(i, 0);
            ctx.lineTo(i, root.height);
            ctx.stroke();
            ctx.closePath();
        }
        for (let i = 0; i < root.height; i += root.spaceY) {
            ctx.strokeStyle = root.color;
            ctx.lineWidth = root.lineWidth;
            ctx.beginPath();
            ctx.moveTo(0, i);
            ctx.lineTo(root.width, i);
            ctx.stroke();
            ctx.closePath();
        }
    }
}
