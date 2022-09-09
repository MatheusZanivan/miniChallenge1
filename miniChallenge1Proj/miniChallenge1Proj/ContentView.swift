//
//  ContentView.swift
//  MapTeste2.2
//
//  Created by Vinicius Gomes on 05/09/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
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
            Button {
                
            } label: {
                Label {
                    Text("")
                } icon: {
                    Image(systemName: "location").frame(width: 40.0, height: 40.0).background(.white).foregroundColor(.gray).cornerRadius(5)
                }
                
            }.position(x: 365, y: 75)
                    
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
    
    struct BottomSheet : View {
        @State var text = ""
        var body : some View {
            ZStack {
                Capsule()
                    .fill(Color(white: 0.81))
                    .frame( width:50,height:5).padding(.bottom,70)
                RoundedRectangle(cornerRadius: 20).frame(width: .infinity , height: 40).foregroundColor(Color(.init(srgbRed: 235, green: 235, blue: 240, alpha: 0.7)))
                TextField("Pesquisar" , text : $text ).frame(width: 300).padding()
            }.padding(.horizontal,10).padding(.bottom,500).padding(.top,10).background(BlurShape()).ignoresSafeArea()
            

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
}

