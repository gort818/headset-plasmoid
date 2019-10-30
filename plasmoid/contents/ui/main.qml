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
        Layout.preferredWidth: 120 * units.devicePixelRatio
        Layout.preferredHeight: 80 * units.devicePixelRatio
        
        PlasmaComponents.Label {
            id: label
            anchors.fill: parent
            text: i18n(userName)
            horizontalAlignment: Text.AlignHCenter
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
    
    
    PlasmaCore.IconItem {
		
                // source - the icon to be displayed
                source: "audio-headset"
               
                
                // height & width set to equal the size of the parent item (the empty "Item" above)
		        width: units.iconSizes.small
    	        height: units.iconSizes.small
	}
    
}

