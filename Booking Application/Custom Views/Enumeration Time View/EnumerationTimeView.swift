//
//  EnumerationTimeView.swift
//  Booking Application
//
//  Created by student on 30.04.21.
//

import Foundation
import SwiftUI

struct EnumerationTimeView: View {
    var items: [Time]
    @Binding var selected: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -8) {
                ForEach(items, id: \.self) { item in
                    ItemTimeView(time: item, selectedButtonIdentifier: self.$selected)
                }
            }
        }
    }
}

struct ItemTimeView: View {
    var time: Time
    @Binding var selectedButtonIdentifier: String 
    
    var body: some View{
        Button(action: {
            self.selectedButtonIdentifier = self.time.id
        }) {
            Text(time.time)
                .foregroundColor(self.selectedButtonIdentifier == self.time.id ? Color.white : Color(UIColor(hex: "#00000080")!))
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
        }
        .background(self.selectedButtonIdentifier == self.time.id ? Color.blue : Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
        .padding(.leading, 16)
    }
}
