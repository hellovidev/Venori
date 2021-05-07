//
//  PlaceCardView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> Restaraunt Card View

struct PlaceCardView: View {
    @State private var place: Place
    @State private var onCardClick: () -> Void
    @State private var onFavouriteClick: () -> Void
    @State private var isProcessDelete: Bool
    //@State private var previousState = false
    
    init(place: Place, onCardClick: @escaping () -> Void, onFavouriteClick: @escaping () -> Void, isProcessDelete: Bool) {
        self._place = State(initialValue: place)
        self._onCardClick = State(initialValue: onCardClick)
        self._onFavouriteClick = State(initialValue: onFavouriteClick)
        self._isProcessDelete = State(initialValue: isProcessDelete)
        
        //self._previousState = State(initialValue: self.place.favourite ?? false)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ZStack {
                    ImageURL(url: DomainRouter.generalDomain.rawValue + place.imageURL)
                        .frame(maxWidth: 256, maxHeight: 169)
                        .cornerRadius(16)
                        .scaledToFit()
                    VStack {
                        Button {
//                            if previousState != place.favourite {
//                                self.isProcessDelete = true
//                            } else {
//                                self.isProcessDelete = false
//                            }
                            self.onFavouriteClick()
                        } label: {
                            Image("Heart")
                                .resizable()
                                .renderingMode(.template)
                                .frame(maxWidth: 22, maxHeight: 22, alignment: .center)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(place.favourite ?? false ? Color.blue : Color(UIColor(hex: "#0000007A")!))
                                .clipShape(Circle())
                                .padding(.trailing, 8)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: 296, maxHeight: 169, alignment: .trailing)
                    if isProcessDelete {
                        ZStack {
                            RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#00000066")!), Color(UIColor(hex: "#00000000")!)]), center: UnitPoint(x: 0.5, y: 0.5), startRadius: 0, endRadius: 32)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                Text(place.name)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 10)
                    .padding(.bottom, -4)
                    .foregroundColor(.black)
                    .lineLimit(1)
                HStack {
                    Image("Star")
                    Text("\(NSString(format: "%.01f", place.rating))")
                        .foregroundColor(.black)
                    Text("(\(String(place.reviewsCount)))")
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                self.onCardClick()
            }
        }
    }
}
