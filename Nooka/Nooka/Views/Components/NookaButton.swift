//
//  NookaButton.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct NookaButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.nookaHeadline)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, Spacing.buttonPaddingHorizontal)
                .padding(.vertical, Spacing.buttonPaddingVertical)
                .background(backgroundColor)
                .cornerRadius(Spacing.smallCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.smallCornerRadius)
                        .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
                )
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .nookaAccent
        case .secondary:
            return .nookaWarmGray
        case .outline:
            return .clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .nookaText
        case .outline:
            return .nookaAccent
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline:
            return .nookaAccent
        default:
            return .clear
        }
    }
}

#Preview {
    ZStack {
        Color.nookaBackground
            .ignoresSafeArea()
        
        VStack(spacing: Spacing.lg) {
            NookaButton(title: "Primary Button", action: {})
            
            NookaButton(title: "Secondary Button", action: {}, style: .secondary)
            
            NookaButton(title: "Outline Button", action: {}, style: .outline)
        }
        .padding(Spacing.screenPadding)
    }
}
