//
//  DetailsRestarauntView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import MapKit
import SwiftUI

struct DetailsRestarauntView: View {
    @ObservedObject var viewModel: DetailsRestarauntViewModel
    @State private var showPopUp: Bool = false
    
    var serviceAPI: ServiceAPI = ServiceAPI()
    
    var body: some View {
        ZStack {
            ScrollView {
                
                ZStack {
                    ImageURL(url: DomainRouter.generalDomain.rawValue + viewModel.place!.imageURL)
                        .frame(maxWidth: .infinity, maxHeight: 256, alignment: .center)
                        .overlay(
                            HStack(alignment: .center) {
                                Button {
                                    self.viewModel.controller?.goBack()
                                } label: {
                                    Image("Arrow Left White")
                                        .padding([.top, .bottom], 12)
                                        .padding(.leading, 16)
                                }
                                Spacer()
                                if self.viewModel.place != nil {
                                    Button (action: {
                                        self.viewModel.place?.favourite ?? false ? self.viewModel.deleteFavouriteState() : self.viewModel.setFavouriteState()
                                    }, label: {
                                        Image("Heart")
                                            .renderingMode(.template)
                                            .foregroundColor(self.viewModel.place?.favourite ?? false ? Color.red : Color.white)
                                            .padding([.top, .bottom], 12)
                                            .padding(.trailing, 16)
                                    })
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.top, 48)
                        )
                    //                VStack(alignment: .center) {
                    //
                    //                }
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                VStack(alignment: .leading) {
                    Text(viewModel.place!.name)
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 22)
                        .padding(.bottom, 2)
                    Text("Coffee")
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .font(.system(size: 12, weight: .regular))
                        .padding(.bottom, 8)
                    
                    HStack(alignment: .center) {
                        StarsView(rating: viewModel.place!.rating)
                            .padding(.trailing, 4)
                        Text("\(NSString(format: "%.01f", viewModel.place!.rating))")
                            .font(.system(size: 18, weight: .semibold))
                        Button(action: {
                            // Go To Revies Screen
                        }, label: {
                            Text("\(viewModel.place!.reviewsCount) Reviews")
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
                                Text(viewModel.place!.addressFull)
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.bottom, 2)
                                Button {
                                    viewModel.controller?.showMapView()
                                } label: {
                                    Text("View map")
                                        .font(.system(size: 12, weight: .regular))
                                }
                            }
                            .frame(maxHeight: .infinity)
                        }
                        Spacer()
                        if viewModel.place != nil {
                            
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.place!.addressLat, longitude: viewModel.place!.addressLon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), annotationItems: [MapPin(name: "I'm here", coordinate: CLLocationCoordinate2D(latitude: viewModel.place!.addressLat, longitude: viewModel.place!.addressLon))] ) { location in
                                MapAnnotation(coordinate: location.coordinate) {
                                    Image("Point Pin")
                                        .resizable()
                                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                                        .scaledToFit()
                                }
                            }
                            .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
                            .scaledToFill()
                            .cornerRadius(16)
                            
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image("Phone")
                            .padding(.trailing, 8)
                        Text(viewModel.place!.phone ?? "No phone")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding(.bottom, 22)
                    
                    
                    HStack(alignment: .top) {
                        Image("Time")
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            
                            Text("Avaliable until \(self.viewModel.workTime ?? "unknown")")
                                .font(.system(size: 18, weight: .regular))
                                .padding(.bottom, 2)
                            
                            Button {
                                showPopUp.toggle()
                                self.viewModel.controller?.showWeekSchedule(placeID: self.viewModel.place!.id)
                            } label: {
                                Text("View schedule")
                                    .font(.system(size: 12, weight: .regular))
                            }
                        }
                        
                    }
                    .padding(.bottom, 24)
                    .onAppear {
                        self.serviceAPI.getScheduleOfPlace(completion: { result in
                            switch result {
                            case .success(let weekSchedule): do {
                                //print(weekSchedule)
                                
                                switch Date().dayOfWeek()! {
                                case "Monday":
                                    self.viewModel.workTime = weekSchedule[1].workEnd!
                                case "Wednesday":
                                    self.viewModel.workTime = weekSchedule[3].workEnd!
                                default:
                                    self.viewModel.workTime = weekSchedule[0].workEnd!
                                }
                            }
                            //self.times = times
                            case .failure(let error):
                                print(error)
                            //                                    DispatchQueue.main.async {
                            //                                        viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                            //                                      }
                            }
                        }, placeIdentifier: self.viewModel.place!.id)
                        
                    }
                    
                    HStack(alignment: .top) {
                        Image("Info")
                            .padding(.trailing, 8)
                        Text(viewModel.place!.description)
                            .font(.system(size: 18, weight: .regular))
                    }
                }
                .padding([.leading, .trailing], 16)
                
                Spacer()
                
                Button(action: {
                    self.viewModel.controller?.redirectToBookingProcess(object: viewModel.place!)
                }) {
                    Text("Book a table")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                }
                .modifier(ButtonModifier())
                .padding(.bottom, 35)
            }
            .ignoresSafeArea(.container, edges: .top)
            
            SchedulePopUpView(placeIdentifier: self.viewModel.place!.id,show: $showPopUp, schedules: [])
        }
    }
}

struct DetailsRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsRestarauntView(viewModel: DetailsRestarauntViewModel())
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
            //.fixedSize()
            .foregroundColor(StarsView.COLOR)
    }
    
    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill")
            .resizable()
            .frame(maxWidth: 22, maxHeight: 20)
            //.fixedSize()
            .foregroundColor(StarsView.COLOR)
    }
    
    private var emptyStar: some View {
        Image(systemName: "star")
            .resizable()
            .frame(maxWidth: 22, maxHeight: 20)
            //.fixedSize()
            .foregroundColor(StarsView.COLOR)
    }
}
