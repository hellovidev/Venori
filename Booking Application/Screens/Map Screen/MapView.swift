//
//  MapView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import MapKit
import SwiftUI

struct MapPin: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapViewDetails: View {
    @ObservedObject var viewModel: MapViewModel
        
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(viewModel.region), annotationItems: [MapPin(name: "I'm here", coordinate: viewModel.coordinate)] ) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Image("Point Pin")
                        .resizable()
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                        .scaledToFit()
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Button {
                    viewModel.controller?.redirectPrevious()
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

// MARK: -> Map Item Preview

struct MapPreview: View {
    var longitude: Double
    var latitude: Double
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), annotationItems: [MapPin(name: "I'm here", coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))] ) { location in
            MapAnnotation(coordinate: location.coordinate) {
                Image("Point Pin")
                    .resizable()
                    .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                    .scaledToFit()
                Text("\(location.name)")
            }
        }
        .frame(maxWidth: 200, maxHeight: 200, alignment: .center)
        //.frame(maxWidth: 88, maxHeight: 88, alignment: .center)
        .scaledToFill()
        .cornerRadius(16)
        
//        MapView(longitude: longitude, latitude: latitude)
//            .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
//            .scaledToFill()
//            .cornerRadius(16)
    }
}
