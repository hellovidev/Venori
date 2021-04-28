//
//  BookingHistoryView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookingHistoryView: View {
    @ObservedObject var viewModel: BookingHistoryViewModel

    private let serviceAPI = ServiceAPI()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...10, id: \.self) {
                    Text("\($0)")
                    HistoryItemView(isStatus: false, isActive: false)
                }
            }
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutBookingHistory(completion: { result in
                switch result {
                case .success(let orders):
                    print(orders)
                    //self.viewModel.categories = categories.data
                case .failure(let error):
                    print(error)
                    //self.errorMessage = error.localizedDescription
                    //showPopUp.toggle()
                }
            })
        }
    }
}

struct HistoryItemView: View {
    let isStatus: Bool
    let isActive: Bool
    
    init(isStatus: Bool, isActive: Bool) {
        self.isStatus = isStatus
        self.isActive = isActive
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ID2301023")
                    .font(.system(size: 20, weight: .bold))
                ZStack {
                    
                    Text("In progress")
                        .foregroundColor(.blue)
                        .font(.system(size: 12, weight: .regular))
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 6)
                        .background(
                            Color(UIColor(hex: "#3A7DFF2E")!)
                                        .cornerRadius(14)
                                )
                }
                Spacer()
                Text("$140.00")
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Image("Date Booking")
                    .padding(.trailing, 12)
                Text("August 12, 2020")
                    .font(.system(size: 14, weight: .regular))
            }
            HStack {
                Image("Persons")
                    .padding(.trailing, 12)
                Text("4 Persons")
                    .font(.system(size: 14, weight: .regular))
            }
            HStack(alignment: .top) {
                Image("Background Account")
                    .resizable()
                    .frame(maxWidth: 72, maxHeight: 72, alignment: .center)
                    .cornerRadius(14)
                    .scaledToFill()
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.bottom, -8)
                    HStack {
                        Image("Star")
                        Text("4.6")
                            .font(.system(size: 16, weight: .regular))
                        Text("(123123)")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .regular))
                    }
                }
            }
            VStack(alignment: .center) {
                Button(action: {
                    //acftion
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                }
                .background(Color("Button Color"))
                .cornerRadius(24)
                .padding(.leading, 75)
                .padding(.trailing, 75)
                .padding([.bottom, .top], 12)
            }
            Divider()
                .padding(.bottom, 12)
        }
        .padding([.leading, .trailing], 16)
    }
}

struct BookingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookingHistoryView(viewModel: BookingHistoryViewModel())
    }
}
