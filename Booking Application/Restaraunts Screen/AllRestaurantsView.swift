//
//  AllRestarauntsView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct AllRestaurantsView: View {
    @ObservedObject var allRestaurantsViewModel: AllRestaurantViewModel
    //let data = (1...100).map { "Item \($0)" }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var restaurants: [Restaurant] = [Restaurant(title: "Bar Cuba", image: "Background Account", rating: 4.2, votes: 23512), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678), Restaurant(title: "Bar Cuba", image: "Background Account", rating: 4.2, votes: 23512), Restaurant(title: "Hookah Place", image: "Background Account", rating: 3.2, votes: 154), Restaurant(title: "Restaurant Barashka", image: "Background Account", rating: 5, votes: 5678)]
    
    var body: some View {
        CustomNavigationView(title: "Restaraunts", isRoot: false, isSearch: true, isLast: true, color: .yellow, onBackClick: {
            self.allRestaurantsViewModel.controller?.backToMain()
        }) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(restaurants, id: \.self) { object in
                        RestarauntCardView(title: object.title, rating: object.rating, votes: object.votes, backgroundImage: object.image, onClick: {})
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRestaurantsView(allRestaurantsViewModel: AllRestaurantViewModel())
    }
}
