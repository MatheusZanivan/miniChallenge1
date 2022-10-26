import MapKit
import CoreLocation
import SwiftUI

class CalculaDistancia : ObservableObject{
    struct EstruturaTupla {
        var id : String
        var nome : String
        var distancia : Double
        var cordenada : CLLocationCoordinate2D
    }
    private var listaDeCordenadas :[EstruturaTupla] = []
    private var listaDeCordenadasOrdenadas : [EstruturaTupla] = []
    private var tresMelhoresLocations : [CLLocationCoordinate2D] = []
    @Published var locationList : [MapLocation] = []
    
//    @ObservedObject var lista: CalculaDistancia = CalculaDistancia()
    static var classeCalcula : CalculaDistancia = CalculaDistancia()
    
    let cicloviaSP: Ciclo = Ciclo.ciclovias
    func ordenaCordenadas(){
        
    }
    
    func tresMelhores() {
        locationList.removeAll()
        var primeiroNome : String = ""
        var segundoNome : String = ""
        var terceiroNome : String = ""
        var cont : Int = 0
        
        repeat{
            for i in listaDeCordenadasOrdenadas{
                if i.nome != primeiroNome && i.nome != segundoNome{
                    if primeiroNome ==  ""{
                        primeiroNome = i.nome
                        locationList.append(.init(title: primeiroNome, location: CLLocation(latitude: i.cordenada.latitude, longitude: i.cordenada.longitude)))
                        cont += 1
                        break
                    }
                    else if segundoNome ==  ""{
                        segundoNome = i.nome
                        locationList.append(.init(title: segundoNome, location: CLLocation(latitude: i.cordenada.latitude, longitude: i.cordenada.longitude)))
                        cont += 1
                        break
                    }
                    else{
                        terceiroNome = i.nome
                        locationList.append(.init(title: terceiroNome, location: CLLocation(latitude: i.cordenada.latitude, longitude: i.cordenada.longitude)))
                        cont += 1
                        break
                    }
                }
            }
        }while cont < 3
    }
    
    
    public func calculaDistancia(localizacaoDoUsuario: CLLocation){
        listaDeCordenadas.removeAll()
        for feature in cicloviaSP.features{
            let id = feature.properties.id
//            let name = feature.properties.name ?? as Any
            let name = feature.properties.name
            for cordenadas in feature.geometry.coordinates{
                let lat = cordenadas[1]
                let lon = cordenadas[0]
                let cordenada = CLLocation(latitude: lat, longitude: lon)
                let cordenada2d = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                let distancia = localizacaoDoUsuario.distance(from: cordenada)
                listaDeCordenadas.append(EstruturaTupla.init(id: id,nome: name, distancia: distancia, cordenada: cordenada2d))
                
            }
        }
        listaDeCordenadasOrdenadas.removeAll()
        listaDeCordenadasOrdenadas = listaDeCordenadas.sorted{
            $0.distancia < $1.distancia
        }
        tresMelhores()
    }
}
