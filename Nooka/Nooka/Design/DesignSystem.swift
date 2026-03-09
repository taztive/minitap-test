//
//  DesignSystem.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct DesignSystem {
    // MARK: - Shadow Styles
    
    static let cardShadow = Shadow(
        color: Color.black.opacity(0.05),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let softShadow = Shadow(
        color: Color.black.opacity(0.08),
        radius: 12,
        x: 0,
        y: 6
    )
    
    static let strongShadow = Shadow(
        color: Color.black.opacity(0.12),
        radius: 16,
        x: 0,
        y: 8
    )
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

extension View {
    // MARK: - Shadow Modifiers
    
    func nookaCardShadow() -> some View {
        self.shadow(
            color: DesignSystem.cardShadow.color,
            radius: DesignSystem.cardShadow.radius,
            x: DesignSystem.cardShadow.x,
            y: DesignSystem.cardShadow.y
        )
    }
    
    func nookaSoftShadow() -> some View {
        self.shadow(
            color: DesignSystem.softShadow.color,
            radius: DesignSystem.softShadow.radius,
            x: DesignSystem.softShadow.x,
            y: DesignSystem.softShadow.y
        )
    }
    
    func nookaStrongShadow() -> some View {
        self.shadow(
            color: DesignSystem.strongShadow.color,
            radius: DesignSystem.strongShadow.radius,
            x: DesignSystem.strongShadow.x,
            y: DesignSystem.strongShadow.y
        )
    }
}
