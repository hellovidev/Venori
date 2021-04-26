//
//  AllRestarauntsView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct PlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    
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
                        }, namePlace: object.name, ratingPlace: object.rating, reviewsCount: 777, backgroundImage: DomainRouter.generalDomain.rawValue + object.imageURL)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 35)
            }
        }
    }
}

struct AllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(viewModel: PlacesViewModel())
    }
}
