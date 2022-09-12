import CoreLocationUI
import MapKit
import SwiftUI

struct ContentView: View {
    
    //Chamando a classe
    @StateObject private var viewModel = ContentViewModel()
    
    
    var body: some View {
        
        
        ZStack (alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .tint(.pink)
            
            LocationButton(.currentLocation){
                //Chama Funçao da classe ContentViewModel
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
            .symbolVariant(.fill)
            .tint(.pink)
            .padding(.bottom, 2)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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

