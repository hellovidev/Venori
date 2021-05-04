//
//  OrdersView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Orders")
                        .padding([.leading, .top], 16)
                        .font(.system(size: 28, weight: .bold))
                    ZStack {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(viewModel.orders?.sorted { $0.id > $1.id } ?? [], id: \.self) { item in
                                    HistoryOrderItemView(order: item, cancel: {
                                        self.viewModel.cancelOrder(orderIdentifier: item.id)
                                    })
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.top, 16)
                            .padding(.bottom, 35)
                        }
                        LoadingView(isAnimating: self.viewModel.isLoading, configuration: { view in
                            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            view.color = .black
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(self.viewModel.isLoading ? Color(UIColor(hex: "#80808033")!) : Color(UIColor(hex: "#00000000")!))
                    }
                }
                .navigationBarHidden(true)
                
                VStack(alignment: .center) {
                    Image("Empty")
                        .resizable()
                        .renderingMode(.template)
                        .isHidden(!self.viewModel.isEmpty, remove: !self.viewModel.isEmpty)
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                    Text("You have no orders in progress.")
                        .isHidden(!self.viewModel.isEmpty, remove: !self.viewModel.isEmpty)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                    Image("Reload")
                        .resizable()
                        .renderingMode(.template)
                        .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                        .padding(.bottom, 12)
                    Text("Error! Try downloading the data again.")
                        .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .padding(.bottom, 12)
                    Button(action: {
                        self.viewModel.isLoading = true
                        self.viewModel.fetchOrders()
                    }, label: {
                        Text("Try again")
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 16)
                            .padding([.leading, .trailing], 32)
                            .font(.system(size: 16, weight: .semibold))
                    })
                    .isHidden(!self.viewModel.isError, remove: !self.viewModel.isError)
                    .background(Color(UIColor(hex: "#00000030")!))
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {
            self.viewModel.fetchOrders()
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: OrdersViewModel())
    }
}
