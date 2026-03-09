//
//  SettingsView.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.nookaBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Spacing.lg) {
                    Text("Settings")
                        .nookaTitle()
                        .looseKerning()
                        .padding(.top, Spacing.xl)
                    
                    List {
                        Section {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.nookaAccent)
                                Text("Notifications")
                                    .nookaBody()
                            }
                            
                            HStack {
                                Image(systemName: "paintbrush")
                                    .foregroundColor(.nookaAccent)
                                Text("Appearance")
                                    .nookaBody()
                            }
                        }
                        
                        Section {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.nookaAccent)
                                Text("About")
                                    .nookaBody()
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.nookaBackground)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingsView()
}
