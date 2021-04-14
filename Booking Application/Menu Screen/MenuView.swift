//
//  MenuView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct MenuView: View {
    private let headerSection = ["Account details", "Booking history", "Favorites", "Notifications", "Settings"]
    private let footerSection = ["About", "Contact", "Terms", "Privacy Policy"]
    
    var body: some View {
        VStack {
            Image("Background Account")
                .resizable()
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(VStack {
                    Image(systemName: "film")
                    Text("Alex Goldant!")
                        .bold()
                        .foregroundColor(Color.white)
                    Text("template@email.com")
                        .foregroundColor(Color.white)
                })
            List {
                Section() {
                    ForEach(headerSection, id: \.self) { item in
                        HStack {
                            Image(systemName: "heart")
                            Text("\(item)")
                            Spacer()
                            Image(systemName: "link")
                        }
                    }
                }
                Section(footer: Button {
                    print("Pressed!")
                } label: {
                    Text("Log out")
                }
                .padding(.top, 30)
                .foregroundColor(Color.blue))
                {
                    ForEach(footerSection, id: \.self) { item in
                        Text("\(item)")
                    }
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
