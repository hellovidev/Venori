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
        NavigationView {
                GeometryReader { geometry in
                    VStack {
                        ZStack {
                            VStack {
                                Button(action: {
                                    self.viewModel.controller?.goBackToPreviousView()
                                }, label: {
                                    Image("Arrow Left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 24, alignment: .leading)
                                        .padding([.bottom, .top], 13)
                                        .padding(.leading, 19)
                                        .foregroundColor(.black)
                                })
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Booking history")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(width: geometry.size.width, height: 48, alignment: .center)
                        ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(viewModel.orders, id: \.self) { item in
                                HistoryOrderItemView(isHistory: true, orderID: item.id, orderPrice: item.price, orderPeople: item.people, orderDate: item.createdAt)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 35)
                        }
                    }
                }
                .navigationBarHidden(true)
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutBookingHistory(completion: { result in
                switch result {
                case .success(let orders):
                    print(orders)
                    viewModel.orders = orders.data
                case .failure(let error):
                    print(error)
                    //self.errorMessage = error.localizedDescription
                    //showPopUp.toggle()
                }
            })
        }
    }
}

struct HistoryOrderItemView: View {
    
    // Statuses Of View
    
    let isHistory: Bool
    let isStatusShow: Bool
    let isActiveOrder: Bool
    
    // Order Data
    
    let orderID: Int
    let orderPrice: String
    let orderPeople: Int
    let orderDate: String
    
    init(isActiveOrder: Bool, orderID: Int, orderPrice: String, orderPeople: Int, orderDate: String) {
        self.isHistory = false
        self.isStatusShow = true
        self.isActiveOrder = isActiveOrder
        self.orderID = orderID
        self.orderPrice = orderPrice
        self.orderPeople = orderPeople
        self.orderDate = orderDate
    }
    
    init(isHistory: Bool, orderID: Int, orderPrice: String, orderPeople: Int, orderDate: String) {
        self.isHistory = isHistory
        self.isStatusShow = false
        self.isActiveOrder = false
        self.orderID = orderID
        self.orderPrice = orderPrice
        self.orderPeople = orderPeople
        self.orderDate = orderDate
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ID\(orderID)")
                    .font(.system(size: 20, weight: .bold))
                if isStatusShow {
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
                }
                Spacer()
                Text("$\(orderPrice)")
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Image("Date Booking")
                    .padding(.trailing, 12)
                Text("\(Date().convertServerOrderDate(date: orderDate))")
                    .font(.system(size: 14, weight: .regular))
            }
            HStack {
                Image("Persons")
                    .padding(.trailing, 12)
                Text("\(orderPeople) Person\(orderPeople == 1 ? "" : "s")")
                    .font(.system(size: 14, weight: .regular))
            }
            
            PlaceInnerItemView(imageURL: "https://burgerking.ru/images/og-default.png", title: "Burger King", rating: 3.7, reviews: 356)
            
            if isActiveOrder {
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

struct PlaceInnerItemView: View {
    let imageURL: String
    let title: String
    let rating: Float
    let reviews: Int
    
    var body: some View {
        HStack(alignment: .top) {
            ImageURL(url: imageURL)
                .scaledToFill()
                .frame(maxWidth: 72, maxHeight: 72, alignment: .center)
                .cornerRadius(14)
                .fixedSize()
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, -4)
                    .padding(.top, 2)
                HStack {
                    Image("Star")
                    Text("\((NSString(format: "%.01f", rating)))")
                        .font(.system(size: 16, weight: .regular))
                    Text("(\(reviews))")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .regular))
                }
            }
            .padding(.leading, 8)
        }
    }
}

struct PlaceInnerItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInnerItemView(imageURL: "https://burgerking.ru/images/og-default.png", title: "Burger King", rating: 3.7, reviews: 356)
    }
}
