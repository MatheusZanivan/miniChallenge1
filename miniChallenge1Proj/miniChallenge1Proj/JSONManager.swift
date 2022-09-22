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

struct ResponseData: Decodable {
    var person: [Ciclo]
}
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

//func parse(jsonData: Data) -> Ciclo? {
//    do {
//        let decodedData = try JSONDecoder().decode(Ciclo.self, from: jsonData)
//        return decodedData
//    } catch {
//        print("error: \(error)")
//    }
//    return nil
//}
// Extension to decode JSON locally
extension Bundle {
 
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
        
        return loadedData
    }
    
    
}

//func readLocalJSONFile(forName name: String) -> Data? {
//    do {
//        if let filePath = Bundle.main.path(forResource: name, ofType: "geojson") {
//            let fileUrl = URL(fileURLWithPath: filePath)
//            let data = try Data(contentsOf: fileUrl)
//            return data
//        }
//    } catch {
//        print("error: \(error)")
//    }
//    return nil
//}
