//
//  HistoryOrderItemView.swift
//  Booking Application
//
//  Created by student on 7.05.21.
//

import SwiftUI

// MARK: -> History Order Item View

struct HistoryOrderItemView: View {
    private let serviceAPI = ServiceAPI()
    @State private var order: Order
    @State private var isHistory: Bool = false
    @State private var isActiveOrder: Bool = false
    //@State private var place = Place()
    
    @State private var cancelCallback: () -> Void
    
    init(order: Order, cancel: @escaping () -> Void) {
        self._order = State(initialValue: order)
        self._cancelCallback = State(initialValue: cancel)
        switch self.order.status {
        case "Confirmed":
            self._isHistory = State(initialValue: true)
            self._isActiveOrder = State(initialValue: false)
        case "Rejected":
            self._isHistory = State(initialValue: true)
            self._isActiveOrder = State(initialValue: false)
        default:
            self._isHistory = State(initialValue: false)
            self._isActiveOrder = State(initialValue: true)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ID\(self.order.id)")
                    .font(.system(size: 20, weight: .bold))
                ZStack {
                    Text(self.order.status)
                        .isHidden(!self.isActiveOrder, remove: !self.isActiveOrder)
                        .foregroundColor(.blue)
                        .font(.system(size: 12, weight: .regular))
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 6)
                        .background(
                            Color(UIColor(hex: "#3A7DFF2E")!)
                                .cornerRadius(14)
                        )
                }
                Spacer()
                Text("$\(self.order.price)")
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .semibold))
            }
            HStack {
                Image("Date Booking")
                    .padding(.trailing, 12)
                Text("\(Date().convertServerOrderDate(date: self.order.createdAt))")
                    .font(.system(size: 14, weight: .regular))
            }
            HStack {
                Image("Persons")
                    .padding(.trailing, 12)
                Text("\(self.order.people) Person\(self.order.people == 1 ? "" : "s")")
                    .font(.system(size: 14, weight: .regular))
            }
            
            //PlaceInnerItemView(place: self.order.place)

            VStack(alignment: .center) {
                Button(action: {
                    self.cancelCallback()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.top, 13)
                        .padding(.bottom, 13)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                }
                .isHidden(!self.isActiveOrder, remove: !self.isActiveOrder)
                .background(Color("Button Color"))
                .cornerRadius(24)
                .padding(.leading, 75)
                .padding(.trailing, 75)
                .padding(.bottom, 8)
                .shadow(color: Color(UIColor(hex: "#3A7DFF66")!), radius: 8)
            }
            Divider()
                .padding(.bottom, 12)
        }
        .padding([.leading, .trailing], 16)
    }
}
