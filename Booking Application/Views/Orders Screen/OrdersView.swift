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
                    
                    ScrollView(showsIndicators: !viewModel.activeOrders.isEmpty) {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            viewModel.resetActiveOrders()
                            viewModel.loadMoreActiveOrders()
                        }
                        VStack(alignment: .leading) {
                            ForEach(viewModel.activeOrders, id: \.self) { item in //.sorted { $0.id > $1.id }
                                HistoryOrderItemView(order: item, cancel: {
                                    self.viewModel.cancelOrder(orderIdentifier: item.id)
                                }, redirect: {
                                    guard item.place != nil else { return }
                                    viewModel.controller?.redirectPlaceDetails(object: item.place!)
                                })
                                .id(UUID())
                                .onAppear {
                                    viewModel.loadMoreContentIfNeeded(currentItem: item)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 35)
                        
                        // MARK: -> While Data Loading Show Progress View
                        
                        if viewModel.isLoadingPage {
                            ProgressView()
                        }
                        
                        // MARK: -> Empty Data View
                        
                        if !viewModel.isLoadingPage && viewModel.activeOrders.isEmpty {
                            VStack {
                                Image("Empty")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                                    .fixedSize()
                                    .foregroundColor(Color.gray)
                                Text("No Data")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(Color.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding(.top, 96)
                        }
                    }
                    .coordinateSpace(name: "pullToRefresh")
                }
                .navigationBarHidden(true)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
                }
            }
        }
    }
    
}
