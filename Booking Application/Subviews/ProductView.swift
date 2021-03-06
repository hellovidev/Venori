//
//  ProductView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

struct ProductView: View {
    var productName: String
    var productVolume: String
    var productPrice: String
    var productImageURL: String
    
    var body: some View {
        HStack {
            ImageURL(url: productImageURL)
                .scaledToFill()
                .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                .cornerRadius(8)
                .fixedSize()
            VStack(alignment: .leading) {
                HStack {
                    Text(productName)
                        .font(.system(size: 18, weight: .regular))
                    Spacer()
                    Text(productPrice)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.blue)
                }
                .padding(.bottom, -2)
                Text(productVolume)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(UIColor(hex: "#00000080")!))
            }
            .padding(.leading, 6)
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
    }
    
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(productName: "Americano", productVolume: "300ml", productPrice: "$3.20", productImageURL: "https://t4.ftcdn.net/jpg/01/62/74/67/360_F_162746788_uxm2CkE5xQq2fy7DVJASe40lMcvSQ52A.jpg")
    }
}
