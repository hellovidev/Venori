//
//  FoodItemsView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

struct FoodItemsView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        VStack {
                            Button {
                                //self.onBackClick()
                                //self.mode.wrappedValue.dismiss()
                                //self.$active
                            } label: {
                                Image("Close")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 24, alignment: .leading)
                                    .padding([.bottom, .top], 13)
                                    .padding(.leading, 19)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Select food item")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    .frame(width: geometry.size.width, height: 48)
                    
                    VStack {
                        //COntent
                    }

                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FoodItemsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemsView()
    }
}
