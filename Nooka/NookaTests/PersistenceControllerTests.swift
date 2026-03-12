//
//  PersistenceControllerTests.swift
//  NookaTests
//
//  Created by Nooka on 2024.
//

import XCTest
import CoreData
@testable import Nooka

final class PersistenceControllerTests: XCTestCase {
    var persistenceController: PersistenceController!
    
    override func setUp() {
        super.setUp()
        // Use in-memory store for testing
        persistenceController = PersistenceController(inMemory: true)
    }
    
    override func tearDown() {
        persistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testCreateStamp_WithValidData_CreatesStampSuccessfully() {
        // Arrange
        let date = Date()
        let title = "Test Stamp"
        let note = "Test note"
        let imageData = createTestImageData()
        
        // Act
        let stamp = persistenceController.createStamp(
            date: date,
            photoData: imageData,
            title: title,
            note: note
        )
        
        // Assert
        XCTAssertNotNil(stamp.id)
        XCTAssertEqual(stamp.title, title)
        XCTAssertEqual(stamp.note, note)
        XCTAssertEqual(stamp.photoData, imageData)
        XCTAssertTrue(Calendar.current.isDate(stamp.date, inSameDayAs: date))
        XCTAssertNotNil(stamp.createdAt)
        XCTAssertNotNil(stamp.updatedAt)
    }
    
    func testCreateStamp_SetsRandomRotationAndOffset() {
        // Arrange
        let imageData = createTestImageData()
        
        // Act
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Test",
            note: nil
        )
        
        // Assert
        XCTAssertTrue(stamp.rotationAngle >= -0.08 && stamp.rotationAngle <= 0.08)
        XCTAssertTrue(stamp.offsetX >= -8 && stamp.offsetX <= 8)
        XCTAssertTrue(stamp.offsetY >= -8 && stamp.offsetY <= 8)
    }
    
    func testCreateStamp_WithNilNote_CreatesStampWithoutNote() {
        // Arrange
        let imageData = createTestImageData()
        
        // Act
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Test",
            note: nil
        )
        
