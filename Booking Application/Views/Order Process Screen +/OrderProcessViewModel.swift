//
//  BookViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class OrderProcessViewModel: ObservableObject {
    weak var controller: OrderProcessViewController?
    private let serverRequest = ServerRequest()
    
    @Published var placeIdentifier: Int

    // Form Status
    
    @Published var valueHumans: Float = 1
    @Published var valueHours: Float = 0.5
    @Published var isFormValid: Bool = false
    @Published var dateReservation: Date = Date()
    @Published var isBookingComplete: Bool = false
    @Published var selectedReservationTime: String = ""
    
    // Available Time Status
    
    @Published var times = [Time]()
    @Published var isLoadingAvailableTime: Bool = true
    @Published var isAvailableTimeError: Bool = false
    
    // Alert Data
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
        self.getAvailableTime(placeIdentifier: self.placeIdentifier, adultsAmount: 1, duration: 0.5, date: Date().getDateCorrectFormat(date: Date()))
    }
    
    func getAvailableTime(placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String) {
        self.isLoadingAvailableTime = true
        
        self.serverRequest.getPlaceAvailableTime(completion: { result in
            switch result {
            case .success(let times):
                DispatchQueue.main.async {
                    self.isFormValid = false
                    self.times = [Time]()
                    for item in times {
                        self.times.append(Time(time: item))
                    }
                    self.isLoadingAvailableTime = false
                    self.isAvailableTimeError = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoadingAvailableTime = false
                    self.isAvailableTimeError = true
                    print("Get available time faild: \(error.localizedDescription)")
                }                
            }
        }, placeIdentifier: placeIdentifier, adultsAmount: adultsAmount, duration: duration, date: date)
    }
    
    func tryOrderComplete() {
        if let selectedTime = times.first(where: { $0.id == self.selectedReservationTime }) {
            self.serverRequest.reserveTablePlace(placeIdentifier: placeIdentifier, adultsAmount: Int(valueHumans), duration: valueHours, date: Date().getDateCorrectFormat(date: dateReservation), time: selectedTime.time, completion: { response in
                switch response {
                case .success(let response):
                    self.isBookingComplete.toggle()
                    
                    // Post notification to active orders
                    
                    NotificationCenter.default.post(name: .newOrderNotification, object: nil)
                    print("Try push new order success: \(response)")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription
                        print("Try push new order faild: \(error.localizedDescription)")
                    }
                }
            })
        }
    }
    
}
