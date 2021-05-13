//
//  RegistrationViewModel.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    weak var controller: RegistrationViewController?

    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
}
