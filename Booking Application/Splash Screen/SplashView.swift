//
//  SplashView.swift
//  Booking Application
//
//  Created by student on 14.04.21.
//

import SwiftUI

struct SplashView: View {
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
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
        SplashView()
    }
}
