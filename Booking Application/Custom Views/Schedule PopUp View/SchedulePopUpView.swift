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
    
    var serviceAPI = ServiceAPI()
    
    var body: some View {
        ZStack {
            if show {//true {
                
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
                        
                        HStack(alignment: .center) {
                            Text("Monaday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[0].workStart!) — \(schedules[0].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Tuesday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[1].workStart!) — \(schedules[1].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Wednesday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[2].workStart!) — \(schedules[2].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Thursday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[3].workStart!) — \(schedules[3].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Friday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[4].workStart!) — \(schedules[4].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Saturday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            Text("\(schedules[5].workStart!) — \(schedules[5].workEnd!)")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 14, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                .foregroundColor(Color.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        
                        HStack(alignment: .center) {
                            Text("Sunday:")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                .foregroundColor(Color.black)
                            if schedules[6].workStart == nil {
                                Text("Day off")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 14, weight: .semibold))
                                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                    .foregroundColor(Color.gray)
                            } else {
                                Text("\(schedules[6].workStart!) — \(schedules[6].workEnd!)")
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: 14, weight: .semibold))
                                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        //.background(Color.red)
                        
                        
                        //                    ForEach(schedules!, id: \.self) { object in
                        //                        Text("\(object.id)")
                        //                            .multilineTextAlignment(.center)
                        //                            .font(Font.system(size: 16, weight: .semibold))
                        //                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                        //                            .foregroundColor(Color.white)
                        //                    }
                        
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
