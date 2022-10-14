import Foundation


struct Ciclo: Codable {
    let features: [Feature]
    
    static let ciclovias: Ciclo = Bundle.main.decode(file: "BikePathsSP.geojson")
}

struct Feature: Codable {
    let type: FeatureType
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [[Double]]
}

enum GeometryType: String, Codable {
    case lineString = "LineString"
}

struct Properties: Codable {
    let name: String
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


extension Bundle {

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
       // print(loadedData)
        return loadedData
    }
    
    
}
