//
//  DetailsRestarauntView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct DetailsRestarauntView: View {
    @ObservedObject var detailsRestarauntViewModel: DetailsRestarauntViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                Image("Background Account")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 256, alignment: .center)
                    .overlay(
                        HStack(alignment: .center) {
                            Button {
                                self.detailsRestarauntViewModel.controller?.goBack()
                            } label: {
                            Image("Arrow Left White")
                                .padding([.top, .bottom], 12)
                                .padding(.leading, 16)
                            }
                            Spacer()
                            Button {
                                // Act fav
                            } label: {
                            Image("Heart")
                                .padding([.top, .bottom], 12)
                                .padding(.trailing, 16)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 48)
                    )
//                VStack(alignment: .center) {
//
//                }
            }
            
            VStack(alignment: .leading) {
                Text(detailsRestarauntViewModel.place!.name)
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 22)
                    .padding(.bottom, 2)
                Text("Coffee")
                    .foregroundColor(Color(UIColor(hex: "#00000080")!))
                    .font(.system(size: 12, weight: .regular))
                    .padding(.bottom, 8)
                
                HStack {
                    Image("Star Yellow")
                    Image("Star Yellow")
                    Image("Star Yellow")
                    Image("Star Yellow")
                    Image("Star Gray")
                    Text("\(NSString(format: "%.01f", detailsRestarauntViewModel.place!.rating))")
                        .font(.system(size: 18, weight: .semibold))
                    Text("456 Reviews")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                }
                .padding(.bottom, 24)
                
                HStack(alignment: .top) {
                    HStack(alignment: .top){
                        Image("Map Pin")
                            .padding(.trailing, 8)
                            .padding(.top, 18)
                        VStack(alignment: .leading) {
                            Text(detailsRestarauntViewModel.place!.addressFull)
                                .font(.system(size: 18, weight: .regular))
                                .padding(.bottom, 2)
                            Button {
                                // Action
                            } label: {
                                Text("View map")
                                    .font(.system(size: 12, weight: .regular))
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                    Spacer()
                    Image("Background Account")
                        .resizable()
                        .frame(maxWidth: 88, maxHeight: 88, alignment: .center)
                        .scaledToFill()
                        .cornerRadius(16)
                }
                .padding(.bottom, 20)
                
                HStack {
                    Image("Phone")
                        .padding(.trailing, 8)
                    Text(detailsRestarauntViewModel.place!.phone)
                        .font(.system(size: 18, weight: .regular))
                }
                .padding(.bottom, 22)
                
                HStack(alignment: .top) {
                    Image("Time")
                        .padding(.trailing, 8)
                    VStack(alignment: .leading) {
                        Text("Avaliable until 12:00 PM")
                            .font(.system(size: 18, weight: .regular))
                            .padding(.bottom, 2)
                        Button {
                            
                        } label: {
                            Text("View schadle")
                                .font(.system(size: 12, weight: .regular))
                        }
                    }
                }
                .padding(.bottom, 24)
                
                HStack(alignment: .top) {
                    Image("Info")
                        .padding(.trailing, 8)
                    Text(detailsRestarauntViewModel.place!.description)
                        .font(.system(size: 18, weight: .regular))
                }
            }
            .padding([.leading, .trailing], 16)
            
            Spacer()
            
            Button(action: {
                self.detailsRestarauntViewModel.controller?.redirectToBooking()
            }) {
                Text("Book a table")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.top, 13)
                    .padding(.bottom, 13)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity)
                    .shadow(radius: 10)
            }
            .modifier(ButtonModifier())
            .padding(.bottom, 35)
        }.ignoresSafeArea(.container, edges: .top)
    }
}

struct DetailsRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsRestarauntView(detailsRestarauntViewModel: DetailsRestarauntViewModel())
    }
}
