import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main
    
    property string deviceName
    property string batteryPercent
    
    //Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation:ColumnLayout {
     anchors.centerIn: parent
     anchors.fill: parent
     spacing: 0
     Layout.minimumWidth: units.gridUnit * 20
     Layout.minimumHeight: units.gridUnit * 15
    Rectangle {
        color: "transparent"
        height:5
        Layout.fillWidth: true
         Header{
            id: label
            //anchors.fill: parent
            text: i18n("Headset Configuration")
            //horizontalAlignment: Text.AlignHCenter
        }
        
         
        
        
    }
    
    Rectangle {
        color: "transparent"
        height: units.gridUnit * .5
        Layout.fillWidth: true
        PlasmaComponents.Label {
            height:1
            id: sidetone_valuetest
            text: i18n("Device: " + deviceName)
            anchors.centerIn: parent
        }
    }
    
    Rectangle {
        color: "transparent"
       height: units.gridUnit * .5
        Layout.fillWidth: true
        PlasmaComponents.Label {
            height: 1
            id: deviceString
            text: i18n(batteryPercent)
            anchors.centerIn: parent
        }
    }
    
    
     Rectangle {
        color: "transparent"
        height: units.gridUnit * .5
        Layout.fillWidth: true
         Header{
            id: label_sidetone
            //anchors.fill: parent
            text: i18n("Set Sidetone")
            //horizontalAlignment: Text.AlignHCenter
        }
        
    }
    
    Rectangle {
        color: "transparent"
        height: units.gridUnit * .1
        Layout.fillWidth: true
        Layout.topMargin: 5
        
        PlasmaComponents.Slider {
            id: toneSlider
           width: 280
            anchors.centerIn: parent
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
        color: "transparent"
       height: units.gridUnit * .1
        Layout.fillWidth: true
        Layout.bottomMargin: 5
        PlasmaComponents.Label {
            id: sidetone_value
            height: 1
            anchors.centerIn: parent
            verticalAlignment: Text.AlignTop
            text: toneSlider.value
        }
    }
    
    PlasmaCore.DataSource {
            id: test
            engine: "executable"

            connectedSources: ["headsetcontrol -b |  grep -i found  | sed  's/Found //g' | tr -d '!'"]
            onNewData: {
                main.deviceName = data.stdout
            }
        }
        
    PlasmaCore.DataSource {
            id: whoami
            engine: "executable"

            connectedSources: ["headsetcontrol -b |  grep -i battery"]
            onNewData: {
                main.batteryPercent = data.stdout
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
