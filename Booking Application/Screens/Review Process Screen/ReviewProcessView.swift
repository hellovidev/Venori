//
//  ReviewProcessView.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

struct ReviewProcessView: View {
    @ObservedObject var viewModel: ReviewProcessViewModel

    @State private var titleText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
        VStack(alignment: .center) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Button ( action:{
                        viewModel.controller?.redirectPrevious()
                    }, label: {
                        Image("Close")
                            .padding([.top, .bottom, .trailing], 22)
                            .padding(.leading, 16)
                    })
                    Text("New review")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.leading, 16)
                        .padding(.bottom, 22)
                    
                    TextFieldView(data: $titleText, placeholder: "Title", isPassword: false)
                    TextFieldView(data: $titleText, placeholder: "Description", isPassword: false)
                    Text("Rating")
                    Spacer()
                    Button(action: {
//                        if let selectedTime = times.first(where: { $0.id == self.selectedReservationTime }) {
//                            serviceAPI.reserveTablePlace(placeIdentifier: placeID, adultsAmount: Int(valueHumans), duration: valueHours, date: Date().getDateCorrectFormat(date: dateReservation), time: selectedTime.time)
//                            self.actionContinue()
//                        }
                        
                        viewModel.publishNewReview(newReview: Review(id: 0, title: "So cool!", rating: 4, description: "Good place!", like: 0, placeId: 0, userId: 0, createdAt: "", updatedAt: ""))
                    }) {
                        Text("Publish")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.top, 13)
                            .padding(.bottom, 13)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .frame(maxWidth: .infinity)
                            .shadow(radius: 10)
                            //.background(isField == false ? Color.gray : Color("Button Color"))
                    }
                    //.disabled(isField == false)
                    .modifier(ButtonModifier())
                    .padding(.bottom, 35)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height, alignment: .center)
                .background(Color.red)
            }
            }.background(Color.gray)
        }
        
    }
}

//struct ReviewProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewProcessView()
//    }
//}
