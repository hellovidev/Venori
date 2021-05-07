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
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                    
                    // MARK: -> Navigation Bar Block
                    
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
                                .resizable()
                                .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                        })
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                    }
                    
                    // MARK: -> Scroll View For Load Data
                    
                    ScrollView {
                        VStack {
                            // MARK: -> Favorite Restaurants Block
                            
                            VStack(alignment: .leading) {
                                SectionSeparatorView(title: "My Favorite Restaraunts", onClick: {
                                    self.viewModel.controller?.seeAllFavourites()
                                })
                                if viewModel.favorites.isEmpty {
                                    FavouriteEmptyView()
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: -8) {
                                            ForEach(viewModel.favorites.sorted { $0.id < $1.id }, id: \.self) { object in
                                                PlaceCardView(place: object, onCardClick: {
                                                    self.viewModel.controller?.redirectPlaceDetails(object: object)
                                                }, onFavouriteClick: {
                                                    object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
                                                }, isProcessDelete: false)
                                                .padding(.leading, 16)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 26)
                            
                            // MARK: -> Restaurants Block
                            
                            VStack(alignment: .leading) {
                                SectionSeparatorView(title: "Restaurants", onClick: {
                                    viewModel.controller?.seeAllPlaces()
                                })
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: -8) {
                                        ForEach(viewModel.places.sorted { $0.id < $1.id }, id: \.self) { object in
                                            PlaceCardView(place: object, onCardClick: {
                                                self.viewModel.controller?.redirectPlaceDetails(object: object)
                                            }, onFavouriteClick: {
                                                object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
                                            }, isProcessDelete: false)
                                            .padding(.leading, 16)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 26)
                            
                            // MARK: -> Categories Block
                            
                            VStack(alignment: .leading) {
                                SectionSeparatorView(title: "Food Categories", onClick: {
                                    viewModel.controller?.seeAllCategories()
                                })
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: -8) {
                                        ForEach(viewModel.categories, id: \.self) { object in
                                            CategoryView(title: object.name, imageName: DomainRouter.generalDomain.rawValue + object.imageURL, onClick: {
                                                self.viewModel.controller?.redirectCategoryPlaces(object: object)
                                            }).padding(.leading, 16)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 26)
                        }
                    }
                }
                .navigationBarHidden(true)
                .alert(isPresented: $viewModel.showAlertError) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlertError = false }))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
