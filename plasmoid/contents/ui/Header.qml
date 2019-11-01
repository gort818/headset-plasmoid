import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaComponents.ListItem {
    property alias text: label.text

    height: units.gridUnit * 1.5
    sectionDelegate: true

    PlasmaComponents.Label {
        id: label
        anchors.centerIn: parent
        font.weight: Font.DemiBold
    }
}
