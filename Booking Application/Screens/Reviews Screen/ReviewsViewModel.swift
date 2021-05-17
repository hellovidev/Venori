//
//  ReviewsViewModel.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import Combine
import SwiftUI

class ReviewsViewModel: ObservableObject {
    weak var controller: ReviewsViewController?
    private let serverRequest = ServerRequest()
    private var cancellable: Cancellable?
    private var canLoadMorePages = true
    private var currentPage = 1
    
    @Published var reviews = [Review]()
    @Published var isLoadingPage = false
    @Published var isLoading = false
    
    // Identity Data
    
    var user: User?
    let placeIdentifier: Int
    
    // Alert Data
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    deinit {
        cancellable?.cancel()
    }
    
    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
        
        self.loadMoreReviews()
        
        // Register to receive notification in your class
        
        cancellable = NotificationCenter.default
            .publisher(for: .newReviewNotification)
            .sink() { [weak self] _ in
                
                // Handle notification
                
                self?.resetReviewsData()
                self?.loadMoreReviews()
            }
        
        if let data = UserDefaults.standard.data(forKey: "current_user") {
            do {
                
                // Decode User
                
                self.user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Unable to Decode User (\(error))")
            }
        }
    }
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Review?) {
        guard let item = item else {
            loadMoreReviews()
            return
        }
        
        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -5)
        if reviews.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreReviews()
        }
    }
    
    func loadMoreReviews() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(self.placeIdentifier)/" + DomainRouter.reviewsRoute.rawValue)!
        
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
            .decode(type: Reviews.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                //print(response.data)
                self.reviews.append(contentsOf: response.data)
                return self.reviews
            })
            .catch({ _ in Just(self.reviews) })
            .assign(to: &$reviews)
    }
    
    func deleteReview(id: Int) {
        self.isLoading = true
        self.serverRequest.deleteReview(completion: { response in
            switch response {
            case .success(let message):
                self.isLoading = false
                print("Deleted review success: \(message)")
                
                // Post notification about list of reviews changed
                
                NotificationCenter.default.post(name: .newReviewNotification, object: nil)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Deleted review faild: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.showAlertError = true
                }
            }
        }, reviewIdentifier: id)
    }
    
    func resetReviewsData() {
        currentPage = 1
        reviews.removeAll()
        isLoadingPage = false
        canLoadMorePages = true
    }
    
}
