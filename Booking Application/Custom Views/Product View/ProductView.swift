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
            VStack(alignment: .leading) {
                HStack {
                Text(productName)
                    .font(.system(size: 20, weight: .regular))
                    Spacer()
                    Text(productPrice)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color.blue)
                }
                Text(productVolume)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(UIColor(hex: "#00000080")!))
            }
            .padding(.leading, 8)
        }
        .padding([.leading, .trailing], 16)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(productName: "Americano", productVolume: "300ml", productPrice: "$3.20", productImageURL: "https://t4.ftcdn.net/jpg/01/62/74/67/360_F_162746788_uxm2CkE5xQq2fy7DVJASe40lMcvSQ52A.jpg")
    }
}
