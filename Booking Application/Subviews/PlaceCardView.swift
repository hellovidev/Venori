//
//  PlaceCardView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> Restaraunt Card View

struct PlaceCardView: View {
    let place: Place
    let onCardClick: () -> Void
    let onFavouriteClick: (@escaping () -> Void) -> Void
    @State private var isProcess: Bool = false
    
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
                            isProcess = true
                            self.onFavouriteClick({ 
                                self.isProcess = false
                            })
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
                    if isProcess {
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
