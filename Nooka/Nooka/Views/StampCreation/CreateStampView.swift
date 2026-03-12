//
//  CreateStampView.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct CreateStampView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.nookaBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    Text("Create a Stamp")
                        .nookaTitle()
                        .looseKerning()
                        .padding(.top, Spacing.xl)
                    
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 80))
                        .foregroundColor(.nookaAccent)
                    
                    Text("Capture today's moment")
                        .nookaHeadline()
                    
                    Text("Add a photo and title to create your daily stamp")
                        .nookaCaption()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CreateStampView()
}
