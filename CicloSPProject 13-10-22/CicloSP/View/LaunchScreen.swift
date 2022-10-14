import SwiftUI

struct LaunchScreen: View {
    @State private var isActive = false
    @StateObject var locationStore = LocationStore()
    var body: some View {
        if isActive {
//            MapView(mapView).environmentObject(locationStore)
//            MapNavigationApp(locations:locationList)
            ContentView(selectedLocation: locationStore.selectedLocation).environmentObject(locationStore)
        } else {
            ZStack {
                ZStack {
                    Image("splashscreen")
                        .resizable()
                        .scaledToFill()
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                    }
                }
            }
            .onAppear {

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
//                        CalculaDistancia().calculaDistancia(localizacaoDoUsuario: locationStore.phoneLocation.location)
                        print(locationStore.phoneLocation.location)
                        self.isActive = true
                    }
                }
            }
        }
    }
}

