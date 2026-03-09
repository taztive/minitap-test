//
//  Stamp.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import Foundation
import SwiftUI

struct Stamp: Identifiable {
    let id: UUID
    let date: Date
    let photo: UIImage
    let title: String
    let note: String?
    let rotationAngle: Double
    let offsetX: Double
    let offsetY: Double
    let createdAt: Date
    let updatedAt: Date
    
    init(from entry: StampEntry) {
        self.id = entry.id
        self.date = entry.date
        self.photo = UIImage(data: entry.photoData) ?? UIImage()
        self.title = entry.title
        self.note = entry.note
        self.rotationAngle = entry.rotationAngle
        self.offsetX = entry.offsetX
        self.offsetY = entry.offsetY
        self.createdAt = entry.createdAt
        self.updatedAt = entry.updatedAt
    }
}
