//
//  EnumerationItemsView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Foundation
import SwiftUI

struct EnumerationCategoriesView: View {
    var items: [Category]
    @State var selected = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -8) {
                ForEach(items, id: \.self) { item in
                    ItemCategoryView(category: item, selectedButtonIdentifier: self.$selected)
                }
            }
        }
    }
    
}

struct ItemCategoryView: View {
    var category: Category
    @Binding var selectedButtonIdentifier: Int
    
    var body: some View{
        Button(action: {
            self.selectedButtonIdentifier = self.category.id
        }) {
            Text(category.name)
                .foregroundColor(self.selectedButtonIdentifier == self.category.id ? Color.white : Color(UIColor(hex: "#00000080")!))
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
        }
        .background(self.selectedButtonIdentifier == self.category.id ? Color.blue : Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
        .padding(.leading, 16)
    }
    
}
