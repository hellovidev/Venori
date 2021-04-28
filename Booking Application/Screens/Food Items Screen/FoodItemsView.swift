//
//  FoodItemsView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

struct FoodItemsView: View {
    @ObservedObject var viewModel: FoodItemsViewModel
    @State private var showPopUp: Bool = false
    @State private var errorMessage: String = ""
    private let serviceAPI = ServiceAPI()
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        ZStack {
                            VStack {
                                Button(action: {
                                    self.viewModel.controller?.goBackToPreviousView()
                                }, label: {
                                    Image("Close")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 24, alignment: .leading)
                                        .padding([.bottom, .top], 13)
                                        .padding(.leading, 19)
                                        .foregroundColor(.black)
                                })
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Select food item")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(width: geometry.size.width, height: 48, alignment: .center)
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                EnumerationCategoriesView(items: viewModel.categories)
                                VStack {
                                    ForEach(self.viewModel.categories, id: \.self) { item in
                                        HStack(alignment: .center) {
                                            Text(item.name)
                                                .font(.system(size: 22, weight: .semibold))
                                                .padding(.leading, 16)
                                            Spacer()
                                        }
                                        ForEach(0..<5) {_ in
                                            ProductView(productName: "Americano", productVolume: "300ml", productPrice: "$3.20", productImageURL: "https://t4.ftcdn.net/jpg/01/62/74/67/360_F_162746788_uxm2CkE5xQq2fy7DVJASe40lMcvSQ52A.jpg")
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .padding(.top, 16)
                                .padding(.bottom, 35)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                ErrorPopUpView(title: "Error", message: self.errorMessage, show: $showPopUp)
            }
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutCategories(completion: { result in
                switch result {
                case .success(let categories):
                    self.viewModel.categories = categories.data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    showPopUp.toggle()
                }
            })
        }
    }
}
