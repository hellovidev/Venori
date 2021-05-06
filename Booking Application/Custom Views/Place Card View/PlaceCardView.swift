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
    
    // Function Click On Card
    
    @State private var onCardClick: () -> Void
    
    // Function Click On Favorite Icon
    
    @State private var onFavouriteClick: () -> Void
    
    // Information Data About Place
    
//    var namePlace: String
//    var ratingPlace: Float
//    var reviewsCount: Int
//    var backgroundImage: String
//    @State private var isFavourite: Bool = false
    
    init(place: Place, onCardClick: @escaping () -> Void, onFavouriteClick: @escaping () -> Void) {
        self._place = State(initialValue: place)
        self._onCardClick = State(initialValue: onCardClick)
        self._onFavouriteClick = State(initialValue: onFavouriteClick)
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    ImageURL(url: DomainRouter.generalDomain.rawValue + place.imageURL)
                        .frame(maxWidth: 256, maxHeight: 169)
                        .cornerRadius(16)
                        .scaledToFit()
                    VStack {
                        Button {
                            //self.isFavourite.toggle()
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

//struct RestarauntCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceCardView(onClick: {}, loveClick: {}, namePlace: "McDonalds", ratingPlace: 3.2, reviewsCount: 777, backgroundImage: "https://cdn.vox-cdn.com/thumbor/6hGqu4TDUrZO0tJoCyVC1W5_Mk0=/0x0:8002x5335/1200x800/filters:focal(3361x2028:4641x3308)/cdn.vox-cdn.com/uploads/chorus_image/image/67760561/shutterstock_1778181218.0.jpg")
//    }
//}
