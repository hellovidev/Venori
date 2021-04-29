//
//  OrdersView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    private let serviceAPI = ServiceAPI()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Orders")
                    .padding([.leading, .top], 16)
                    .font(.system(size: 28, weight: .bold))
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.orders, id: \.self) { item in
                            HistoryOrderItemView(isActiveOrder: true, orderID: item.id, orderPrice: item.price, orderPeople: item.people, orderDate: item.createdAt)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    .padding(.bottom, 35)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutBookingHistory(completion: { result in
                switch result {
                case .success(let orders):
                    viewModel.orders = orders.data
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: OrdersViewModel())
    }
}
