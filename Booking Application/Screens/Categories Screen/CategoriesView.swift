//
//  AllCategoriesView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
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
                    Text("Food Category")
                        .font(.system(size: 18, weight: .bold))
                }
                
                // MARK: -> Scroll View For Load Data
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.categories, id: \.self) { object in
                            CategoryView(title: object.name, imageName: DomainRouter.generalDomain.rawValue + object.imageURL, onClick: {
                                // Redirect
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 35)
                }
                .navigationBarHidden(true)
                .alert(isPresented: $viewModel.showAlertError) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlertError = false }))
                }
            }
        }
    }
}

struct AllCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(viewModel: CategoriesViewModel())
    }
}