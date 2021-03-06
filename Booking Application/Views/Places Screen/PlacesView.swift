//
//  AllRestarauntsView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct PlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var editing: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                // MARK: -> Navigation Bar Block
                
                HStack {
                    SearchBarView(text: $text, isEditing: $editing)
                        .isHidden(!editing, remove: !editing)
                        .padding(.top, 12)
                        .padding(.bottom, 10)
                        .padding([.trailing,.leading], 8)
                    Button (action: {
                        viewModel.controller?.redirectPrevious()
                    }, label: {
                        Image("Arrow Left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 24, alignment: .center)
                            .padding([.bottom, .top], 13)
                            .padding(.leading, 19)
                            .foregroundColor(.black)
                    })
                    .isHidden(editing, remove: editing)
                    Spacer()
                        .isHidden(editing, remove: editing)
                    Text("Restaraunts")
                        .font(.system(size: 18, weight: .bold))
                        .isHidden(editing, remove: editing)
                    Spacer()
                        .isHidden(editing, remove: editing)
                    Button (action: {
                        editing.toggle()
                    }, label: {
                        Image("Search")
                            .resizable()
                            .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                    })
                    .isHidden(editing, remove: editing)
                    .padding(.top, 12)
                    .padding(.trailing, 16)
                    .padding(.bottom, 12)
                }
                
                // MARK: -> Grid On Scroll View For Load Data
                
                ScrollView(showsIndicators: !viewModel.places.isEmpty) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        // Search Meethod Here
                        
                        ForEach(viewModel.places.filter({ text.isEmpty ? true : $0.name.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) }), id: \.self) { item in
                            PlaceCardView(place: item, onCardClick: {
                                viewModel.controller?.redirectPlaceDetails(object: item)
                            }, onFavouriteClick: { _ in 
                                guard item.favourite != nil else { return }
                                if item.favourite! {
                                    viewModel.deleteFavouriteState(favourite: item)
                                } else {
                                    viewModel.setFavouriteState(favourite: item)
                                }
                            })
                            .id(UUID())
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentItem: item)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 35)
                    
                    // MARK: -> While Data Loading Show Progress View
                    
                    if viewModel.isLoadingPage {
                        ProgressView()
                    }
                    
                    // MARK: -> Empty Data View
                    
                    if !viewModel.isLoadingPage && viewModel.places.isEmpty {
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
            }
        }
    }
    
}
