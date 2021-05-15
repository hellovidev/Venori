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
    @Binding var choosed: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -16) {
                if !items.isEmpty {
                    ForEach(items, id: \.self) { item in
                        ItemTimeView(time: item, selectedButtonIdentifier: self.$selected, isSelected: self.$choosed)
                    }
                } else {
                    Button(action: {}) {
                        Text("💤 It's Day off")
                            .foregroundColor(Color.black)
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 16)
                    }
                    .background(Color.yellow)
                    .cornerRadius(24)
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                }
            }
        }
    }
}

struct ItemTimeView: View {
    var time: Time
    @Binding var selectedButtonIdentifier: String
    @Binding var isSelected: Bool
    
    var body: some View{
        Button(action: {
            self.selectedButtonIdentifier = self.time.id
            self.isSelected = true
        }) {
            Text(time.time)
                .foregroundColor(self.selectedButtonIdentifier == self.time.id ? Color.white : Color(UIColor(hex: "#00000080")!))
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
        }
        .background(self.selectedButtonIdentifier == self.time.id ? Color.blue : Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
        .padding(.leading, 16)
        .padding(.trailing, 8)
    }
}
