//
//  PullToRefresh.swift
//  Booking Application
//
//  Created by student on 7.05.21.
//

import SwiftUI

struct PullToRefresh: View {
    @State private var needRefresh: Bool = false
    
    var coordinateSpaceName: String
    var onRefresh: () ->Void
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    VStack(alignment: .center) {
                        Text("Pull to update")
                        Image("Arrow Down")
                    }
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}
