//
//  FavouriteEmptyView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> If Block Of Favourite Places Is Empty

struct FavouriteEmptyView: View {
    var body: some View {
        ZStack {
            Color(UIColor(hex: "#3A7DFF2E")!)
                .cornerRadius(32)
                .padding(.trailing, 16)
                .padding(.leading, 16)
            VStack {
                Image("Heart")
                    .frame(maxWidth: 44, maxHeight: 44, alignment: .center)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color(UIColor(hex: "#3A7DFF2E")!))
                    .clipShape(Circle())
                    .padding(.top, 23)
                    .padding(.bottom, 8)
                Text("Press heart icon on any restaurant to add into your favorites")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 23)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                    .foregroundColor(Color(UIColor(hex: "#0000004D")!))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 169)
    }
    
}

struct FavouriteEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteEmptyView()
    }
    
}
