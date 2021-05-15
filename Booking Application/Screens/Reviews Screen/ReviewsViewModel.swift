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
    private let serviceAPI = ServerRequest()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var reviews = [Review]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    
    let placeIdentifier: Int
    
    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -> Load Content By Pages
    
    func loadMoreContentIfNeeded(currentItem item: Review?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -5)
        if reviews.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func loadMoreContent() {
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
        
//        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
//
//            // Check Presence of Errors
//
//            guard error == nil else {
//                return
//            }
//
//            // Data Validation
//
//            guard let data = data else {
//                return
//            }
//
//            if let response = response as? HTTPURLResponse {
//                switch response.statusCode {
//                case 200:
//                    NSLog(NSLocalizedString("Status Code is 200... Request for user location.", comment: "Success"))
//                case 401:
//                    print("User is not authenticated!")
//                case 422:
//                    print("The given data was invalid.")
//                default:
//                    print("Unknown status code error!")
//                }
//            } else {
//                return
//            }
//
//            do {
//
//                // Decodable JSON Data
//
//                guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
//                print(response)
//
//                let response1 = try JSONDecoder().decode(Reviews.self, from: data)
//
//                DispatchQueue.main.async {
//                    print("success")
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        })
//        .resume()
        
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
                print(response.data)
                self.reviews.append(contentsOf: response.data)
                return self.reviews
            })
            .catch({ _ in Just(self.reviews) })
            .assign(to: &$reviews)
    }
}
