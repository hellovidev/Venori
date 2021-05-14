//
//  UserMenuViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class MoreViewModel: ObservableObject {
    weak var controller: MoreViewController?
    private let serviceAPI = ServiceAPI()
    
    @Published var user: User?
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
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
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        })
    }
    
}


//let userDefaults = UserDefaults.standard
//do {
//    let playingItMyWay = try userDefaults.getObject(forKey: "MyFavouriteBook", castTo: Book.self)
//    print(playingItMyWay)
//} catch {
//    print(error.localizedDescription)
//}
