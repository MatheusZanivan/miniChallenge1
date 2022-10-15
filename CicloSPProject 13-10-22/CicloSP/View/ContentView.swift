import SwiftUI
import MapKit

let mapView = MKMapView()

struct ContentView: View{
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location: CGPoint = CGPoint(x:0,y:0)
    @State  private var showMapAlert = false
    
    //verifica o estado da tela
    @State private var isShowingSheet = false
    
    // cria uma variavel que quando o valor é alterado, altera em todas as outras views
    @EnvironmentObject var locationStore : LocationStore
    var selectedLocation:MapLocation

    var body: some View {
        ZStack{
            MapView(mapView)
                .ignoresSafeArea()
                .onChange(of: locationStore.phoneLocation.location){ _ in 
                  
                    mapView.centerCoordinate = locationStore.phoneLocation.location.coordinate
                        
                }
          
                    
            Button(action: {
                isShowingSheet = true
                
            }, label: {
                Label {
                    Text("")
                } icon: {
                    if #available(iOS 14.0, *) {
                        Image(systemName: "info.circle").foregroundColor(Color(red: 0.39215686274509803, green: 0.34509803921568627, blue: 0.792156862745098)).frame(width: 40.0, height: 40.0).background(.white).cornerRadius(5)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }).sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
                
                ShowLicenseAgreement()
                Button("Voltar",
                       action: { isShowingSheet.toggle() })
                
            }.position(x: screenW * 0.93, y: screenH * 0.05)
            
            Button(action:{
                switch CLLocationManager.authorizationStatus() {
                case .denied:
                    showMapAlert = true
                case .authorizedAlways:
                        mapView.centerCoordinate = locationStore.phoneLocation.location.coordinate
                        
                case .authorizedWhenInUse:
                    
                        mapView.centerCoordinate = locationStore.phoneLocation.location.coordinate
                        
                @unknown default:
                    break
                }
            },label: {
                Label {
                    Text("")
                } icon: {
                    if #available(iOS 14.0, *) {
                        Image(systemName: "location.fill").foregroundColor(Color(red: 0.39215686274509803, green: 0.34509803921568627, blue: 0.792156862745098)).frame(width: 40.0, height: 40.0).background(.white).cornerRadius(5)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }).position(x: screenW * 0.93, y: screenH * 0.1)
            
            //chamar a sheet view aqui
            GeometryReader {
                reader in BottomSheet().offset(y: reader.frame(in:  .global).height - 90)
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({
                        (value) in withAnimation {
                            translation = value.translation
                            location = value.location
                            if value.startLocation.y > reader.frame(in: .global).minX {
                                if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 10) {
                                    offset = value.translation.height
                                }
                            }
                            if  value.startLocation.y < reader.frame(in: .global).minX {
                                if value.translation.height > 0 && offset < 0  {
                                    offset = (-reader.frame(in: .global).height + 60) + value.translation.height
                                }
                            }
                        }
                        
                    }).onEnded({ (value) in
                        withAnimation {
                            if value.startLocation.y > reader.frame(in: .global).minX {
                                if -value.translation.height > reader.frame(in: .global).minX {
                                    offset = (-reader.frame(in: .global).height / 2)
                                    return
                                }
                                offset = 0
                            }
                            else if value.startLocation.y < reader.frame(in: .global).minX {
                                if -value.translation.height < reader.frame(in: .global).minX {
                                    offset = (-reader.frame(in: .global).height - 60 )
                                    return
                                }
                            }
                        }
                    }))
            }
          
        }.alert(isPresented: $showMapAlert) { // 4
                    Alert(title: Text("O app funciona melhor com os Serviços de Localização ativados."),
                          message: Text("Nós precisamos da sua localização para funcionamento do APP, entre em Ajustes e permita a localização"),
                          primaryButton: .cancel(Text("Manter Serviços de Localização Desativados.")),
                          secondaryButton: .default(Text("Ativar nos Ajustes"),
                                                    action: { self.goToDeviceSettings() }))
                }
            }
}



func didDismiss() {
    
}


struct ShowLicenseAgreement: View {
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    var body: some View {
        VStack {
            Text("Licenças e Termos")
                .font(.title).position(x: screenH * 0.23, y: screenW * 0.3)
            Text("Todos os dados usados nesse aplicativo referente as localizações das ciclofaixas e ciclovias estão reservados e disponiveis nas plataformas OpenSources.").multilineTextAlignment(.center)
        }.padding(.leading,10).padding(.trailing,10).frame(height: 250)
        HStack {
            Link( "©CicloMap", destination: URL(string: "https://ciclomapa.org.br")!)
            Link( "©OpenStreetMap", destination: URL(string: "https://www.openstreetmap.org/about/")!)
            
        }.padding(50)
    }
}



//um ObservableObject é um protocolo, que carrega dados
//esses dados são atualizados dentro de todas as views

class LocationStore : ObservableObject{
    //
    var num = 1
    @Published var selectedLocation : MapLocation = .init(title: "", location: .init(latitude: 0.0, longitude: 0.0))
    //colocar o marco 0, logo se nao tiver localizacao o usuário aparecera no meio de SP
    //-23.54804881474109, -46.63404710273852
    @Published var phoneLocation : MapLocation = .init(title: "", location: .init(latitude: -23.54804881474109, longitude: -46.63404710273852))
 
}

    extension ContentView {
        func goToDeviceSettings() {
            guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
}
