//
//  OrdersView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    @State private var isEmpty: Bool = true
    private let serviceAPI = ServiceAPI()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Orders")
                        .padding([.leading, .top], 16)
                        .font(.system(size: 28, weight: .bold))
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.orders.sorted { $0.id > $1.id }, id: \.self) { item in
                                HistoryOrderItemView(isActiveOrder: true, orderID: item.id, orderPrice: item.price, orderPeople: item.people, orderDate: item.createdAt, orderStatus: item.status)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 35)
                    }
                }
                .navigationBarHidden(true)
                
                VStack(alignment: .center) {
                    Image("Empty")
                        .resizable()
                        .renderingMode(.template)
                        .isHidden(!isEmpty, remove: !isEmpty)
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                    Text("You have no orders in progress.")
                        .isHidden(!isEmpty, remove: !isEmpty)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                }
            }
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutOrders(completion: { result in
                switch result {
                case .success(let orders):
                    viewModel.orders = orders.data
                    if viewModel.orders.isEmpty {
                        self.isEmpty = true
                    } else {
                        self.isEmpty = false
                    }
                case .failure(let error):
                    self.isEmpty = true
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
