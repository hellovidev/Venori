//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var serviceAPI = ServiceAPI()
    var favIsEmpty: Bool = true //***
//
//    @State private var showPopUp: Bool = false
//    @State private var errorMessage: String = ""
    
    var body: some View {
//        ZStack{
            NavigationView {

            VStack {
                HStack(alignment: .center) {
            Button (action: {
                self.viewModel.controller?.showMapView()
            },  label: {
                Image("Pin")
                    .padding([.leading, .top, .bottom], 16)
                    .padding(.trailing, 6)
                VStack(alignment: .leading) {
                    Text("Location")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .padding(.bottom, -8)
                    HStack(alignment: .center) {
                        Text(viewModel.addressFull ?? "Current location")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                        Image("Vector")
                    }
                }
            })
            Spacer()
                    Button (action: {
            }, label: {
                Image("Search")
            })
            .padding(.top, 12)
            .padding(.trailing, 16)
            .padding(.bottom, 12)
                }
            
//            ScrollView {
//                VStack {
//                    // MARK: -> Favorite Restaurants Block
//
//                    VStack(alignment: .leading) {
//                        SectionSeparatorView(title: "My Favorite Restaraunts", onClick: {
//                                                //self.viewModel.locationManager(viewModel.locationManager!, didChangeAuthorization: viewModel.locationManager!.authorizationStatus)
//
//                        })
//                        if viewModel.favorites.isEmpty {
//                            FavouriteEmptyView()
//                        } else {
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: -8) {
//                                    ForEach(viewModel.favorites, id: \.self) { object in
//                                        PlaceCardView(place: object, onClick: {
//                                            self.viewModel.controller?.redirectToPlaceDetails(object: object)
//                                        }, loveClick: {
//                                            object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
//                                        })
//                                        .padding(.leading, 16)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.bottom, 26)
//                    .onAppear {
//                        serviceAPI.fetchDataAboutFavourites(completion: { result in
//                            switch result {
//                            case .success(let favorites):
//                                self.viewModel.favorites = favorites.data
//
//                                for (index, _) in self.viewModel.favorites.enumerated() {
//                                    self.viewModel.favorites[index].favourite = true
//                                }
//
//                            case .failure(let error):
//                                DispatchQueue.main.async {
//                                    viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
//
//                                  }
//                                print(error)
//                                //print(error.localizedDescription)
//                            }
//
//                            //self.state.categories = self.serviceAPI.categories!.data
//                        })
//
//                        //self.viewModel.controller?.locationManager(viewModel.controller?.locationManager, didChangeAuthorization: viewModel.controller?.locationManager?.authorizationStatus)
//                    }
//
//                    // MARK: -> Restaurants Block
//
//                    VStack(alignment: .leading) {
//                        SectionSeparatorView(title: "Restaurants", onClick: {
//                            viewModel.controller?.seeAllPlaces()
//                        })
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: -8) {
//                                ForEach(viewModel.places, id: \.self) { object in
//                                    PlaceCardView(place: object, onClick: {
//                                        self.viewModel.controller?.redirectToPlaceDetails(object: object)
//                                    }, loveClick: {
//                                        object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
//                                    })
//                                    .padding(.leading, 16)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.bottom, 26)
//                    .onAppear {
//                        serviceAPI.fetchDataAboutPlaces(completion: { result in
//                            switch result {
//                            case .success(let places):
//                                self.viewModel.places = places.data
//                            case .failure(let error):
//                                DispatchQueue.main.async {
//                                    viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
//
//                                  }
//                                print(error)
//                                //print(error.localizedDescription)
//                            }
//
//                            //self.state.categories = self.serviceAPI.categories!.data
//                        })
//                    }
////                    .onAppear {
////                        if ((serviceAPI.places?.data?.isEmpty) != nil) {
////                            self.serviceAPI.fetchDataAboutPlaces()
////                        }
////                    }
//
//                    // MARK: -> Categories Block
//
//                    VStack(alignment: .leading) {
//                        SectionSeparatorView(title: "Food Categories", onClick: {
//                            viewModel.controller?.seeAllCategories()
//                        })
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: -8) {
//                                ForEach(viewModel.categories, id: \.self) { object in
//                                    CategoryView(title: object.name, imageName: DomainRouter.generalDomain.rawValue + object.imageURL, onClick: {}).padding(.leading, 16)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.bottom, 26)
//                    .onAppear {
//
//                        serviceAPI.fetchDataAboutCategories(completion: { result in
//                            switch result {
//                            case .success(let categories):
//                                self.viewModel.categories = categories.data
//                            case .failure(let error):
//
//
////                                self.errorMessage = error.localizedDescription
////                                showPopUp.toggle()
//                                DispatchQueue.main.async {
//                                    viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
//
//                                  }
//                                //print(error)
//                                //print(error.localizedDescription)
//                            }
//
//                            //self.state.categories = self.serviceAPI.categories!.data
//                        })
//                    }
////                    .onAppear {
////                        if ((serviceAPI.categories?.data.isEmpty) != nil) {
////                            self.serviceAPI.fetchDataAboutCategories()
////                        }
////                    }
//
//
//
//
//
//
//
//
//
//                }
//            }
//        }
//        ErrorPopUpView(title: "Error", message: self.errorMessage, show: $showPopUp)
                
                
                EndlessList()
            }.navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}


struct EndlessList: View {
  @StateObject var dataSource = ContentDataSource()

  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(dataSource.items) { item in
            Text(item.price)
            .onAppear {
              dataSource.loadMoreContentIfNeeded(currentItem: item)
            }
            .padding(.all, 30)
        }

        if dataSource.isLoadingPage {
          ProgressView()
        }
      }
    }
  }
}
