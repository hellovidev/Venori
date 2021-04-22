//
//  AllRestarauntsView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct AllRestaurantsView: View {
    @ObservedObject var allRestaurantsViewModel: AllRestaurantViewModel
    var api = ServiceAPI()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
//    var restaurants: [Restaurant] = [Restaurant(title: "Bar Cuba", image: "Background Account", rating: 4.2, votes: 23512), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678), Restaurant(title: "Bar Cuba", image: "Background Account", rating: 4.2, votes: 23512), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678)]
    
    var body: some View {
        CustomNavigationView(title: "Restaraunts", isRoot: false, isSearch: true, isLast: true, color: .white, onBackClick: {
            self.allRestaurantsViewModel.controller?.backToMain()
        }) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(allRestaurantsViewModel.places, id: \.self) { object in
                        RestarauntCardView(title: object.name, rating: object.rating, votes: 4231, backgroundImage: "Background Account", onClick: {
                            self.allRestaurantsViewModel.controller?.redirectToRestarauntDetails(object: object)
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 35)
                .onAppear {
                    if ((api.places?.data?.isEmpty) != nil) {
                        self.api.fetchDataAboutPlaces()
                    }
                }
            }
        }
    }
}

struct AllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRestaurantsView(allRestaurantsViewModel: AllRestaurantViewModel())
    }
}
