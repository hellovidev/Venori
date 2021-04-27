//
//  AllCategoriesViewModel.swift
//  Booking Application
//
//  Created by student on 15.04.21.
//

import Foundation

class AllCategoriesViewModel: ObservableObject {
    var controller: AllCategoriesViewController?
    @Published var categories = [Category]()
}
