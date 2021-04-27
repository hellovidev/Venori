//
//  CategoryView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> Category View

struct CategoryView: View {
    var title: String
    var imageName: String
    var onClick: () -> Void
    
    var body: some View {
        Button (action: {
            self.onClick()
        }, label: {
            VStack {
                ImageURL(url: imageName)
                    .frame(maxWidth: 44, maxHeight: 44, alignment: .center)
                    .foregroundColor(.white)
                    .padding(32)
                    .background(Color(UIColor(hex: "#3A7DFF2E")!))
                    .clipShape(Circle())
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
            }
        })
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(title: "Pizza", imageName: "https://cdn.icon-icons.com/icons2/1954/PNG/512/burger_122704.png", onClick: {})
    }
}