        // Assert
        XCTAssertNil(stamp.note)
    }
    
    // MARK: - Fetch Tests
    
    func testFetchStamp_ForExistingDate_ReturnsStamp() {
        // Arrange
        let date = Date()
        let imageData = createTestImageData()
        let createdStamp = persistenceController.createStamp(
            date: date,
            photoData: imageData,
            title: "Test Stamp",
            note: "Test note"
        )
        
        // Act
        let fetchedStamp = persistenceController.fetchStamp(for: date)
        
        // Assert
        XCTAssertNotNil(fetchedStamp)
        XCTAssertEqual(fetchedStamp?.id, createdStamp.id)
        XCTAssertEqual(fetchedStamp?.title, "Test Stamp")
    }
    
    func testFetchStamp_ForNonExistingDate_ReturnsNil() {
        // Arrange
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        // Act
        let fetchedStamp = persistenceController.fetchStamp(for: futureDate)
        
        // Assert
        XCTAssertNil(fetchedStamp)
    }
    
    func testFetchStamp_WithMultipleStampsOnDifferentDays_ReturnCorrectStamp() {
        // Arrange
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let imageData = createTestImageData()
        
        let todayStamp = persistenceController.createStamp(
            date: today,
            photoData: imageData,
            title: "Today",
            note: nil
        )
        
        _ = persistenceController.createStamp(
            date: yesterday,
            photoData: imageData,
            title: "Yesterday",
            note: nil
        )
        
        // Act
        let fetchedStamp = persistenceController.fetchStamp(for: today)
        
        // Assert
        XCTAssertEqual(fetchedStamp?.id, todayStamp.id)
        XCTAssertEqual(fetchedStamp?.title, "Today")
    }
    
    func testFetchAllStamps_WithNoStamps_ReturnsEmptyArray() {
        // Act
        let stamps = persistenceController.fetchAllStamps()
        
        // Assert
        XCTAssertTrue(stamps.isEmpty)
    }
    
    func testFetchAllStamps_WithMultipleStamps_ReturnsAllStampsSortedByDate() {
        // Arrange
        let imageData = createTestImageData()
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        _ = persistenceController.createStamp(date: yesterday, photoData: imageData, title: "Yesterday", note: nil)
        _ = persistenceController.createStamp(date: today, photoData: imageData, title: "Today", note: nil)
        _ = persistenceController.createStamp(date: twoDaysAgo, photoData: imageData, title: "Two days ago", note: nil)
        
        // Act
        let stamps = persistenceController.fetchAllStamps()
        
        // Assert
        XCTAssertEqual(stamps.count, 3)
        // Should be sorted by date descending (newest first)
        XCTAssertEqual(stamps[0].title, "Today")
        XCTAssertEqual(stamps[1].title, "Yesterday")
        XCTAssertEqual(stamps[2].title, "Two days ago")
    }
    
    // MARK: - Update Tests
    
    func testUpdateStamp_WithNewTitle_UpdatesTitleAndTimestamp() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Original Title",
            note: nil
        )
        let originalUpdatedAt = stamp.updatedAt
        
        // Wait a tiny bit to ensure timestamp changes
        Thread.sleep(forTimeInterval: 0.01)
        
        // Act
        persistenceController.updateStamp(stamp, title: "Updated Title")
        
        // Assert
        XCTAssertEqual(stamp.title, "Updated Title")
        XCTAssertNotEqual(stamp.updatedAt, originalUpdatedAt)
    }
    
    func testUpdateStamp_WithNewNote_UpdatesNoteOnly() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Title",
            note: "Original note"
        )
        
        // Act
        persistenceController.updateStamp(stamp, note: "Updated note")
        
        // Assert
        XCTAssertEqual(stamp.note, "Updated note")
        XCTAssertEqual(stamp.title, "Title") // Title unchanged
    }
    
    func testUpdateStamp_WithNewPhotoData_UpdatesPhotoDataOnly() {
        // Arrange
        let originalImageData = createTestImageData()
        let newImageData = createTestImageData(color: .blue)
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: originalImageData,
            title: "Title",
            note: nil
        )
        
        // Act
        persistenceController.updateStamp(stamp, photoData: newImageData)
        
        // Assert
        XCTAssertEqual(stamp.photoData, newImageData)
        XCTAssertNotEqual(stamp.photoData, originalImageData)
    }
    
    func testUpdateStamp_WithMultipleFields_UpdatesAllFields() {
        // Arrange
        let imageData = createTestImageData()
        let newImageData = createTestImageData(color: .green)
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Original",
            note: "Original note"
        )
        
        // Act
        persistenceController.updateStamp(
            stamp,
            photoData: newImageData,
            title: "Updated",
            note: "Updated note"
        )
        
        // Assert
        XCTAssertEqual(stamp.photoData, newImageData)
        XCTAssertEqual(stamp.title, "Updated")
        XCTAssertEqual(stamp.note, "Updated note")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteStamp_RemovesStampFromStore() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "To Delete",
            note: nil
        )
        let stampId = stamp.id
        
        // Act
        persistenceController.deleteStamp(stamp)
        
        // Assert
        let allStamps = persistenceController.fetchAllStamps()
        XCTAssertTrue(allStamps.isEmpty)
        XCTAssertNil(allStamps.first { $0.id == stampId })
    }
    
    func testDeleteStamp_WithMultipleStamps_DeletesOnlySpecifiedStamp() {
        // Arrange
        let imageData = createTestImageData()
        let stamp1 = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Keep", note: nil)
        let stamp2 = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Delete", note: nil)
        
        // Act
        persistenceController.deleteStamp(stamp2)
        
        // Assert
        let allStamps = persistenceController.fetchAllStamps()
        XCTAssertEqual(allStamps.count, 1)
        XCTAssertEqual(allStamps[0].id, stamp1.id)
    }
    
    // MARK: - Save Context Tests
    
    func testSaveContext_WithNoChanges_DoesNotThrowError() {
        // Act & Assert
        XCTAssertNoThrow(persistenceController.saveContext())
    }
    
    func testSaveContext_WithChanges_SavesSuccessfully() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Test",
            note: nil
        )
        
        // Modify the stamp
        stamp.title = "Modified"
        
        // Act
        persistenceController.saveContext()
        
        // Assert
        let fetchedStamp = persistenceController.fetchStamp(for: stamp.date)
        XCTAssertEqual(fetchedStamp?.title, "Modified")
    }
    
    // MARK: - Helper Methods
    
    private func createTestImageData(color: UIColor = .red) -> Data {
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image.jpegData(compressionQuality: 0.8) ?? Data()
    }
}
