//
//  SectionSeparatorView.swift
//  Booking Application
//
//  Created by student on 23.04.21.
//

import SwiftUI

// MARK: -> Section For View All Elements Of List

struct SectionSeparatorView: View {
    var title: String
    var onClick: () -> Void
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .padding(.leading, 16)
            Spacer()
            Button {
                self.onClick()
            } label: {
                HStack(alignment: .center) {
                    Text("See all")
                        .font(.system(size: 18, weight: .regular))
                    Image("Arrow")
                }
            }
            .padding(.trailing, 16)
        }
        .padding(.bottom, 9)
    }
    
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionSeparatorView(title: "Category", onClick: {})
    }
    
}
