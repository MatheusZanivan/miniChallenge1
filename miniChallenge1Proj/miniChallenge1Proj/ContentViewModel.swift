import CoreLocationUI
import MapKit
import SwiftUI

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //Gerenciador de localização
    let locationManager = CLLocationManager()
    
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100 ))
    
    
    
    //Requisitando a localizacao do usuário
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latesLocation = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latesLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error.localizedDescription)
   }
}
