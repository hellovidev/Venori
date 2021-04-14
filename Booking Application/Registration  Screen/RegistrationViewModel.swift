//
//  RegistrationViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
    
    init() {
        
    }
    
}
