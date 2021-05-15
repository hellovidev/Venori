//
//  DetailsRestarauntView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import MapKit
import SwiftUI

struct PlaceDetailsView: View {
    @ObservedObject var viewModel: PlaceDetailsViewModel
    @State private var showPopUp: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                ZStack {
                    ImageURL(url: DomainRouter.generalDomain.rawValue + viewModel.place.imageURL)
                        .background(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: 256, alignment: .center)
                    HStack(alignment: .center) {
                        Button (action: {
                            self.viewModel.controller?.redirectPrevious()
                        }, label: {
                            Image("Arrow Left White")
                                .padding([.top, .bottom], 12)
                                .padding(.leading, 16)
                        })
                        Spacer()
                        Button (action: {
                            self.viewModel.place.favourite ?? false ? self.viewModel.deleteFavouriteState() : self.viewModel.setFavouriteState()
                        }, label: {
                            Image("Heart")
                                .resizable()
                                .renderingMode(.template)
                                .frame(maxWidth: 22, maxHeight: 22, alignment: .center)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(viewModel.place.favourite ?? false ? Color.blue : Color(UIColor(hex: "#0000007A")!))
                                .clipShape(Circle())
                                .padding([.top, .bottom], 12)
                                .padding(.trailing, 16)
                        })
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 36)
                }
                VStack(alignment: .leading) {
                    Text(viewModel.place.name)
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 22)
                        .padding(.bottom, 2)
                    Text("Coffee")
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .font(.system(size: 12, weight: .regular))
                        .padding(.bottom, 8)
                    HStack(alignment: .center) {
                        StarsView(rating: viewModel.place.rating)
                            .padding(.trailing, 4)
                        Text("\(NSString(format: "%.01f", viewModel.place.rating))")
                            .font(.system(size: 18, weight: .semibold))
                        Button(action: {
                            self.viewModel.controller?.redirectReviews(placeIdentifier: viewModel.place.id)
                        }, label: {
                            Text("\(viewModel.place.reviewsCount) Reviews")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        })
                    }
                    .padding(.bottom, 24)
                    HStack(alignment: .top) {
                        HStack(alignment: .top){
                            Image("Map Pin")
                                .padding(.trailing, 8)
                                .padding(.top, 18)
                            VStack(alignment: .leading) {
                                Text(viewModel.place.addressFull)
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.bottom, 2)
                                Button (action: {
                                    viewModel.controller?.showMapView()
                                }, label: {
                                    Text("View map")
                                        .font(.system(size: 12, weight: .regular))
                                })
                            }
                            .frame(maxHeight: .infinity)
                        }
                        Spacer()
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.place.addressLat, longitude: viewModel.place.addressLon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), annotationItems: [MapPin(name: "I'm here", coordinate: CLLocationCoordinate2D(latitude: viewModel.place.addressLat, longitude: viewModel.place.addressLon))] ) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                Image("Point Pin")
                                    .resizable()
                                    .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                                    .scaledToFit()
                            }
                        }
                        .body.hidden()
                        .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
                        .scaledToFill()
                        .cornerRadius(16)
                    }
                    .padding(.bottom, 20)
                    HStack {
                        Image("Phone")
                            .padding(.trailing, 8)
                        if(viewModel.place.phone != nil) {
                            Text(viewModel.place.phone!.isEmpty ? "No phone": viewModel.place.phone!)
                                .font(.system(size: 18, weight: .regular))
                        } else {
                            Text("No phone")
                                .font(.system(size: 18, weight: .regular))
                        }
                    }
                    .padding(.bottom, 22)
                    HStack(alignment: .top) {
                        Image("Time")
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            Text("Avaliable until \(self.viewModel.workTime ?? "unknown")")
                                .font(.system(size: 18, weight: .regular))
                                .padding(.bottom, 2)
                            Button (action: {
                                showPopUp.toggle()
                            }, label: {
                                Text("View schedule")
                                    .font(.system(size: 12, weight: .regular))
                            })
                        }
                    }
                    .padding(.bottom, 24)
                    HStack(alignment: .top) {
                        Image("Info")
                            .padding(.trailing, 8)
                        Text(viewModel.place.description)
                            .font(.system(size: 18, weight: .regular))
                    }
                }
                .padding([.leading, .trailing], 16)
                Spacer()
                Button(action: {
                    self.viewModel.controller?.redirectBookingProcess(placeIdentifier: viewModel.place.id)
                }, label: {
                    Text("Book a table")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                })
                .modifier(ButtonModifier())
                .padding(.bottom, 35)
            }
            .ignoresSafeArea(.container, edges: .top)
            
            SchedulePopUpView(placeIdentifier: viewModel.place.id, schedules: viewModel.schedules, show: $showPopUp)
        }
    }
    
}

struct StarsView: View {
    
    // Defines upper limit of the rating
    
    private static let MAX_RATING: Float = 5
    
    // The color of the stars
    
    private static let COLOR = Color.yellow
    
    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int
    
    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(StarsView.MAX_RATING - rating)
        halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
    }
    
    var body: some View {
        HStack {
            ForEach(0..<fullCount) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount) { _ in
                self.emptyStar
            }
        }
    }
    
    private var fullStar: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(maxWidth: 22, maxHeight: 20)
            .foregroundColor(StarsView.COLOR)
    }
    
    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill")
            .resizable()
            .frame(maxWidth: 22, maxHeight: 20)
            .foregroundColor(StarsView.COLOR)
    }
    
    private var emptyStar: some View {
        Image(systemName: "star")
            .resizable()
            .frame(maxWidth: 22, maxHeight: 20)
            .foregroundColor(StarsView.COLOR)
    }
    
}
