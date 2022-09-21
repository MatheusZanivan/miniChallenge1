//
//  JSONManager.swift
//  miniChallenge1Proj
//
//  Created by Barbara de Argolo Melo on 16/09/22.
//

import Foundation
import SwiftUI
import MapKit
//import UIKit


// MARK: - Welcome
struct Ciclo: Codable {
    let features: [Feature]
    
    static let ciclovias: Ciclo = Bundle.main.decode(file: "cicloviassp.json")
    //static let localiza: Ciclo = ciclovias[0]
    
}

var geoJson = [MKGeoJSONObject]()
var overlays = [MKOverlay]()


// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType
    let properties: Properties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [[Double]]
}

enum GeometryType: String, Codable {
    case lineString = "LineString"
}

// MARK: - Properties
struct Properties: Codable {
    let name: String?
    let id: String
    let type: PropertiesType
}

enum PropertiesType: String, Codable {
    case ciclofaixa = "Ciclofaixa"
    case ciclovia = "Ciclovia"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
////
//struct MapOverlayer {
//    var overlay: MKOverlay
//    var polylineInfo: Ciclo
//}
//guardando a forma overlay
//class MapOverlays {
//
//    private var overlayList = [MapOverlayer]()
//    static var shared = MapOverlays()
//
//    func addOverlay(mapOverlayer: MapOverlayer) {
//        MapOverlays.shared.overlayList.append(mapOverlayer)
//    }
//    func returnOverlay() -> [MapOverlayer] {
//        return MapOverlays.shared.overlayList
//    }
    //func pra renderizar para ser usada na funcao de load(decode)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = UIColor.blue
            
            return renderer
        }
      
        return MKOverlayRenderer.init()
        }



class overlayer {
    static var shared = overlayer(polylineInfo: Ciclo.init(features: [Feature.init(type: FeatureType.feature, properties: Properties.init(name: "", id: "", type: PropertiesType.ciclovia), geometry: Geometry.init(type: GeometryType.lineString, coordinates: [[0.0]]))]))
    
    var polylineInfo : Ciclo

    init(polylineInfo: Ciclo) {
    self.polylineInfo = polylineInfo
 }

func changePolyline(newPolyline: Ciclo) {
    self.polylineInfo = newPolyline
 }
}

// Extension to decode JSON locally
extension Bundle {
    // pra renderizar
//    func render(overlay: MKOverlay, info: Any?) {
//        if let polylineInfo = info as? Ciclo {
//            overlayer.shared.changePolyline(newPolyline: polylineInfo)
//        }
////        let newMapOverlay = MapOverlayer(overlay: overlay, polylineInfo: overlayer.shared.polylineInfo)
////        MapOverlays.shared.addOverlay(mapOverlayer: newMapOverlay)
////
////    }
    // funcao completa para carregar, ler e desenhar a Forma de polyline
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode from bundle.")
        }
        print(loadedData)
        
//        for item in geoJson {
//            if let feature = item as? MKGeoJSONFeature {
//                let geometry = feature.geometry.first
//                let propData = feature.properties!
//                if let polyline = geometry as? MKPolyline {
//                    let polylineInfo = try? JSONDecoder.init().decode(Ciclo.self, from: propData)
//                    //call render function pra forma
//                    self.render(overlay: polyline, info: polylineInfo)
//                }
//                for geo in feature.geometry {
//                    if let polyline = geo as? MKPolyline {
//                        overlays.append(polyline)
//                    }
//                }
//                
//            }
//        }
//
        return loadedData
    }
    
    
}

