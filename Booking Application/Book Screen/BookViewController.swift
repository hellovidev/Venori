//
//  BookViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import UIKit
import SwiftUI

class BookViewController: UIHostingController<BookView>  {
    private let state = BookViewModel()
    var serviceAPI = ServiceAPI()
    var placeID: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        state.placeID = placeID
        
        if placeID != nil {
            self.serviceAPI.getPlaceAvailableTime(placeIdentifier: state.placeID!, adultsAmount: 1, duration: 0.5, date: "2021-04-24")
            if serviceAPI.availableTimes != nil {
                state.avalClock = serviceAPI.availableTimes!
            }
        }
    }
    
    init() {
        let view = BookView(bookViewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func fullyComplete() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
