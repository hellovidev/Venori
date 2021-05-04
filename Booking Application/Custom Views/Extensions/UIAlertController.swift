//
//  UIAlertController.swift
//  Booking Application
//
//  Created by student on 4.05.21.
//

import UIKit

extension UIAlertController {
    func showPopUp(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
