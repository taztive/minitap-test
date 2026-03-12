//
//  Spacing.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import Foundation

enum Spacing {
    // MARK: - Base Spacing Scale
    
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    // MARK: - Semantic Spacing (Generous for Airy Feel)
    
    static let cardPadding: CGFloat = 20
    static let screenPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 32
    static let itemSpacing: CGFloat = 16
    
    // MARK: - Component-Specific Spacing
    
    static let buttonPaddingHorizontal: CGFloat = 24
    static let buttonPaddingVertical: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 20
}
