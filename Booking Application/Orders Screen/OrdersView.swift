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
            VStack(alignment: .leading) {
                Text("Orders")
                    .padding([.leading, .top], 16)
                    .padding(.bottom, 22)
                    .font(.system(size: 28, weight: .bold))
                VStack {
                    ForEach(0...10, id: \.self) {
                        Text("\($0)")
                        HistoryItemView(isStatus: true, isActive: true)
                    }
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
