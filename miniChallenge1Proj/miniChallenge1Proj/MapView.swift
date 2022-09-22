//
//  MapView.swift
//  miniChallenge1Proj
//
//  Created by Barbara de Argolo Melo on 20/09/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    //21/09
   var cicloSP: Ciclo = Ciclo.ciclovias
  let region: MKCoordinateRegion
  @Binding var lineCoordinates: [CLLocationCoordinate2D]
    
     @Binding var locationManager: CLLocationManager
     @Binding var showMapAlert: Bool
    let mapView = MKMapView()
    
  func makeUIView(context: Context) -> MKMapView {
    mapView.delegate = context.coordinator
    locationManager.delegate = context.coordinator

      mapView.region = region
      coordenadas().self
      if lineCoordinates.isEmpty == false {
          let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
          mapView.addOverlay(polyline)
      }
    

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {
    //  fazendo agora 21/09
      mapView.showsUserLocation = true
      //mapView.userTrackingMode = .follow

      
      let coordinate = CLLocationCoordinate2D(latitude:-23.6699, longitude: -46.7012)
      let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
      let region = MKCoordinateRegion(center: view.userLocation.location?.coordinate ?? coordinate, span: span)
      view.setRegion(region, animated: true)
      

  }

  func makeCoordinator() -> Coordinator {
      return Coordinator(self)
  }
    func coordenadas() {
        
        for feature in cicloSP.features{
            for cordinate in feature.geometry.coordinates{
                let lat = cordinate[1]
                let lon = cordinate[0]
                let localizacao = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                lineCoordinates.append(localizacao)
       
//       lineCoordinates.append(CLLocationCoordinate2D(latitude: -23.6699, longitude: -46.7012))
//        lineCoordinates.append(CLLocationCoordinate2D(latitude: -23.6799, longitude: -46.7212))
//        lineCoordinates.append(CLLocationCoordinate2D(latitude: -23.7099, longitude: -46.7512))
       
           }
        }
    }


    

class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }
    
    
       

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
      
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
      renderer.strokeColor = UIColor.systemPurple
      renderer.lineWidth = 10
      return renderer
    }
    return MKOverlayRenderer()
  }
    
}

}
