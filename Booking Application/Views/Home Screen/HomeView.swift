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
    
    @State private var editing: Bool = false
    @State private var text: String = ""
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                    
                    // MARK: -> Navigation Bar Block
                    
                    HStack(alignment: .center) {
                        SearchBarView(text: $text, isEditing: $editing)
                            .isHidden(!editing, remove: !editing)
                            .padding(.top, 12)
                            .padding(.bottom, 10)
                            .padding([.trailing,.leading], 8)
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
                        .isHidden(editing, remove: editing)
                        Spacer()
                            .isHidden(editing, remove: editing)
                        Button (action: {
                            editing.toggle()
                        }, label: {
                            Image("Search")
                                .resizable()
                                .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                        })
                        .isHidden(editing, remove: editing)
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                    }
                    
                    if !editing {
                        // MARK: -> Scroll View For Load Data
                        
                        ScrollView(showsIndicators: false){
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
                                                    }, onFavouriteClick: { _ in
                                                        object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
                                                    })
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
                                                }, onFavouriteClick: { _ in
                                                    object.favourite ?? false ? self.viewModel.deleteFavouriteState(place: object) : self.viewModel.setFavouriteState(place: object)
                                                })
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
                                                    self.viewModel.controller?.redirectCategoryPlaces(categoryIdentifier: object.id, categoryName: object.name)
                                                }).padding(.leading, 16)
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(.bottom, 26)
                            }
                        }
                    } else {
                        // MARK: -> Grid On Scroll View For Load Data
                        
                        ScrollView(showsIndicators: !viewModel.placesSearch.isEmpty) {
                            LazyVGrid(columns: columns, spacing: 15) {
                                
                                // Search Meethod Here
                                
                                ForEach(viewModel.places.filter({ text.isEmpty ? true : $0.name.lowercased().contains(text.lowercased()) }), id: \.self) { item in
                                    PlaceCardView(place: item, onCardClick: {
                                        viewModel.controller?.redirectPlaceDetails(object: item)
                                    }, onFavouriteClick: { _ in
                                        guard item.favourite != nil else { return }
                                        if item.favourite! {
                                            viewModel.deleteFavouriteState(place: item)
                                        } else {
                                            viewModel.setFavouriteState(place: item)
                                        }
                                    })
                                    .id(UUID())
                                    .onAppear {
                                        viewModel.loadMoreContentIfNeeded(currentItem: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 35)
                            
                            // MARK: -> While Data Loading Show Progress View
                            
                            if viewModel.isLoadingPage {
                                ProgressView()
                            }
                            
                            // MARK: -> Empty Data View
                            
                            if !viewModel.isLoadingPage && viewModel.placesSearch.isEmpty {
                                VStack {
                                    Image("Empty")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                                    Text("No Data")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(Color.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .padding(.top, 128)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
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
