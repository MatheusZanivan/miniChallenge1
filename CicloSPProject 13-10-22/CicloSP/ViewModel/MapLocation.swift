import Foundation
import MapKit


// aqui criamos as localizacoes que serao carregadas no mapa 
public class MapLocation: Identifiable, ObservableObject{
    
    /*@Published*/ public var location: CLLocation
    public var title: String
    
    
    public init(title:String,location:CLLocation){
        self.location = location
        self.title = title
        
        
    }
    public func calculateDistanceFrom(_ otherLocation: CLLocation)->Double{
        
        return self.location.distance(from:otherLocation)
    }
    
}

