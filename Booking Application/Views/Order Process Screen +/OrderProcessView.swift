//
//  BookView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct OrderProcessView: View {
    @ObservedObject var viewModel: OrderProcessViewModel
    @State private var showPopUp: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.isBookingComplete {
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Button ( action:{
                                self.viewModel.controller?.redirectPrevious()
                            }, label: {
                                Image("Close")
                                    .padding([.top, .bottom, .trailing], 22)
                                    .padding(.leading, 16)
                            })
                            Text("Book a table")
                                .font(.system(size: 32, weight: .bold))
                                .padding(.leading, 16)
                                .padding(.bottom, 22)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Expected date of arrival")
                                        .foregroundColor(Color(UIColor(hex: "#00000080")!))
                                        .font(.system(size: 14, weight: .regular))
                                    Text(Date().getDateCorrectFormat(date: viewModel.dateReservation) == Date().getDateCorrectFormat(date: Date()) ? "Today" : Date().getSelectedDate(date: viewModel.dateReservation))
                                        .font(.system(size: 18, weight: .regular))
                                }
                                .padding(.leading, 16)
                                Spacer()
                                Button (action: {
                                    self.showPopUp.toggle()
                                }, label: {
                                    Image("Calendar")
                                        .padding(.trailing, 16)
                                })
                            }
                            .padding(.bottom, 32)
                            VStack(alignment: .leading) {
                                Text("Number of adults")
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.bottom, 12)
                                StepperView(value: $viewModel.valueHumans, valueType: "", onClick: {
                                    viewModel.getAvailableTime(placeIdentifier: viewModel.placeIdentifier, adultsAmount: Int(viewModel.valueHumans), duration: viewModel.valueHours, date: Date().getDateCorrectFormat(date: viewModel.dateReservation))
                                })
                                .padding(.trailing, 16)
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 32)
                            VStack(alignment: .leading) {
                                Text("How long will you be dining with us?")
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.bottom, 12)
                                StepperView(value: $viewModel.valueHours, valueType: "hr", onClick: {
                                    viewModel.getAvailableTime(placeIdentifier: viewModel.placeIdentifier, adultsAmount: Int(viewModel.valueHumans), duration: viewModel.valueHours, date: Date().getDateCorrectFormat(date: viewModel.dateReservation))
                                })
                                .padding(.trailing, 16)
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 32)
                            VStack(alignment: .leading) {
                                Text("Available reservation times")
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.leading, 16)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    EnumerationTimeView(items: viewModel.times, selected: self.$viewModel.selectedReservationTime, choosed: $viewModel.isFormValid, isLoading: $viewModel.isLoadingAvailableTime, isError: $viewModel.isAvailableTimeError)
                                }
                            }
                            .padding(.bottom, 24)
                            Spacer()
                            Button(action: {
                                viewModel.tryOrderComplete()
                            }) {
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .semibold))
                                    .padding(.top, 13)
                                    .padding(.bottom, 13)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .frame(maxWidth: .infinity)
                                    .shadow(radius: 10)
                                    .background(viewModel.isFormValid == false ? Color.gray : Color("Button Color"))
                            }
                            .disabled(viewModel.isFormValid == false)
                            .modifier(ButtonModifier())
                            .padding(.bottom, 35)
                        }
                    }
                    DatePickerView(orderDateReservation: $viewModel.dateReservation, show: $showPopUp, onSelected: {
                        showPopUp.toggle()
                        viewModel.getAvailableTime(placeIdentifier: viewModel.placeIdentifier, adultsAmount: Int(viewModel.valueHumans), duration: viewModel.valueHours, date: Date().getDateCorrectFormat(date: viewModel.dateReservation))
                    })
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel(Text("Okay"), action: { viewModel.showAlert = false }))
                }
            } else {
                CompleteView(actionContinue: {
                    self.viewModel.controller?.completeOrderProcess()
                }, actionBack: {
                    self.viewModel.isBookingComplete.toggle()
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

// MARK: -> Complete Booking Process View

struct CompleteView: View {
    var actionContinue: () -> Void
    var actionBack: () -> Void
    
    var body: some View {
        Button (action: {
            self.actionBack()
        }, label: {
            Image("Arrow Left")
                .padding([.top, .bottom, .trailing], 22)
                .padding(.leading, 16)
        })
        VStack(alignment: .center) {
            Image("Complete")
                .padding(.bottom, 65)
            Text("The table has been booked")
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 16)
            Text("We’ll wait for you on time.")
                .font(.system(size: 20, weight: .regular))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
        Button (action: {
            self.actionContinue()
        }, label: {
            Text("Continue")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 13)
                .padding(.bottom, 13)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity)
                .shadow(radius: 10)
        })
        .modifier(ButtonModifier())
        .padding(.bottom, 35)
    }
    
}
