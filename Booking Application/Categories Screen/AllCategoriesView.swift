//
//  AllCategoriesView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct AllCategoriesView: View {
    @ObservedObject var allCategoriesViewModel: AllCategoriesViewModel
    
    var categories: [Category] = [Category(title: "Burger", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger"), Category(title: "Pizza", image: "Burger"), Category(title: "Sushi", image: "Burger")]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        CustomNavigationView(title: "Food Category", isRoot: false, isLast: true, color: .white, onBackClick: {
            self.allCategoriesViewModel.controller?.backToMain()
        }) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(categories, id: \.self) { object in
                        CategoryView(title: object.title, imageName: object.image, onClick: {})
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
}

struct AllCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllCategoriesView(allCategoriesViewModel: AllCategoriesViewModel())
    }
}
