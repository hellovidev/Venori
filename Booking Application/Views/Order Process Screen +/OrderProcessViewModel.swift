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
    
    @Published var times = [Time]()
    @Published var isFormValid: Bool = false
    @Published var valueHours: Float = 0.5
    @Published var valueHumans: Float = 1
    @Published var selectedReservationTime: String = ""
    @Published var isBookingComplete: Bool = false
    @Published var dateReservation: Date = Date()
    
    @Published var availableTime = [String]()
    @Published var placeIdentifier: Int
    
    init(placeIdentifier: Int) {
        self.placeIdentifier = placeIdentifier
        self.getAvailableTime(placeIdentifier: self.placeIdentifier, adultsAmount: 1, duration: 0.5, date: Date().getDateCorrectFormat(date: Date()))
    }
    
    func getAvailableTime(placeIdentifier: Int, adultsAmount: Int, duration: Float, date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.serverRequest.getPlaceAvailableTime(completion: { result in
            switch result {
            case .success(let times):
                DispatchQueue.main.async {
                    self.isFormValid = false
                    self.times = [Time]()
                    for item in times {
                        self.times.append(Time(time: item))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }, placeIdentifier: placeIdentifier, adultsAmount: adultsAmount, duration: duration, date: date)
    }
    
    func tryOrderComplete() {
        if let selectedTime = times.first(where: { $0.id == self.selectedReservationTime }) {
            self.serverRequest.reserveTablePlace(placeIdentifier: placeIdentifier, adultsAmount: Int(valueHumans), duration: valueHours, date: Date().getDateCorrectFormat(date: dateReservation), time: selectedTime.time, completion: { response in
                switch response {
                case .success(let data):
                    self.isBookingComplete.toggle()
                    // Post notification to history orders
                    NotificationCenter.default.post(name: .newOrderNotification, object: nil)
                    print(data)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    
    
    
    
    
    
}


