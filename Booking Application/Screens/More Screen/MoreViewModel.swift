//
//  UserMenuViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class MoreViewModel: ObservableObject {
    weak var controller: MoreViewController?
    @Published var user: User?
    
    init() {
        
        // Read/Get Data

        if let data = UserDefaults.standard.data(forKey: "current_user") {

            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                self.user = try decoder.decode(User.self, from: data)

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
}
