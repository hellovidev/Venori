//
//  OrdersView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var ordersViewModel: OrdersViewModel
    
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

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(ordersViewModel: OrdersViewModel())
    }
}
