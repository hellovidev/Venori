//
//  StepperView.swift
//  Booking Application
//
//  Created by student on 27.04.21.
//

import SwiftUI

struct StepperView: View {
    @Binding var value: Float
    var valueType: String
    var onClick: () -> Void
        
    var body: some View {
        HStack(alignment: .center) {
            Button {
                if value > 1 && valueType != "hr" {
                    value -= 1
                    self.onClick()
                } else if value > 0.5 && valueType == "hr" {
                    value -= 0.5
                    self.onClick()
                }
            } label: {
                Image("Minus")
                    .padding([.top, .bottom], 12)
                    .padding(.leading, 16)
            }
            Spacer()
            if valueType != "hr" {
                Text("\(NSString(format: "%.0f", value))")
                    .font(.system(size: 22, weight: .regular))
            } else {
                Text("\(value)" + " " + valueType)
                    .font(.system(size: 22, weight: .regular))
            }
            Spacer()
            Button {
                if valueType == "hr" && value < 24 {
                    value += 0.5
                    self.onClick()
                } else if valueType != "hr" {
                    value += 1
                    self.onClick()
                }
            } label: {
                Image("Plus")
                    .padding([.top, .bottom], 12)
                    .padding(.trailing, 16)
            }
        }
        .background(Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
    }
    
}
