//
//  Result.swift
//  Booking Application
//
//  Created by student on 17.05.21.
//

import SwiftUI

// MARK: -> Get Data Results Or Error From Completion

public enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
    
}

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
}

extension Result where Success == Data {
    func decoded<T: Codable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
    
}
