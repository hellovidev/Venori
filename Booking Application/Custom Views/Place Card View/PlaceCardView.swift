//
//  PlaceCardView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> Restaraunt Card View

struct PlaceCardView: View {
    
    // Function Click On Card
    
    var onClick: () -> Void
    
    // Function Click On Favorite Icon
    
    var loveClick: () -> Void
    
    // Information Data About Place
    
    var namePlace: String
    var ratingPlace: Float
    var reviewsCount: Int
    var backgroundImage: String
    @State private var isFavourite: Bool = false
    
    var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    ImageURL(url: backgroundImage)
                        .frame(maxWidth: 296, maxHeight: 169)
                        .cornerRadius(32)
                        .scaledToFit()
                    VStack {
                        Button {
                            self.isFavourite.toggle()
                            self.loveClick()
                        } label: {
                        Image("Heart")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isFavourite ? Color.red : Color.white)
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(UIColor(hex: "#0000007A")!))
                            .clipShape(Circle())
                            .padding(.trailing, 9)
                            .padding(.top, 9)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: 296, maxHeight: 169, alignment: .trailing)
                }
                Text(namePlace)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 10)
                    .padding(.bottom, -4)
                    .foregroundColor(.black)
                    .lineLimit(1)
                HStack {
                    Image("Star")
                    Text("\(NSString(format: "%.01f", self.ratingPlace))")
                        .foregroundColor(.black)
                    Text("(\(String(self.reviewsCount)))")
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                self.onClick()
            }
    }
}

struct RestarauntCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCardView(onClick: {}, loveClick: {}, namePlace: "McDonalds", ratingPlace: 3.2, reviewsCount: 777, backgroundImage: "https://cdn.vox-cdn.com/thumbor/6hGqu4TDUrZO0tJoCyVC1W5_Mk0=/0x0:8002x5335/1200x800/filters:focal(3361x2028:4641x3308)/cdn.vox-cdn.com/uploads/chorus_image/image/67760561/shutterstock_1778181218.0.jpg")
    }
}
