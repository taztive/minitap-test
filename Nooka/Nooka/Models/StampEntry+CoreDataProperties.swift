//
//  StampEntry+CoreDataProperties.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import Foundation
import CoreData

extension StampEntry {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StampEntry> {
        return NSFetchRequest<StampEntry>(entityName: "StampEntry")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var photoData: Data
    @NSManaged public var title: String
    @NSManaged public var note: String?
    @NSManaged public var rotationAngle: Double
    @NSManaged public var offsetX: Double
    @NSManaged public var offsetY: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    
}

extension StampEntry: Identifiable {
    
}
