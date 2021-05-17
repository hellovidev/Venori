//
//  BookingHistoryView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookingHistoryView: View {
    @ObservedObject var viewModel: BookingHistoryViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    // MARK: -> Navigation Bar Block
                    
                    ZStack {
                        VStack {
                            Button(action: {
                                self.viewModel.controller?.redirectPrevious()
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
                    
                    // MARK: -> Scroll View For Load Data
                    
                    ZStack {
                        ScrollView(showsIndicators: !viewModel.historyOrders.isEmpty) {
                            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                                viewModel.resetOrdersHistoryData()
                                viewModel.loadMoreHistoryOrders()
                            }
                            VStack {
                                ForEach(viewModel.historyOrders, id: \.self) { item in //.sorted { $0.id > $1.id }
                                    HistoryOrderItemView(order: item, cancel: {}, redirect: {
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
                                    .padding(.top, 15)
                                    .padding(.bottom, 35)
                            }
                            
                            // MARK: -> Empty Data View
                            
                            if !viewModel.isLoadingPage && viewModel.historyOrders.isEmpty {
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
                        }.coordinateSpace(name: "pullToRefresh")
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
            }
        }
    }
    
}
