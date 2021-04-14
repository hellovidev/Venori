//
//  AllCategoriesView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct AllCategoriesView: View {

    let data = (1...100).map { "Item \($0)" }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
            .padding(.horizontal)
        }
        //.frame(maxHeight: 300)
    }
    
}

struct AllCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllCategoriesView()
    }
}
