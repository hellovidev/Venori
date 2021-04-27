//
//  MenuView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct UserMenuView: View {
    @ObservedObject var userMenuViewModel: UserMenuViewModel
    private let api = ServiceAPI()
    
    private let headerSection = ["Account details", "Booking history", "Favorites", "Notifications", "Settings"]
    private let menuIcons = ["Menu Account", "Menu Booking", "Menu Favorites", "Menu Notifications", "Menu Settings"]
    private let footerSection = ["About", "Contact", "Terms", "Privacy Policy"]
    
    var body: some View {
        VStack {
            ZStack {
                Image("Background Account")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 256)
                VStack {
                    Image("User Logo")
                    Text("Alex Goldant!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 4)
                    Text("template@email.com")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.white)
                }
            }
            Spacer()
                //.background(Color(UIColor(hex: "#FFFFFFFF")!))
                .frame(maxHeight: 40)
            List {
                Section(footer: Spacer()) {
                    ForEach(headerSection, id: \.self) { item in
                        Button { } label: {
                            HStack(alignment: .center) {
                                Image(menuIcons[0])
                                Text("\(item)")
                                Spacer()
                                Image("Menu Vector")
                            }
                        }
                    }
                }
                Section(footer:
                            Button {
                                api.userAccountLogout()
                                userMenuViewModel.controller?.systemLogOut()
                            } label: {
                                Text("Log out")
                            }
                            .padding(.top, 30)
                            .foregroundColor(Color.blue)
                ) {
                    ForEach(footerSection, id: \.self) { item in
                        Button { } label: {
                            Text("\(item)")
                        }
                    }
                }
            }
        }
    }
}

struct UserMenuView_Previews: PreviewProvider {
    static var previews: some View {
        UserMenuView(userMenuViewModel: UserMenuViewModel())
    }
}
