//
//  BookingHistoryViewModel.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import Combine
import SwiftUI

class BookingHistoryViewModel: ObservableObject {
    weak var controller: BookingHistoryViewController?
    
    private var cancellables = Set<AnyCancellable>()
    private var serviceAPI = ServiceAPI()
    var canLoadMorePages = true
    var currentPage = 1
    
    @Published var ordersObjects = [Order: Place]()
    
    @Published var orders = [Order]()
    @Published var isLoadingPage = false
    @Published var isProcessDelete = false
    
    private var cancellable: AnyCancellable?
    
    // MARK: -> Load Content By Pages
    
//    init() {
//        loadMoreContent()
//        //loadHistory()
//    }
    
    func loadMoreContentIfNeeded(currentItem item: Order?) {
        guard let item = item else {
            loadMoreContent()
            return
        }

        let thresholdIndex = orders.index(orders.endIndex, offsetBy: -5)
        if orders.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue)!

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
            .decode(type: Orders.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = (response.lastPage != response.currentPage)
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                print(response.data)
                self.orders.append(contentsOf: response.data)

//                for item in self.orders {
//                    self.fetchPlaceOfOrder(placeIdentifier: item.placeID, order: item)
//                }


                return self.orders
            })
            .catch({ _ in Just(self.orders) })
            .assign(to: &$orders)
    }
    
    //Template
//    @Published var place = Place()
//    
//    func fetchPlaceOfOrder(placeIdentifier: Int) {
//        self.serviceAPI.getPlaceByIdentifier(completion: { response in
//            switch response {
//            case .success(let place):
//                self.place = place
//                //self.ordersObjects[order] = self.place
//            case .failure(let error):
//                print("PlaceInnerItemView has error: \(error)")
//            }
//        }, placeIdentifier: placeIdentifier)
//    }
    
    
    
    
//    func loadHistory() {
//
//                var url = URLComponents(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue)!
//
//                url.queryItems = [
//                    URLQueryItem(name: "page", value: "\(self.currentPage)")
//                ]
//
//                var request = URLRequest(url: url.url!)
//                request.httpMethod = "GET"
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//                request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
//
//        //let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.bookingHistoryRoute.rawValue)!
//
//        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
//        .map { $0.data }
//        .decode(type: Orders.self, decoder: JSONDecoder())
//        .tryMap { response in
//            guard let id = response.data.first?.id else {
//                throw "Error read data combine"
//            }
//            return id
//        }
//        .flatMap { id in
//            return self.details(for: id)
//        }
//        .sink(receiveCompletion: { completion in
//
//        }) { place in
//            print(place)
//        }
//    }
//
//
//
//    func details(for placeIdentifier: Int) -> AnyPublisher<Place, Error> {
//        let url = URL(string: DomainRouter.linkAPIRequests.rawValue + DomainRouter.placesRoute.rawValue + "/\(placeIdentifier)")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .mapError { $0 as Error }
//            .map { $0.data }
//            .decode(type: Place.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
    
}
