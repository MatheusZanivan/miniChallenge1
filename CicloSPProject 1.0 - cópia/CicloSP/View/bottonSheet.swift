import Foundation
import SwiftUI
import MapKit
//BottomSheet
struct BottomSheet: View {
    
    
    @EnvironmentObject var locationStore : LocationStore
    
    func drawRoute(selectedLocation : CLLocation, anotationTitle : String){
        let start = MKPlacemark(coordinate: locationStore.phoneLocation.location.coordinate)
        let end = MKPlacemark(coordinate:  selectedLocation.coordinate)
        //                                selectedLocation.coordinate, title:)
        
        let endPin = MKPointAnnotation()
        endPin.title = anotationTitle
        endPin.coordinate = CLLocationCoordinate2D(
            latitude: selectedLocation.coordinate.latitude,
            longitude: selectedLocation.coordinate.longitude
        )
        
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: start)
        request.destination = MKMapItem(placemark: end)
        request.transportType = .walking
        
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            //            let anotation = MKAnnotation()
            
            mapView.addAnnotation(endPin)
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
        }
    }
    
    
    //Remover as rotas tracadas
    private func updateOverlays(from mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        
    }
    
    //Remover as anotacoes do mapa
    private func removeAnnotations (from mapView: MKMapView) {
        mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                mapView.removeAnnotation($0)
            }
        }
    }
    
    
    
    var body : some View {
        //        @EnvironmentObject var locationStore : LocationStore
        VStack{
            Capsule()
                .fill(Color(white: 0.5))
                .frame( width:50,height:5)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                LazyVStack(alignment: .leading, spacing: 15, content: {
                    
                    
                    ForEach(CalculaDistancia.classeCalcula.locationList) { item in
                        Button(action: {
                            drawRoute(selectedLocation: item.location, anotationTitle: item.title)
                            updateOverlays(from: mapView)
                            removeAnnotations(from: mapView)
                        }, label: {
                            Image(systemName: "bicycle.circle")
                                .font(.system(size: 35))
                                .foregroundColor(Color(red: 0.39215686274509803, green: 0.34509803921568627, blue: 0.792156862745098))
                            
                            Text(item.title)
                                .font(.system(size: 17, weight: .semibold, design: .default)).multilineTextAlignment(.leading)
                                .foregroundColor(Color(red: 0, green: 0, blue: 0))
                            
                        })
                        Divider()
                    }
                    
                })
                .padding()
                .padding(.top)
            })
            
        }
        
        .padding(.top,10)
        .ignoresSafeArea()
        .background(Color(.init(red: 0.949, green: 0.949, blue: 0.975, alpha: 1)))
    }
}


