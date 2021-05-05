//
//  DetailsRestarauntViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class DetailsRestarauntViewModel: ObservableObject {
    weak var controller: DetailsRestarauntViewController?
    private let serviceAPI: ServiceAPI = ServiceAPI()
    
    @Published var place: Place?
    @Published var workTime: String?
    @Published var schedules: [Schedule]?
    
    func deleteFavouriteState() {
        self.serviceAPI.deleteFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place?.favourite?.toggle()
                print(response)
            case .failure(let error):
                print(error)
            }
        }, placeIdentifier: self.place!.id)
    }
    
    func setFavouriteState() {
        self.serviceAPI.addToFavourite(completion: { result in
            switch result {
            case .success(let response):
                self.place?.favourite?.toggle()
                print(response)
            case .failure(let error):
                print(error)
            }
        }, placeIdentifier: self.place!.id)
    }
    
}
