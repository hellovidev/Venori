//
//  AllCategoriesView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct AllCategoriesView: View {
    @ObservedObject var viewModel: AllCategoriesViewModel
    var serviceAPI = ServiceAPI()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationBarView(title: "Food Category", isRoot: false, isSearch: false, isLast: true, color: .white, location: "", onBackClick: {
            self.viewModel.controller?.redirectPrevious()
        }) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.categories, id: \.self) { object in
                        CategoryView(title: object.name, imageName: DomainRouter.generalDomain.rawValue + object.imageURL, onClick: {
                            self.viewModel.controller?.redirectToFoodItems()
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 35)
                .onAppear {
                    serviceAPI.fetchDataAboutCategories(completion: { result in
                        switch result {
                        case .success(let categories):
                            self.viewModel.categories = categories.data
                        case .failure(let error):
                            DispatchQueue.main.async {
                                viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                                
                            }
                        }
                    })
                }
            }
        }
    }
    
}

struct AllCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllCategoriesView(viewModel: AllCategoriesViewModel())
    }
}
