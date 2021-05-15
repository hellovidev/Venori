//
//  PopUpView.swift
//  Booking Application
//
//  Created by student on 28.04.21.
//

import SwiftUI

struct SchedulePopUpView: View {
    var placeIdentifier: Int
    @Binding var show: Bool
    
    @State var schedules: [Schedule]
    
    var serviceAPI = ServerRequest()
    
    private let enumerations = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ZStack {
            if show {
                
                // Background Color of PopUp View
                
                Color.black.opacity(show ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                
                // PopUp Window
                
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Week Schedule")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 22, weight: .semibold))
                            .foregroundColor(Color.white)
                            .background(Color("Button Color"))
                        ForEach(0..<enumerations.count) { i in
                            HStack(alignment: .center) {
                                Text("\(enumerations[i]):")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 16, weight: .semibold))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                    .foregroundColor(Color.black)
                                Spacer()
                                if schedules[i].workStart == nil {
                                    Text("Day off")
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("\(schedules[i].workStart!) — \(schedules[i].workEnd!)")
                                        .multilineTextAlignment(.center)
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 12, trailing: 0))
                        }
                    }
                    .frame(maxWidth: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text("Okay")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.top, 13)
                            .padding(.bottom, 13)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .frame(maxWidth: .infinity)
                            .shadow(radius: 10)
                    })
                    .frame(maxWidth: 300)
                    .background(Color("Button Color"))
                    .cornerRadius(24)
                    
                }
            }
        }
        .onAppear {
            self.serviceAPI.getScheduleOfPlace(completion: { result in
                switch result {
                case .success(let weekSchedule):
                    self.schedules = weekSchedule
                case .failure(let error):
                    print(error)
                }
            }, placeIdentifier: self.placeIdentifier)
        }
    }
}

//struct SchedulePopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SchedulePopUpView(title: "Week Schedule")
//    }
//}
