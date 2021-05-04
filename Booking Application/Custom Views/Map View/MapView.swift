//
//  MapView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    let longitude: Double
    let latitude: Double
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 53.669353, longitude: 23.813131)
        let span = MKCoordinateSpan(latitudeDelta:0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Place Location"
        annotation.subtitle = "Visit us soon"
        view.addAnnotation(annotation)
        
    }

}

struct MapViewDetails: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        ZStack {
            MapView(longitude: viewModel.longitude ?? 0, latitude: viewModel.latitude ?? 0)
                .ignoresSafeArea()
            VStack {
                Button {
                    viewModel.controller?.closeMapView()
                } label: {
                    Image("Close")
                        .padding([.top, .bottom, .trailing], 22)
                        .padding(.leading, 16)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewDetails(viewModel: MapViewModel())
    }
}

// MARK: -> Map Item Preview

struct MapPreview: View {
    let longitude: Double
    let latitude: Double
    
    var body: some View {
        MapView(longitude: longitude, latitude: latitude)
            .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
            .scaledToFill()
            .cornerRadius(16)
    }
}

//struct MapPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPreview()
//    }
//}
