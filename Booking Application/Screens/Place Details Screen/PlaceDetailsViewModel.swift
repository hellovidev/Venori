//
//  DetailsRestarauntViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class PlaceDetailsViewModel: ObservableObject {
    weak var controller: PlaceDetailsViewController?
    private let serviceAPI: ServiceAPI = ServiceAPI()
    
    @Published var showAlertError = false
    @Published var errorMessage = ""
    
    @Published var place: Place?
    @Published var workTime: String?
    @Published var schedules: [Schedule]?
    
    // MARK: -> API Request For Delete Place From Favourite
    
    func deleteFavouriteState() {
        serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place?.favourite = false
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: self.place!.id)
    }
    
    // MARK: -> API Request For Add Place To Favourite
    
    func setFavouriteState() {
        self.serviceAPI.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place?.favourite = true
                print(response)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlertError = true
                print(error)
            }
        }, placeIdentifier: self.place!.id)
    }
    
}
