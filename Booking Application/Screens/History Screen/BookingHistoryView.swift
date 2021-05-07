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
                            ScrollView(showsIndicators: !viewModel.orders.isEmpty) {
                                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                                    viewModel.orders.removeAll()
                                    viewModel.isLoadingPage = false
                                    viewModel.canLoadMorePages = true
                                    viewModel.currentPage = 1
                                    viewModel.loadMoreContent()
                                }
                                VStack {
                                    ForEach(viewModel.orders.sorted { $0.id > $1.id }, id: \.self) { item in
                                        HistoryOrderItemView(order: item, cancel: {})
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
                                
                            }.coordinateSpace(name: "pullToRefresh")
                            
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
                }
            .navigationBarHidden(true)
        }
    }
}

struct BookingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookingHistoryView(viewModel: BookingHistoryViewModel())
    }
}
