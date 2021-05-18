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
    @Binding var isLoading: Bool
    @Binding var isError: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -16) {
                if !isLoading && !isError {
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
                } else if isError {
                    
                    Button(action: {}) {
                        Text("Sorry... Loading is faild ❌")
                            .foregroundColor(Color.white)
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 16)
                    }
                    .background(Color.black)
                    .cornerRadius(24)
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                } else {
                    ProgressView()
                        .padding(.leading, 16)
                        .padding(.trailing, 24)
                    Text("Loading...")
                        .padding(.trailing, 24)
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
        }, label: {
            Text(time.time)
                .foregroundColor(self.selectedButtonIdentifier == self.time.id ? Color.white : Color(UIColor(hex: "#00000080")!))
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
        })
        .background(self.selectedButtonIdentifier == self.time.id ? Color.blue : Color(UIColor(hex: "#F6F6F6FF")!))
        .cornerRadius(24)
        .padding(.leading, 16)
        .padding(.trailing, 8)
    }
    
}
