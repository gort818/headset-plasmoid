import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    width: 10
    height: 10
    id: mainitem
    property string userName
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation: Item {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        Layout.preferredWidth: 210 * units.devicePixelRatio
        Layout.preferredHeight: 200 * units.devicePixelRatio

        Column {
            Rectangle {
                color: "transparent"
                width: 200 * units.devicePixelRatio
                height: 100 * units.devicePixelRatio
                anchors.horizontalCenter: parent.horizontalCenter

                PlasmaComponents.Label {
                    id: label
                    anchors.fill: parent
                    text: i18n(batteryPercent)
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                width: 210 * units.devicePixelRatio
                height: 10 * units.devicePixelRatio
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                PlasmaComponents.Label {
                    id: sidetone
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: "Set Sidetone value"
                }
            }

            Rectangle {
                width: 210 * units.devicePixelRatio
                height: 25 * units.devicePixelRatio
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                PlasmaComponents.Slider {
                    id: toneSlider
                    anchors.fill: parent
                    height: 20
                    width: 100
                    orientation: Qt.Horizontal
                    minimumValue: 0
                    maximumValue: 128
                    stepSize: 2
                    onPressedChanged: {
                        cmd.exec("headsetcontrol -s" + toneSlider.value)
                    }
                }
            }

            Rectangle {
                width: 210 * units.devicePixelRatio
                height: 10 * units.devicePixelRatio
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                PlasmaComponents.Label {
                    id: sidetone_value
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: toneSlider.value
                }
            }
        }

        PlasmaCore.DataSource {
            id: whoamisource
            engine: "executable"

            connectedSources: ["headsetcontrol -b"]
            onNewData: {
                mainitem.batteryPercent = data.stdout
            }
            interval: 5000
        }
    }

    PlasmaCore.DataSource {
        id: cmd
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmdstr) {
            connectSource(cmdstr)
        }
        signal exited(int exitCode, int exitStatus, string stdout, string stderr)
    }

    Plasmoid.toolTipSubText: {
        "Headset Configuration"
    }
}
