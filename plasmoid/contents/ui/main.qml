import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.6 as Controls1

/*
*   Copyright (C) 2011 by Daker Fernandes Pinheiro <dakerfp@gmail.com>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 2, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/



Item {
   // width: 10
    //height: 10
    id: mainitem
    property string userName
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation: Item {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        Layout.preferredWidth: 210 * units.devicePixelRatio
        Layout.preferredHeight: 200 * units.devicePixelRatio
        
        Column {
            spacing: 0
        
        Rectangle {
            id: rect1
            color: "transparent"
             width: 200 * units.devicePixelRatio
             height: 100 * units.devicePixelRatio
              anchors.horizontalCenter: parent.horizontalCenter
            
        
        PlasmaComponents.Label {
            id: label
            anchors.fill: parent
            text: i18n(userName)
            horizontalAlignment: Text.AlignHCenter
        }
        
        }
        
        Rectangle {
            id: rect3
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
                    id: rect2
                    width: 210 * units.devicePixelRatio
                    height: 25 * units.devicePixelRatio
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    
        
                    PlasmaComponents.Slider {
                        id: redSlider
                        anchors.fill: parent
                        height: 20
                        width: 100
                        orientation: Qt.Horizontal
                        minimumValue: 0
                        maximumValue: 128
                        stepSize: 2
                       // Keys.onTabPressed: cmd.exec("headsetcontrol -s"  + redSlider.value);
                       onPressedChanged:
                       {
                           cmd.exec("headsetcontrol -s"  + redSlider.value);
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
             text: redSlider.value
             
             
         }    
            }      
                    
                    
                }
        
         

        
        
    
    


    
    PlasmaCore.DataSource {
        id: whoamisource
        engine: "executable"
       
        connectedSources: ["headsetcontrol -b"]
        onNewData:{
            mainitem.userName = data.stdout
        }
        interval: 5000
    }
    
    
    
}

Connections {
        target: cmd
        onExited: {
            if(exitCode == 0 && exitStatus == 0){
                if(stdout != null && stdout.length > 5){
                    if(stdout.substring(0, 6) === "Screen"){
                        var array = stdout.split('\n');
                        if(array.length > 1){
                            var out = array[1].substring(0,  (array[1].indexOf("connected") -1));
                            if(out.length > 0){
                                plasmoid.configuration.output = out;
                            }
                        }
                    }
                }

            }
            if(stderr.indexOf("not found") > -1){
                if( exitCode == 1 && exitStatus == 0){
                    //warning: output ... not found; ignoring
                    //xrandr: Need crtc to set gamma on.
                }
                if( exitCode == 127 && exitStatus == 0) errorDialog.visible = true;
            }
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
    
    Plasmoid.toolTipSubText: {"Check settings for safe limits."}
    
}
