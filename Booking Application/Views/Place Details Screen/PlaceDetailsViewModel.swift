//
//  DetailsRestarauntViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class PlaceDetailsViewModel: ObservableObject {
    weak var controller: PlaceDetailsViewController?
    private let serverRequest = ServerRequest()
    private let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    // Alert Data
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    @Published var place: Place
    @Published var workTime: String?
    @Published var schedules = [Schedule]()
    
    init(place: Place) {
        self.place = place
        self.getSchedule()
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState() {
        self.serverRequest.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place.favourite = false
                
                // Post notification to favourite places
                
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Delete favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlertError = true
                    print("Delete favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: self.place.id)
    }
    
    // MARK: -> API Request For Add Place To Favourite
    
    func setFavouriteState() {
        self.serverRequest.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place.favourite = true
                
                // Post notification to favourite places
                
                NotificationCenter.default.post(name: .newFavouriteNotification, object: nil)
                print("Add favourite success: \(response)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlertError = true
                    print("Add favourite faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: self.place.id)
    }
    
    // MARK: -> API Request For Work Time
    
    func getSchedule() {
        self.serverRequest.getScheduleOfPlace(completion: { result in
            switch result {
            case .success(let weekSchedule): do {
                if !weekSchedule.isEmpty {
                    self.schedules = weekSchedule
                    switch Date().dayOfWeek()! {
                    case self.days[0]:
                        self.workTime = weekSchedule[0].workEnd!
                    case self.days[1]:
                        self.workTime = weekSchedule[1].workEnd!
                    case self.days[2]:
                        self.workTime = weekSchedule[2].workEnd!
                    case self.days[3]:
                        self.workTime = weekSchedule[3].workEnd!
                    case self.days[4]:
                        self.workTime = weekSchedule[4].workEnd!
                    case self.days[5]:
                        self.workTime = weekSchedule[5].workEnd!
                    case self.days[6]:
                        self.workTime = weekSchedule[6].workEnd!
                    default:
                        print("Incorrect schedule day!")
                    }
                }
                print("Get schedule success: \(weekSchedule.count)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlertError = true
                    print("Get schedule faild: \(error.localizedDescription)")
                }
            }
        }, placeIdentifier: place.id)
    }
    
}
