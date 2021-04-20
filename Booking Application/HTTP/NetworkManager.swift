//
//  NetworkManager.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var items = [User]()
    private let url = URL(string: APIRequests.dataResource.rawValue + APIRequests.prefixKeyAPI.rawValue + APIRequests.keyAPI.rawValue)!
    
//    func loadData() -> AnyPublisher<[User], Error> {
//        return URLSession.shared.dataTaskPublisher(for: self.url)
//            .map(\.data)
//            .decode(type: Results.self, decoder:  JSONDecoder())
//            .map(\.items)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}
