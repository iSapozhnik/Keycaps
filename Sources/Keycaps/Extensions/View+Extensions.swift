//
//  File.swift
//  Keycaps
//
//  Created by Ivan Sapozhnik on 18.01.25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

