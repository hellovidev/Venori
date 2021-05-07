//
//  PlaceInnerItemView.swift
//  Booking Application
//
//  Created by student on 7.05.21.
//

import SwiftUI

// MARK: -> Inner View In Order View

struct PlaceInnerItemView: View {
    let place: Place
    
    var body: some View {
        HStack(alignment: .top) {
            if !place.imageURL.isEmpty {
                ImageURL(url: DomainRouter.generalDomain.rawValue + place.imageURL)
                    .scaledToFill()
                    .frame(maxWidth: 72, maxHeight: 72, alignment: .center)
                    .cornerRadius(14)
                    .fixedSize()
            }
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, -4)
                    .padding(.top, 2)
                HStack {
                    Image("Star")
                    Text("\((NSString(format: "%.01f", place.rating)))")
                        .font(.system(size: 16, weight: .regular))
                    Text("(\(place.reviewsCount))")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .regular))
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
        .padding([.bottom, .top], 12)
    }
}
