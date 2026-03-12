//
//  CalendarView.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StampEntry.date, ascending: false)],
        animation: .default)
    private var stamps: FetchedResults<StampEntry>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.nookaBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Spacing.lg) {
                    Text("Your Stamp Diary")
                        .nookaTitle()
                        .looseKerning()
                        .padding(.top, Spacing.xl)
                    
                    if stamps.isEmpty {
                        VStack(spacing: Spacing.md) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(.nookaAccent)
                                .padding(.bottom, Spacing.sm)
                            
                            Text("No stamps yet")
                                .nookaHeadline()
                            
                            Text("Create your first stamp to get started!")
                                .nookaCaption()
                                .multilineTextAlignment(.center)
                        }
                        .padding(Spacing.xl)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: Spacing.md) {
                                ForEach(stamps) { stamp in
                                    StampPreviewCard(stamp: stamp)
                                }
                            }
                            .padding(Spacing.screenPadding)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StampPreviewCard: View {
    let stamp: StampEntry
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            if let image = UIImage(data: stamp.photoData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.smallCornerRadius))
                    .rotationEffect(.radians(stamp.rotationAngle))
            }
            
            Text(stamp.title)
                .nookaCaption()
                .lineLimit(1)
        }
        .padding(Spacing.sm)
        .background(Color.nookaCardBackground)
        .cornerRadius(Spacing.cornerRadius)
        .nookaCardShadow()
    }
}

#Preview {
    CalendarView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
