import Combine
import CoreLocation

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    //Irá armazenar a coordenada
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    
    //Variável que irá responder se usuário não autorizar
    var deniedLocationAcessPublisher = PassthroughSubject<Void, Never>()
    
    private override init() {
        super.init()
    }
    
    static let shared = DeviceLocationService()
    
    
    //Gerenciador de localizacao
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    //Funcao para solicitar a localizacao com o usuário
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            deniedLocationAcessPublisher.send()
        }
   }
    
    //Gerente de localizacao
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            deniedLocationAcessPublisher.send()
        }
    }
    
    
    //Obtendo a localizacao
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }
    

    //funcao para apontar se der erro
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}
