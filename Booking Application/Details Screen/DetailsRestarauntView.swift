//
//  DetailsRestarauntView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct DetailsRestarauntView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            //back fav but
            Text("Title")
            Text("Category")
            HStack {
                Image(systemName: "star")
                Text("4.0")
                Text("456 Reviews")
            }
            
            HStack {
                Image(systemName: "map")
                VStack {
                    Text("Location")
                    Button { } label: { Text("View map") }
                    
                }
                //Map
            }
            HStack {
                Image(systemName: "phone")
                Text("+7 812 9231983")
            }
            
            HStack {
                Image(systemName: "clock")
                VStack {
                    Text("Available")
                    Button { } label: { Text("View schadle") }
                }
            }
            
            HStack {
                Image(systemName: "info")
                Text("text")
            }
            Button { } label: { Text("Book a table") }
        }
    }
}

struct DetailsRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsRestarauntView()
    }
}
