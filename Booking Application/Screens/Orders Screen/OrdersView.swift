//
//  OrdersView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Orders")
                        .padding([.leading, .top], 16)
                        .font(.system(size: 28, weight: .bold))
                    ZStack {
                        ScrollView(showsIndicators: !viewModel.orders.isEmpty) {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.orders.sorted { $0.id > $1.id }, id: \.self) { item in
                                    HistoryOrderItemView(order: item, place: viewModel.place, cancel: {
                                        self.viewModel.cancelOrder(orderIdentifier: item.id)
                                    })
                                    .onAppear {
                                        viewModel.fetchPlaceOfOrder(placeIdentifier: item.placeID)
                                        viewModel.loadMoreContentIfNeeded(currentItem: item)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.top, 16)
                            .padding(.bottom, 35)
                        }
                        
                        // MARK: -> While Data Loading Show Progress View
                        
                        if viewModel.isLoadingPage {
                            ProgressView()
                        }
                    }
                }
                .navigationBarHidden(true)
                
//                VStack(alignment: .center) {
//
//                    // MARK: -> Empty Data View
//
//                    Image("Empty")
//                        .resizable()
//                        .renderingMode(.template)
//                        .isHidden(!self.viewModel.isEmpty, remove: !self.viewModel.isEmpty)
//                        .foregroundColor(Color.gray)
//                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
//                    Text("No Data")
//                        .isHidden(!self.viewModel.isEmpty, remove: !self.viewModel.isEmpty)
//                        .font(.system(size: 24, weight: .semibold))
//                        .foregroundColor(Color.gray)
//
//                    // MARK: -> Error Load Data View
//
//                    Image("Reload")
//                        .resizable()
//                        .renderingMode(.template)
//                        .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
//                        .foregroundColor(Color.gray)
//                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
//                        .padding(.bottom, 12)
//                    Text("Error! Try downloading the data again.")
//                        .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(Color.gray)
//                        .padding(.bottom, 12)
//                    Button(action: {
//                        self.viewModel.isLoadingPage = true
//                        self.viewModel.fetchOrders()
//                    }, label: {
//                        Text("Try again")
//                            .foregroundColor(.white)
//                            .padding([.top, .bottom], 16)
//                            .padding([.leading, .trailing], 32)
//                            .font(.system(size: 16, weight: .semibold))
//                    })
//                    .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
//                    .background(Color(UIColor(hex: "#00000030")!))
//                    .cornerRadius(12)
//                }
            }
        }

    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: OrdersViewModel())
    }
}
