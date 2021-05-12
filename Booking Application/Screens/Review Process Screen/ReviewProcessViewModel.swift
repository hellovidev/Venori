//
//  ReviewProcessViewModel.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import Combine
import SwiftUI

class ReviewProcessViewModel: ObservableObject {
    weak var controller: ReviewProcessViewController?
    var cancellable: AnyCancellable?
    private let placeIdentifier: Int
    
    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
        
        // Read/Get Data
        
        if let data = UserDefaults.standard.data(forKey: "current_user") {
            do {
                
                // Create JSON Decoder
                
                let decoder = JSONDecoder()
                
                // Decode User
                
                self.user = try decoder.decode(User.self, from: data)
            } catch {
                print("Unable to Decode User (\(error))")
            }
        }
    }
    
    @Published var user: User?
    
    func publishNewReview(newReview: Review) {
        let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.reviewsRoute.rawValue)!
        
        // Request Body Generating
        
        let data: [String: Any] = ["title": newReview.title, "rating": newReview.rating, "description": newReview.description, "user_id": user?.id as Any, "place_id": self.placeIdentifier]
        let body = try? JSONSerialization.data(withJSONObject: data)
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .decode(type: Review.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { response in
                print(response)
            })
        
        //cancellable?.cancel()

        //        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
        //            .map(\.data)
        //            .decode(type: Reviews.self, decoder: JSONDecoder())
        //            .receive(on: DispatchQueue.main)
        //            .sink(receiveCompletion: { error in
        //                print(error)
        //            }, receiveValue: { response in
        //                print(response)
        //            })
            
//            .handleEvents(receiveOutput: { response in
//                self.canLoadMorePages = (response.lastPage != response.currentPage)
//                self.isLoadingPage = false
//                self.currentPage += 1
//            })
//            .map({ response in
//                print(response.data)
//                self.reviews.append(contentsOf: response.data)
//                return self.reviews
//            })
//            .catch({ _ in Just(self.reviews) })
//            .assign(to: &$reviews)
    }
    
}
