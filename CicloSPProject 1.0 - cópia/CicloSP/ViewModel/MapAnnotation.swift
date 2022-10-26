import Foundation
import MapKit
import SwiftUI


// objeto que faz as anotacoes no mapa , pega location , titulo e a coordenada
public class MapAnnotation: NSObject,MKAnnotation, Identifiable{
    public var location: MapLocation
    public var title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    public var iconName: String
  
    
    
    
    public init(location: MapLocation){
        
        self.location = location
        self.title = location.title
        self.coordinate = location.location.coordinate
        self.iconName = ""

        
        
        super.init()
        
    }
    // objeto que faz as anotacoes no mapa , pega location , titulo e a coordenada e subtitulo 
    public init(location: MapLocation, subtitle: String?, iconName: String){
        self.location = location
        self.title = location.title
        self.coordinate = location.location.coordinate
        self.subtitle = subtitle
        self.iconName = iconName
        
    
        
        super.init()
    }
}

