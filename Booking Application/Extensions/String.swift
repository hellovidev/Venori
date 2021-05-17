//
//  String.swift
//  Booking Application
//
//  Created by student on 17.05.21.
//

import SwiftUI

// MARK: -> String Extension for Validate Password & Email

extension String {
    func isValidEmail() -> Bool {
        // Here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        if self.count < 8 {
            return false
        } else {
            return true
        }
    }
    
}

extension String {
    func isValidEmail(_ email: Self) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

// MARK: -> Added Functionality For Return Error As String

extension String: LocalizedError {
    public var errorDescription: String? { return self }
    
}
