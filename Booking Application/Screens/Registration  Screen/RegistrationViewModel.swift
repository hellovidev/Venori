//
//  RegistrationViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
    var controller: RegistrationViewController?
}
