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
    private var cancellables = Set<AnyCancellable>()
    private let placeIdentifier: Int
    private var user: User?
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    @Published var titleText: String = ""
    //@Published var isEmptyTitle: Bool = true
    
    @Published var descriptionText: String = ""
    //@Published var isEmptyDescription: Bool = true

    @Published var rating: Int? = 0
    //@Published var isEmptyRating: Bool = true
    
    @Published var isValid: Bool = false

    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
        
        // Get Data About User
        
        if let data = UserDefaults.standard.data(forKey: "current_user") {
            do {
                
                // Decode User
                
                self.user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Unable to Decode User (\(error))")
            }
        }
        
        isFormFieldCompletePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
        
        
//        $titleText
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { input in
//                return input.count >= 1
//            }
//            .assign(to: \.isEmptyTitle, on: self)
//            .store(in: &cancellables)
//
//        $descriptionText
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { input in
//                return input.count >= 1
//            }
//            .assign(to: \.isEmptyDescription, on: self)
//            .store(in: &cancellables)
//
//        $rating
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { input in
//                return input ?? 0 >= 1
//            }
//            .assign(to: \.isEmptyRating, on: self)
//            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func publishNewReview(title: String, rating: Int, description: String) {
        let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.reviewsRoute.rawValue)!
        
        // Request Body Generating
        
        let data: [String: Any] = ["title": title, "rating": rating, "description": description, "user_id": user?.id as Any, "place_id": placeIdentifier]
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                
                // Not worried about the status code just trying to get any response
                
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode >= 200
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success published new review.")
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Error: \(error.localizedDescription)")
                }
            },
            receiveValue: { data in
                guard let response = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                print("Server response: \(response)")
                self.controller?.redirectPrevious()
            })
            .store(in: &cancellables)
    }
    
    private var isTitleEmptyPublisher: AnyPublisher<Bool, Never> {
        $titleText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { title in
                return title == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isDescriptionEmptyPublisher: AnyPublisher<Bool, Never> {
        $descriptionText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { description in
                return description == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isRatingEmptyPublisher: AnyPublisher<Bool, Never> {
        $rating
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { rating in
                return rating == 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormFieldCompletePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isTitleEmptyPublisher, isDescriptionEmptyPublisher, isRatingEmptyPublisher)
            .map { titleIsEmpty, descriptionIsEmpty, ratingIsEmpty in
                return !titleIsEmpty && !descriptionIsEmpty && !ratingIsEmpty
//                if titleIsEmpty && descriptionIsEmpty && ratingIsEmpty{
//                    return false
//                } else if titleIsEmpty {
//                    return .emptyTitle
//                } else if descriptionIsEmpty {
//                    return .emptyDescription
//                } else if ratingIsEmpty {
//                    return .emptyRating
//                }
//                else {
//                    return .valid
//                }
            }
            .eraseToAnyPublisher()
    }
    
//    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
//        Publishers.CombineLatest(isFormFieldCompletePublisher, <#_#>)
//            .map { isComplete in
//                return isComplete
//            }
//            .eraseToAnyPublisher()
//    }
    
}

enum FormFieldCheck {
    case valid
    case emptyRating
    case emptyTitle
    case emptyDescription
    case emptyFields
}
