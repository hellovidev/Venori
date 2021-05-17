//
//  AllCategoriesViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Combine
import Foundation

class CategoriesViewModel: ObservableObject {
    weak var controller: CategoriesViewController?
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var categories = [Category]()
    @Published var isLoadingPage = false
    
    // Alert Data
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    init() {
        self.loadMoreCategories()
    }
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Category?) {
        guard let item = item else {
            loadMoreCategories()
            return
        }
        
        let thresholdIndex = categories.index(categories.endIndex, offsetBy: -5)
        if categories.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreCategories()
        }
    }
    
    func loadMoreCategories() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.categoriesRoute.rawValue)!
        
        url.queryItems = [
            URLQueryItem(name: "page", value: "\(self.currentPage)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Categories.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                //print(response.data)
                self.categories.append(contentsOf: response.data)
                return self.categories
            })
            .catch({ _ in Just(self.categories) })
            .assign(to: &$categories)
    }
    
    func resetCategoriesData() {
        currentPage = 1
        isLoadingPage = false
        categories.removeAll()
        canLoadMorePages = true
    }
    
}
