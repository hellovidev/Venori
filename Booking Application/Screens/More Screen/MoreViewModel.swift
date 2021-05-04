//
//  UserMenuViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import UIKit
import Foundation

class MoreViewModel: ObservableObject {
    weak var controller: MoreViewController?
    private let serviceAPI = ServiceAPI()
    @Published var user: User?
    
    init() {
        
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
    
    func logoutAccount() {
        self.serviceAPI.userAccountLogout( completion: { result in
            switch result {
            case .success(let message):
                self.controller?.systemLogout()
                print(message)
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
