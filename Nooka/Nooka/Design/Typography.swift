//
//  Typography.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

extension Font {
    // MARK: - Nooka Typography (Rounded Sans-Serif)
    
    static let nookaTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let nookaHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let nookaBody = Font.system(size: 16, weight: .regular, design: .rounded)
    static let nookaCaption = Font.system(size: 14, weight: .regular, design: .rounded)
    static let nookaSmall = Font.system(size: 12, weight: .regular, design: .rounded)
    
    // MARK: - Large Display Fonts
    
    static let nookaLargeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let nookaSubtitle = Font.system(size: 18, weight: .medium, design: .rounded)
}

extension View {
    // MARK: - Typography Modifiers
    
    func nookaTitle() -> some View {
        self.font(.nookaTitle)
            .foregroundColor(.nookaText)
    }
    
    func nookaHeadline() -> some View {
        self.font(.nookaHeadline)
            .foregroundColor(.nookaText)
    }
    
    func nookaBody() -> some View {
        self.font(.nookaBody)
            .foregroundColor(.nookaText)
    }
    
    func nookaCaption() -> some View {
        self.font(.nookaCaption)
            .foregroundColor(.nookaTextSecondary)
    }
    
    func nookaSmall() -> some View {
        self.font(.nookaSmall)
            .foregroundColor(.nookaTextSecondary)
    }
    
    // Loose kerning for relaxed feel
    func looseKerning() -> some View {
        self.kerning(0.5)
    }
}
