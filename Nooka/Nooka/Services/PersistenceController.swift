//
//  PersistenceController.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample stamps for preview
        let sampleTitles = [
            "Morning Coffee ☕️",
            "Sunset Walk 🌅",
            "Cozy Reading 📚",
            "Garden Blooms 🌸",
            "Rainy Day 🌧️",
            "Beach Day 🏖️",
            "Mountain Hike ⛰️",
            "City Lights 🌃"
        ]
        
        let sampleNotes = [
            "Started the day with a perfect cup of coffee",
            "Beautiful colors in the sky tonight",
            "Lost in a good book",
            "The flowers are finally blooming!",
            "Perfect weather for staying in",
            "Waves and sunshine",
            "Reached the summit!",
            "The city looks magical at night"
        ]
        
        for i in 0..<8 {
            let stamp = StampEntry(context: viewContext)
            stamp.id = UUID()
            stamp.date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            stamp.title = sampleTitles[i]
            stamp.note = sampleNotes[i]
            stamp.photoData = createPlaceholderImage(color: randomColor()).jpegData(compressionQuality: 0.8) ?? Data()
            stamp.rotationAngle = Double.random(in: -0.1...0.1)
            stamp.offsetX = Double.random(in: -10...10)
            stamp.offsetY = Double.random(in: -10...10)
            stamp.createdAt = stamp.date
            stamp.updatedAt = stamp.date
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Nooka")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - CRUD Operations
    
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func fetchStamp(for date: Date) -> StampEntry? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<StampEntry> = StampEntry.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching stamp for date: \(error)")
            return nil
        }
    }
    
    func fetchAllStamps() -> [StampEntry] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<StampEntry> = StampEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \StampEntry.date, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching all stamps: \(error)")
            return []
        }
    }
    
    func createStamp(date: Date, photoData: Data, title: String, note: String?) -> StampEntry {
        let context = container.viewContext
        let stamp = StampEntry(context: context)
        
        stamp.id = UUID()
        stamp.date = date
        stamp.photoData = photoData
        stamp.title = title
        stamp.note = note
        stamp.rotationAngle = Double.random(in: -0.08...0.08)
        stamp.offsetX = Double.random(in: -8...8)
        stamp.offsetY = Double.random(in: -8...8)
        stamp.createdAt = Date()
        stamp.updatedAt = Date()
        
        saveContext()
        return stamp
    }
    
    func updateStamp(_ stamp: StampEntry, photoData: Data? = nil, title: String? = nil, note: String? = nil) {
        if let photoData = photoData {
            stamp.photoData = photoData
        }
        if let title = title {
            stamp.title = title
        }
        if let note = note {
            stamp.note = note
        }
        
        stamp.updatedAt = Date()
        saveContext()
    }
    
    func deleteStamp(_ stamp: StampEntry) {
        let context = container.viewContext
        context.delete(stamp)
        saveContext()
    }
    
    // MARK: - Helper Methods
    
    private static func createPlaceholderImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 300, height: 300)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Add a simple pattern
            UIColor.white.withAlphaComponent(0.3).setFill()
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 100, y: 100, width: 100, height: 100))
            circlePath.fill()
        }
    }
    
    private static func randomColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1.0), // warm beige
            UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0), // tan
            UIColor(red: 0.75, green: 0.65, blue: 0.55, alpha: 1.0), // brown
            UIColor(red: 0.95, green: 0.90, blue: 0.80, alpha: 1.0), // cream
            UIColor(red: 0.90, green: 0.80, blue: 0.70, alpha: 1.0), // sand
        ]
        return colors.randomElement() ?? colors[0]
    }
}
