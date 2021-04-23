//
//  MapView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude:53.669353, longitude:23.813131)
        let span = MKCoordinateSpan(latitudeDelta:0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
    
}

struct MapViewDetails: View {
    @ObservedObject var mapViewModel: MapViewModel
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            VStack {
                Button {
                    mapViewModel.controller?.closeMapView()
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
        MapViewDetails(mapViewModel: MapViewModel())
    }
}

// MARK: -> Map Item Preview

struct MapPreview: View {
    var body: some View {
        MapView()
            .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
            .scaledToFill()
            .cornerRadius(16)
    }
}

struct MapPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapPreview()
    }
}
