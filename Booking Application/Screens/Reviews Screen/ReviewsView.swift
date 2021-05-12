//
//  ReviewsView.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

struct ReviewsView: View {
    @ObservedObject var viewModel: ReviewsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    
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
                        Text("Reviews")
                            .font(.system(size: 18, weight: .bold))
                        VStack {
                            Button(action: {
                                self.viewModel.controller?.redirectNewReview(placeIdentifier: viewModel.placeIdentifier)
                            }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 18, alignment: .leading)
                            .padding([.bottom, .top], 13)
                            .padding(.trailing, 19)
                            .foregroundColor(.black)
                            })
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    // MARK: -> Data List View
                    
                    ScrollView(showsIndicators: !viewModel.reviews.isEmpty) {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            viewModel.reviews.removeAll()
                            viewModel.isLoadingPage = false
                            viewModel.canLoadMorePages = true
                            viewModel.currentPage = 1
                            viewModel.loadMoreContent()
                        }
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.reviews, id: \.self) { item in //.sorted { $0.id > $1.id }
                                ReviewItemView(title: item.title, rating: Float(item.rating), description: item.description)
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
                        
                        if !viewModel.isLoadingPage && viewModel.reviews.isEmpty {
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
                .alert(isPresented: $viewModel.showAlertError) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlertError = false }))
                }
            }
        }
    }
}

//struct ReviewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewsView()
//    }
//}

struct ReviewItemView: View {
    let title: String
    let rating: Float
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .font(.title2)
                .bold()
            StarsView(rating: rating)
                .padding([.bottom, .top], 6)
                .fixedSize()
            Text("\(description)")
                .multilineTextAlignment(.leading )
            Divider()
        }
        .padding(.top, 8)
        .padding([.leading, .trailing], 16)
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewItemView(title: "All is just super!", rating: 3.2, description: "My desription is here and its so cool!")
    }
}
