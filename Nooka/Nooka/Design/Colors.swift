//
//  Colors.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

extension Color {
    // MARK: - Primary Palette (Warm, Soft, Encouraging)
    
    static let nookaBeige = Color(hex: "#F5F1E8")
    static let nookaCream = Color(hex: "#FFF9F0")
    static let nookaWarmGray = Color(hex: "#E8E3D8")
    static let nookaAccent = Color(hex: "#D4A574")
    static let nookaText = Color(hex: "#4A4238")
    static let nookaTextSecondary = Color(hex: "#8B7E6A")
    
    // MARK: - Semantic Colors
    
    static let nookaBackground = nookaBeige
    static let nookaCardBackground = nookaCream
    static let nookaBorder = nookaWarmGray
    
    // MARK: - Helper for Hex Colors
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
