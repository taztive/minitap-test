# Nooka - Stamp Diary iOS App

A warm, encouraging native iOS app for creating one postage-stamp-style visual entry per day.

## Overview

Nooka is a daily diary app that allows users to capture their day with a photo, title, and optional note. Each entry appears as a beautiful stamp on a calendar grid, creating a visual timeline of memories.

## Features

- **One Stamp Per Day**: Create a single visual entry for each day
- **Photo Integration**: Add photos from camera or photo library
- **Warm Design**: Cozy aesthetic with beige tones and rounded typography
- **Core Data Persistence**: All entries saved locally and securely
- **Calendar View**: Browse your stamp collection in a grid layout

## Technical Stack

- **Platform**: iOS 16.0+
- **Framework**: SwiftUI
- **Architecture**: MVVM
- **Persistence**: Core Data
- **Language**: Swift 5.0

## Project Structure

```
Nooka/
├── App/                    # App entry point
├── Models/                 # Core Data models
├── ViewModels/            # Business logic
├── Views/                 # SwiftUI views
│   ├── Calendar/          # Calendar grid view
│   ├── StampCreation/     # Stamp creation flow
│   ├── StampDetail/       # Detail view
│   └── Components/        # Reusable UI components
├── Services/              # Data services
├── Design/                # Design system
│   ├── Colors.swift       # Color palette
│   ├── Typography.swift   # Font styles
│   ├── Spacing.swift      # Layout constants
│   └── DesignSystem.swift # Shadows and effects
├── Resources/             # Assets and Core Data model
└── Utilities/             # Extensions and helpers
```

## Design System

### Colors
- **Background**: Warm beige (#F5F1E8)
- **Card Background**: Cream (#FFF9F0)
- **Accent**: Warm tan (#D4A574)
- **Text**: Soft dark brown (#4A4238)

### Typography
- Rounded sans-serif design
- Loose kerning for relaxed feel
- Generous spacing for airy layout

### Components
- **NookaCard**: Container with soft shadows
- **NookaButton**: Primary, secondary, and outline styles

## Core Data Model

### StampEntry Entity
- `id`: UUID (unique identifier)
- `date`: Date (the day this stamp represents)
- `photoData`: Binary Data (compressed image)
- `title`: String (short title)
- `note`: String? (optional note)
- `rotationAngle`: Double (tactile placement)
- `offsetX`: Double (horizontal offset)
- `offsetY`: Double (vertical offset)
- `createdAt`: Date (creation timestamp)
- `updatedAt`: Date (last update timestamp)

## Getting Started

1. Open `Nooka.xcodeproj` in Xcode
2. Select your development team in project settings
3. Build and run on iOS Simulator or device

## Requirements

- Xcode 15.0+
- iOS 16.0+
- Swift 5.0+

## License

Copyright © 2024 Nooka. All rights reserved.
