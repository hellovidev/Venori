//
//  SplashView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct LaunchView: View {
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack{
            isLoading ? Image("Splash Image Blur").frame(alignment: .top).modifier(ImageStartModifier()) : Image("Splash Image").frame(maxWidth: .infinity, alignment: .top).modifier(ImageStartModifier())
            Spacer()
        }
        .overlay(
            RadialGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#D6DDE700")!), Color(UIColor(hex: "#DAE1EBFF")!)]), center: UnitPoint(x: 0.5, y: 0.33), startRadius: 140, endRadius: 220)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(nil, {
                        self.isLoading.toggle()
                    })
                }
        )
    }
}

struct ImageStartModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaleEffect(1.0)
            .opacity(1.0)
            .animation(.easeInOut(duration: 2.0))
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
