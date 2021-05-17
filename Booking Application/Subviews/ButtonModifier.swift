//
//  ButtonModifier.swift
//  Booking Application
//
//  Created by student on 3.05.21.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("Button Color"))
            .cornerRadius(24)
            .padding(.leading, 75)
            .padding(.trailing, 75)
            .padding(.top, 16)
            .shadow(radius: 8)
    }
    
}
