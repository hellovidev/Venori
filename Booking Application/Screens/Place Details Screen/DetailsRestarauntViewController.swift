//
//  DetailsRestarauntViewController.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import UIKit
import SwiftUI

class DetailsRestarauntViewController: UIHostingController<DetailsRestarauntView>  {
    private let state = DetailsRestarauntViewModel()
    var place: Place?
    private var serviceAPI = ServiceAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        state.place = place
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        let view = DetailsRestarauntView(viewModel: state)
        super.init(rootView: view)
        state.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redirectToBooking() {
        let navigationController = UINavigationController(rootViewController: OrderProcessViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMapView() {
        let navigationController = UINavigationController(rootViewController: MapViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    // MARK: -> Redirect User To Booking Process

    func redirectToBookingProcess(object: Place) {
        let rootviewController = OrderProcessViewController()
        rootviewController.placeID = object.id
        let navigationController = UINavigationController(rootViewController: rootviewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated:true, completion: nil)
    }
    
    func showWeekSchedule(placeID: Int) {
        self.serviceAPI.getScheduleOfPlace(completion: { result in
                switch result {
                case .success(let weekSchedule):
                    self.state.schedules = weekSchedule
                    print(weekSchedule)
                    //self.times = times
                case .failure(let error):
                    print(error)
                //                                    DispatchQueue.main.async {
                //                                        viewModel.controller?.failPopUp(title: "Error", message: error.localizedDescription, buttonTitle: "Okay")
                //                                      }
                }
        }, placeIdentifier: placeID)
    }
    
}

//func getDayOfWeek(_ today:String) -> Int? {
//    let formatter  = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd"
//    guard let todayDate = formatter.date(from: today) else { return nil }
//    let myCalendar = Calendar(identifier: .gregorian)
//    let weekDay = myCalendar.component(.weekday, from: todayDate)
//    return weekDay
//}
//
//if let weekday = getDayOfWeek("2021-04-28") {
//    print(weekday)
//} else {
//    print("bad input")
//}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

// returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
//print(Date().dayNumberOfWeek()!) // 4
//If you were looking for the written, localized version of the day of week:

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

//print(Date().dayOfWeek()!) // Wednesday
