//
//  DetailsRestarauntViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class PlaceDetailsViewModel: ObservableObject {
    weak var controller: PlaceDetailsViewController?
    private let serviceAPI: ServerRequest = ServerRequest()
    
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    @Published var place: Place
    @Published var workTime: String?
    @Published var schedules: [Schedule]?
    
    init(place: Place) {
        self.place = place
        getSchedule()
    }
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState() {
        serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place.favourite = false
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: self.place.id)
    }
    
    // MARK: -> API Request For Add Place To Favourite
    
    func setFavouriteState() {
        self.serviceAPI.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place.favourite = true
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: self.place.id)
    }
    
    
    private let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    
    func getSchedule() {
    self.serviceAPI.getScheduleOfPlace(completion: { result in
        switch result {
        case .success(let weekSchedule): do {
            if !weekSchedule.isEmpty {
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
        }
        case .failure(let error):
            print(error)
        }
    }, placeIdentifier: place.id)
    }
}
