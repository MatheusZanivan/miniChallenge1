//
//  ContentView.swift
//  MapTeste2.2
//
//  Created by Vinicius Gomes on 05/09/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    //mostra sheet view
    @State private var isShowingSheet = false
    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location: CGPoint = CGPoint(x:0,y:0)
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.6699, longitude: -46.7012),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
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
            
            Button {
                
            } label: {
                Label {
                    Text("")
                } icon: {
                    Image(systemName: "location").frame(width: 40.0, height: 40.0).background(.white).foregroundColor(.gray).cornerRadius(5)
                }
                
            }.position(x: screenW * 0.93, y: screenH * 0.1)
            
            GeometryReader {
                reader in BottomSheet().offset(y: reader.frame(in:  .global).height - 60)
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({
                        (value) in withAnimation {
                            translation = value.translation
                            location = value.location
                            if value.startLocation.y > reader.frame(in: .global).minX {
                                if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 60) {
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
                                    offset = (-reader.frame(in: .global).height + 60 )
                                    return
                                }
                                
                                
                            }
                        }
                        
                    }))
            }
            
            
        }
        
        
    }
    func didDismiss() {
        // Handle the dismissing action.
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
    
    
}


struct BottomSheet : View {
    @State var text = ""
    var body : some View {
        
        
        ZStack {
            
            VStack{
                
                Capsule()
                    .fill(Color(white: 0.81))
                    .frame( width:50,height:5)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Pesquisar" , text: $text).padding(.horizontal, 20).frame(width: .infinity, height: 40).font(.system(size: 15))
                        .background(.white)
                        .cornerRadius(10)
                    
                }.padding(.horizontal, 20).padding(.top, 5)
                List {
                    Section (header: Text("Proximos")) {
                        Text("A List Item")
                        Text("A Second List Item")
                        Text("A Third List Item")
                    }
                    
                }.background(BlurShape()).listStyle(.insetGrouped)
            }
        }.padding(.top,10)
            .background(BlurShape())
            .ignoresSafeArea()
        
        
    }
}

struct BlurShape: UIViewRepresentable {
    func makeUIView (context: Context ) -> UIVisualEffectView{
        return UIVisualEffectView (effect : UIBlurEffect ( style: .systemMaterial))
    }
    func updateUIView (_ uiView: UIVisualEffectView, context: Context) {
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            ContentView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}

