import SwiftUI
import MapKit
import CoreLocation


//Criamos a view de mapView
public struct MapView: UIViewRepresentable {
    
    public init(_ mapview: MKMapView){
        self.mapView = mapview
        
        
    }
    
    //cria mapView, que é uma variaver do tipo MKMapView
    public var mapView: MKMapView
    
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    //permite mudar a localizacao do usuario dentro do mapView
    @EnvironmentObject var locationStore : LocationStore
    
    //location manager
    private var locationManager = CLLocationManager()
    
    
    //    faz a view de mapa
    public func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        
        // mapCenterCoordinate pega a localizacao do usuário e joga a view para o centro dessa localizacao
        let mapCenterCoordinate = locationStore.phoneLocation.location.coordinate
        mapView.showsCompass = false
        //                map.showsCompass = false // hides current compass, which shows only on map turning
        
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: screenW  * 0.832, y:screenH * 0.2) // you may use GeometryReader to replace it's position
        compassBtn.compassVisibility = .visible // compass will always be on map
        mapView.addSubview(compassBtn)
        
        
        let viewKilometers: Double = 10.0
        let viewMeters = viewKilometers * 1000.0
        //viewRegion faz com que a tela apareça centralizada e com o zoom determinado
        let viewRegion = MKCoordinateRegion(center: mapCenterCoordinate, latitudinalMeters: viewMeters, longitudinalMeters: viewMeters)
        
        
        mapView.centerCoordinate = mapCenterCoordinate
        mapView.region = viewRegion
        mapView.showsUserLocation = true
        
        
        
        
        
        
        
        //popUp de solicitacao de permissao de uso de localizacao
        locationManager.requestWhenInUseAuthorization()
        
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = context.coordinator
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 40
            
        }
        return mapView
    }
    
    public func updateUIView(_ view: MKMapView, context: Context) {
        // fazer atualizar a minha mapView para que saia a anotacao do mapa
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //classe para definir o layout do mapa, faz a conexao com o swiftui
    public class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate{
        var parent: MapView
        var primeraLocalizacao : CLLocation = .init(latitude: 0.0, longitude: 0.0)
        public var anotationsList : [MapAnnotation] = []
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
        }
        public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            parent.locationStore.phoneLocation = MapLocation(title: "Seu Celular", location: manager.location!)
            
            let localizacaoAtual : CLLocation = manager.location!
            let distance = primeraLocalizacao.distance(from: localizacaoAtual)
            
            if distance >= 40{
                CalculaDistancia.classeCalcula.calculaDistancia(localizacaoDoUsuario: parent.locationStore.phoneLocation.location)
                primeraLocalizacao = localizacaoAtual
            }
            
            
        }
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .systemPurple
            render.lineWidth = 3
            return render
        }
        
    }
}
