//
//  LoadingView.swift
//  Booking Application
//
//  Created by student on 3.05.21.
//

import SwiftUI

struct LoadingView: UIViewRepresentable {
    var isAnimating: Bool
    typealias UIView = UIActivityIndicatorView
    var configuration = { (indicator: UIView) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
    
}

//extension View where Self == LoadingView {
//    
//    func configure(_ configuration: @escaping (Self.UIView) -> Void) -> Self {
//        Self.init(isAnimating: self.isAnimating, configuration: configuration)
//    }
//    
//}
