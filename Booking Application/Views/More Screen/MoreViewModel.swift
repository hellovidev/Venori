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
        
    @Published var isLoading: Bool = false
    @Published var user: User?
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init() {
        do {
            self.user = try UserDefaults.standard.getObject(forKey: "current_user", castTo: User.self)
        } catch {
            print("Decode user faild: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func logoutAccount() {
        isLoading = true
        self.serverRequests.userAccountLogout( completion: { result in
            switch result {
            case .success(let message):
                self.isLoading = false
                self.controller?.systemLogout()
                print("Logout success: \(message)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Logout faild: \(error.localizedDescription)")
                }
            }
        })
    }
    
}
