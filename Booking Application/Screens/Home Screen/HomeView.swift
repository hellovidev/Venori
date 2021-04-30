//
//  HomeView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var serviceAPI = ServiceAPI()
    var favIsEmpty: Bool = true //***
//
//    @State private var showPopUp: Bool = false
//    @State private var errorMessage: String = ""
    
    var body: some View {
//        ZStack{
        NavigationBarView(title: "", isRoot: true, isSearch: true, isLast: false, color: .white, onBackClick: {}) {
            ScrollView {
                VStack {
                    
                    // MARK: -> Favorite Restaurants Block
                    
                    VStack(alignment: .leading) {
                        SectionSeparatorView(title: "My Favorite Restaraunts", onClick: { })
                        if favIsEmpty {
                            FavouriteEmptyView()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -8) {
                                    ForEach(viewModel.places, id: \.self) { object in
                                        PlaceCardView(onClick: {
                                            self.viewModel.controller?.redirectToPlaceDetails(object: object)
                                        }, loveClick: {
                                            // Favourite Action
                                        }, namePlace: object.name, ratingPlace: object.rating, reviewsCount: object.reviewsCount, backgroundImage: DomainRouter.generalDomain.rawValue + object.imageURL)
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
                                ForEach(viewModel.places, id: \.self) { object in
                                    PlaceCardView(onClick: {
                                        self.viewModel.controller?.redirectToPlaceDetails(object: object)
                                    }, loveClick: {
                                        // Favourite Action
                                    }, namePlace: object.name, ratingPlace: object.rating, reviewsCount: object.reviewsCount, backgroundImage: DomainRouter.generalDomain.rawValue + object.imageURL)
                                    .padding(.leading, 16)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 26)
                    .onAppear {
                        serviceAPI.fetchDataAboutPlaces(completion: { result in
                            switch result {
                            case .success(let places):
                                self.viewModel.places = places.data
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")

                                  }
                                print(error)
                                //print(error.localizedDescription)
                            }
                            
                            //self.state.categories = self.serviceAPI.categories!.data
                        })
                    }
//                    .onAppear {
//                        if ((serviceAPI.places?.data?.isEmpty) != nil) {
//                            self.serviceAPI.fetchDataAboutPlaces()
//                        }
//                    }
                    
                    // MARK: -> Categories Block
                    
                    VStack(alignment: .leading) {
                        SectionSeparatorView(title: "Food Categories", onClick: {
                            viewModel.controller?.seeAllCategories()
                        })
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -8) {
                                ForEach(viewModel.categories, id: \.self) { object in
                                    CategoryView(title: object.name, imageName: DomainRouter.generalDomain.rawValue + object.imageURL, onClick: {}).padding(.leading, 16)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 26)
                    .onAppear {

                        serviceAPI.fetchDataAboutCategories(completion: { result in
                            switch result {
                            case .success(let categories):
                                self.viewModel.categories = categories.data
                            case .failure(let error):
                                

//                                self.errorMessage = error.localizedDescription
//                                showPopUp.toggle()
                                DispatchQueue.main.async {
                                    viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")

                                  }
                                //print(error)
                                //print(error.localizedDescription)
                            }
                            
                            //self.state.categories = self.serviceAPI.categories!.data
                        })
                    }
//                    .onAppear {
//                        if ((serviceAPI.categories?.data.isEmpty) != nil) {
//                            self.serviceAPI.fetchDataAboutCategories()
//                        }
//                    }
                }
            }
//        }
//        ErrorPopUpView(title: "Error", message: self.errorMessage, show: $showPopUp)
    }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
