import Foundation
import CoreLocation
import MapKit
public class CalculaDistancia: ObservableObject{
    var id : String
    var distancia : Double
    var cordenada : CLLocation
    
    init(id:String,distancia:Double, cordenada:CLLocation){
        self.id = id
        self.distancia = distancia
        self.cordenada = cordenada
    }
    
    
    
    
    
    
    
    
}
