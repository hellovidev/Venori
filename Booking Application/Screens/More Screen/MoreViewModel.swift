//
//  UserMenuViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class MoreViewModel: ObservableObject {
    weak var controller: MoreViewController?
    private let serverRequests = ServerRequest()
    
    @Published var user: User?
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init() {
        do {
            self.user = try UserDefaults.standard.getObject(forKey: "current_user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func logoutAccount() {
        self.serverRequests.userAccountLogout( completion: { result in
            switch result {
            case .success(let message):
                print(message)
                self.controller?.systemLogout()
            case .failure(let error):
                print(error)
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        })
    }
    
}
