//
//  UIAlertController.swift
//  Booking Application
//
//  Created by student on 4.05.21.
//

import SwiftUI

// MARK: -> Extensitons For Hide Elements

/*
 Hide or show the view based on a boolean value.
 
 Example for visibility:
 Text("Label").isHidden(true)
 
 Example for complete removal:
 Text("Label").isHidden(true, remove: true)
 
 - Parameters:
 - hidden: Set to `false` to show the view. Set to `true` to hide the view.
 - remove: Boolean value indicating whether or not to remove the view.
 */

extension Text {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}

extension Image {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}

extension Spacer {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}

extension Button {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}

extension SearchBarView {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
