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
                .alert(isPresented: $viewModel.showAlertError) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlertError = false }))
                }
            }
        }
        
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: OrdersViewModel())
    }
}
