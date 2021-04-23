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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.serviceAPI.getPlaceAvailableTime(placeIdentifier: 1)
        if serviceAPI.availableTimes != nil {
            state.avalClock = serviceAPI.availableTimes!
        }
    }
    
    override func viewDidLoad() {
        self.serviceAPI.getPlaceAvailableTime(placeIdentifier: 1)
        if serviceAPI.availableTimes != nil {
            state.avalClock = serviceAPI.availableTimes!
        }
        sleep(5)
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
