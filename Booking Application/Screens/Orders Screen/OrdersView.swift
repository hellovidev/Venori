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
                    
                    // MARK: -> Navigation Bar View
                    
                    Text("Orders")
                        .padding([.leading, .top], 16)
                        .font(.system(size: 28, weight: .bold))
                    
                    // MARK: -> Data List View
                    
                    ZStack {
                        ScrollView(showsIndicators: !viewModel.orders.isEmpty) {
                            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                                viewModel.orders.removeAll()
                                viewModel.isLoadingPage = false
                                viewModel.canLoadMorePages = true
                                viewModel.currentPage = 1
                                viewModel.loadMoreContent()
                            }
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.orders.sorted { $0.id > $1.id }, id: \.self) { item in
                                    HistoryOrderItemView(order: item, cancel: {
                                        self.viewModel.cancelOrder(orderIdentifier: item.id)
                                    })
                                    .onAppear {
                                        viewModel.loadMoreContentIfNeeded(currentItem: item)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.top, 16)
                            .padding(.bottom, 35)
                            
                        }.coordinateSpace(name: "pullToRefresh")
                        
                        // MARK: -> While Data Loading Show Progress View
                        
                        if viewModel.isLoadingPage {
                            ProgressView()
                        }
                        
                        // MARK: -> Empty Data View
                        
                        if !viewModel.isLoadingPage && viewModel.orders.isEmpty {
                            VStack {
                                Image("Empty")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                                Text("No Data")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(Color.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding(.top, 128)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
        
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: OrdersViewModel())
    }
}




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



