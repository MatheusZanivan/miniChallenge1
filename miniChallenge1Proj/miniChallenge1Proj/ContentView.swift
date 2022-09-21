//
//  ContentView.swift
//  MapTeste2.2
//
//  Created by Vinicius Gomes on 05/09/22.
//

import Combine
import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel()
    @StateObject var deviceLocationService = DeviceLocationService.shared
  
    
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0,0)
    
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    //mostra sheet view
    @State private var isShowingSheet = false
    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location: CGPoint = CGPoint(x:0,y:0)
    @State var locationManager = CLLocationManager()
    @State var showMapAlert = true
    
    
    //trazer o array do json para ca
    @State private var lineCoordinates = [

      // Steve Jobs theatre
      CLLocationCoordinate2D(latitude: -23.6304237, longitude: -46.7380401),

      // Caffè Macs
      CLLocationCoordinate2D(latitude: -23.6307354, longitude: -46.7377035),

      // Apple wellness center
      CLLocationCoordinate2D(latitude: -23.631134, longitude:  -46.7372572)
    ];
    
    
        @State var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -23.6699, longitude: -46.7012),
            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
    var body: some View {
    
        ZStack {
            
            MapView(region: region, lineCoordinates: lineCoordinates, locationManager: $locationManager, showMapAlert: $showMapAlert).ignoresSafeArea().onAppear {
                observeCoordinateUpdates()
                observeLocationAccessDenied()
                deviceLocationService.requestLocationUpdates()
            }

        
        
        
          
            Button(action: {
                isShowingSheet = true
                
            }, label: {
                Label {
                    Text("")
                } icon: {
                    Image(systemName: "info.circle").frame(width: 40.0, height: 40.0).background(.white).foregroundColor(.gray).cornerRadius(5)
                }
                
            }).sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
                
                ShowLicenseAgreement()
                Button("Voltar",
                       action: { isShowingSheet.toggle() })
                
            }.position(x: screenW * 0.93, y: screenH * 0.05)
            
            Button(action:  {
                if viewModel.requestAllowOnceLocationPermission() != viewModel.requestAllowOnceLocationPermission() {
                    viewModel.requestAllowOnceLocationPermission()
                }
                else {
                    showMapAlert = true
                }
            
          
//

                

            },label: {
                Label {
                    Text("")
                } icon: {
                    Image(systemName: "location").frame(width: 40.0, height: 40.0).background(.white).foregroundColor(.gray).cornerRadius(5)
                }
                
            }).position(x: screenW * 0.93, y: screenH * 0.1)
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
        } .alert(isPresented: $showMapAlert) { // 4
            
            Alert(title: Text("O app funciona melhor com os Serviços de Localização ativados."),
                           message: Text("Nós precisamos da sua localização para funcionamento do APP, entre em Ajustes e permita a localização"),
                           primaryButton: .cancel(Text("Manter Serviços de Localização Desativados.")),
                           secondaryButton: .default(Text("Ativar nos Ajustes"),
                                                     action: { self.goToDeviceSettings() }))
        }
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
    //Verifica se existe erro e Atualiza as coordenadas
    func observeCoordinateUpdates(){
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAcessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
    
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

struct BottomSheet : View {
    @State var text = ""
    var body : some View {
        
        
        ZStack {
            VStack{
                Capsule()
                    .fill(Color(white: 0.81))
                    .frame( width:50,height:5)
                List {
                    Section (header: Text("Ciclovias & Ciclofaixas")) {
                        Button("A List Item") {
                        }.foregroundColor(.black)
                        Button("A Second List Item") {
                        }.foregroundColor(.black)
                        Button("Another List Item") {
                        }.foregroundColor(.black)
                    }
                    
                }.listStyle(.insetGrouped)
            }
        }.padding(.top,10)
            .ignoresSafeArea().background(Color(.init(red: 0.949, green: 0.949, blue: 0.975, alpha: 1)))
        
        
    }
}

struct BlurShape: UIViewRepresentable {
    func makeUIView (context: Context ) -> UIVisualEffectView{
        return UIVisualEffectView (effect : UIBlurEffect ( style: .systemMaterial))
    }
    func updateUIView (_ uiView: UIVisualEffectView, context: Context) {
    }
    
}
extension ContentView {
  ///Path to device settings if location is disabled
  func goToDeviceSettings() {
    guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
