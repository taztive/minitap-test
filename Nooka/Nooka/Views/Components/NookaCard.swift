//
//  NookaCard.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct NookaCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Spacing.cardPadding)
            .background(Color.nookaCardBackground)
            .cornerRadius(Spacing.cornerRadius)
            .nookaCardShadow()
    }
}

#Preview {
    ZStack {
        Color.nookaBackground
            .ignoresSafeArea()
        
        NookaCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Card Title")
                    .nookaHeadline()
                
                Text("This is a sample card with some content inside. It uses the Nooka design system for consistent styling.")
                    .nookaBody()
            }
        }
        .padding(Spacing.screenPadding)
    }
}
