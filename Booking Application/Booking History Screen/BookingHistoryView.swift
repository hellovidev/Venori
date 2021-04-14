//
//  BookingHistoryView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookingHistoryView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...10, id: \.self) {
                    Text("\($0)")
                    HistoryItemView()
                }
            }
        }
    }
}

struct HistoryItemView: View {
    var body: some View {
        HStack {
        Text("ID2301023")
            Text("$140.00")
        }
        HStack {
        Image(systemName: "star")
        Text("asidjandsc")
        }
        HStack {
        Image(systemName: "star")
        Text("2343")
        }
        HStack {
            Image(systemName: "star")
            VStack {
                Text("Title")
                HStack {
                Image(systemName: "star")
                Text("4.6")
                Text("(123123)")
                }
            }
        }
        Divider()
    }
}

struct BookingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookingHistoryView()
    }
}
