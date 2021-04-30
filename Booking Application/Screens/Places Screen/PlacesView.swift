//
//  AllRestarauntsView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct PlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    var serviceAPI = ServiceAPI()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationBarView(title: "Restaraunts", isRoot: false, isSearch: true, isLast: true, color: .white, onBackClick: {
            self.viewModel.controller?.redirectPrevious()
        }) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.places, id: \.self) { object in
                        PlaceCardView(onClick: {
                            self.viewModel.controller?.redirectToPlaceDetails(object: object)
                        }, loveClick: {
                            // Favorite Action
                        }, namePlace: object.name, ratingPlace: object.rating, reviewsCount: object.reviewsCount, backgroundImage: DomainRouter.generalDomain.rawValue + object.imageURL)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 35)
                .onAppear {
                    serviceAPI.fetchDataAboutPlaces(completion: { result in
                        switch result {
                        case .success(let places):
                            self.viewModel.places = places.data
                        case .failure(let error):
                            DispatchQueue.main.async {
                                viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")

                              }
                            //print(error)
                            //print(error.localizedDescription)
                        }
                        
                        //self.state.categories = self.serviceAPI.categories!.data
                    })
                }
            }
        }
    }
}

struct AllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(viewModel: PlacesViewModel())
    }
}
