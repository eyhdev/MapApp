//
//  ContentView.swift
//  MapApp
//
//  Created by eyh.mac on 26.08.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    @State private var location: [MKPointAnnotation] = []
    
    var body: some View {
        ZStack{
            MapView(centerCoordinate: $centerCoordinate, annotations: location)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .frame(width: 32, height: 32)
            
            VStack{
                Spacer()
                Button(action: {
                    
                    let newLocation = MKPointAnnotation()
                    newLocation.coordinate = self.centerCoordinate
                    self.location.append(newLocation)
                    
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(.ultraThinMaterial)
                        .foregroundColor(.black)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
            }
        }
    }
    
    struct MapView: UIViewRepresentable {
        @Binding var centerCoordinate: CLLocationCoordinate2D
        var annotations: [MKPointAnnotation]
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            if annotations.count != uiView.annotations.count {
                uiView.removeAnnotations(uiView.annotations)
                uiView.addAnnotations(annotations)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, MKMapViewDelegate {
            var parent: MapView
            
            init(_ parent: MapView) {
                self.parent = parent
            }
            
            func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
                parent.centerCoordinate = mapView.centerCoordinate
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
