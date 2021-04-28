//
//  DetailsRestarauntViewModel.swift
//  Booking Application
//
//  Created by student on 19.04.21.
//

import Foundation

class DetailsRestarauntViewModel: ObservableObject {
    weak var controller: DetailsRestarauntViewController?
    @Published var place: Place?
    
}
