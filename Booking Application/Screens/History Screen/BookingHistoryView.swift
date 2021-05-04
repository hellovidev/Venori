//
//  BookingHistoryView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct BookingHistoryView: View {
    @ObservedObject var viewModel: BookingHistoryViewModel
    @State private var isEmpty: Bool = false
    @State private var isLoading: Bool = true
    @State private var isError: Bool = false
    private let serviceAPI = ServiceAPI()
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        ZStack {
                            VStack {
                                Button(action: {
                                    self.viewModel.controller?.goBackToPreviousView()
                                }, label: {
                                    Image("Arrow Left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 24, alignment: .leading)
                                        .padding([.bottom, .top], 13)
                                        .padding(.leading, 19)
                                        .foregroundColor(.black)
                                })
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Booking history")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(width: geometry.size.width, height: 48, alignment: .center)
                        ZStack {
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    ForEach(viewModel.orders.sorted { $0.id > $1.id }, id: \.self) { item in
                                        HistoryOrderItemView(order: item, cancel: {})
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .padding(.top, 16)
                                .padding(.bottom, 35)
                            }
                            LoadingView(isAnimating: isLoading, configuration: { view in
                                view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                view.color = .black
                            })
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .background(isLoading ? Color(UIColor(hex: "#80808033")!) : Color(UIColor(hex: "#00000000")!))
                        }
                    }
                }
                .navigationBarHidden(true)
                
                VStack(alignment: .center) {
                    Image("Empty")
                        .resizable()
                        .renderingMode(.template)
                        .isHidden(!isEmpty, remove: !isEmpty)
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                    Text("You have no confirmed or rejected orders.")
                        .isHidden(!isEmpty, remove: !isEmpty)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                    Image("Reload")
                        .resizable()
                        .renderingMode(.template)
                        .isHidden(!isError, remove: !isError)
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .frame(maxWidth: 64, maxHeight: 64, alignment: .center)
                        .padding(.bottom, 12)
                    Text("Error! Try downloading the data again.")
                        .isHidden(!isError, remove: !isError)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                        .padding(.bottom, 12)
                    Button(action: {
                        self.isLoading = true
                        self.serviceAPI.fetchDataAboutBookingHistory(completion: { result in
                            switch result {
                            case .success(let orders):
                                viewModel.orders = orders.data
                                self.isLoading = false
                                self.isError = false
                                if viewModel.orders.isEmpty {
                                    self.isEmpty = true
                                } else {
                                    self.isEmpty = false
                                }
                            case .failure(let error):
                                self.isLoading = false
                                self.isEmpty = false
                                self.isError = true
                                print(error)
                            }
                        })
                    }, label: {
                        Text("Try again")
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 16)
                            .padding([.leading, .trailing], 32)
                            .font(.system(size: 16, weight: .semibold))
                    })
                    .isHidden(!isError, remove: !isError)
                    .background(Color(UIColor(hex: "#00000030")!))
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {
            self.serviceAPI.fetchDataAboutBookingHistory(completion: { result in
                switch result {
                case .success(let orders):
                    viewModel.orders = orders.data
                    self.isLoading = false
                    self.isError = false
                    if viewModel.orders.isEmpty {
                        self.isEmpty = true
                    } else {
                        self.isEmpty = false
                    }
                case .failure(let error):
                    self.isLoading = false
                    self.isEmpty = false
                    self.isError = true
                    print(error)
                }
            })
        }
    }
}

struct BookingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookingHistoryView(viewModel: BookingHistoryViewModel())
    }
}

// MARK: -> History Order Item View

struct HistoryOrderItemView: View {
    private let serviceAPI = ServiceAPI()
    @State private var order: Order
    @State private var isHistory: Bool = false
    @State private var isActiveOrder: Bool = false
    @State private var place = Place()
    
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
            PlaceInnerItemView(place: self.place)
                .onAppear {
                    self.serviceAPI.getPlaceByIdentifier(completion: { response in
                        switch response {
                        case .success(let place):
                            self.place = place
                        case .failure(let error):
                            print("PlaceInnerItemView has error: \(error)")
                        }
                    }, placeIdentifier: self.order.placeID)
                }
            
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

// MARK: -> Inner View In Order View

struct PlaceInnerItemView: View {
    let place: Place
    
    var body: some View {
        HStack(alignment: .top) {
            if !place.imageURL.isEmpty {
                ImageURL(url: DomainRouter.generalDomain.rawValue + place.imageURL)
                    .scaledToFill()
                    .frame(maxWidth: 72, maxHeight: 72, alignment: .center)
                    .cornerRadius(14)
                    .fixedSize()
            }
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, -4)
                    .padding(.top, 2)
                HStack {
                    Image("Star")
                    Text("\((NSString(format: "%.01f", place.rating)))")
                        .font(.system(size: 16, weight: .regular))
                    Text("(\(place.reviewsCount))")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .regular))
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
        .padding([.bottom, .top], 12)
    }
}
