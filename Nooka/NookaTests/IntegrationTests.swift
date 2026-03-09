//
//  IntegrationTests.swift
//  NookaTests
//
//  Created by Nooka on 2024.
//
//  Integration tests that verify the interaction between ViewModels and Core Data persistence.
//

import XCTest
import CoreData
import Combine
@testable import Nooka

final class IntegrationTests: XCTestCase {
    var persistenceController: PersistenceController!
    var calendarViewModel: CalendarViewModel!
    var stampCreationViewModel: StampCreationViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        calendarViewModel = CalendarViewModel(persistenceController: persistenceController)
        stampCreationViewModel = StampCreationViewModel(persistenceController: persistenceController)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        stampCreationViewModel = nil
        calendarViewModel = nil
        persistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Create and View Flow
    
    func testCreateStampFlow_CreatedStampAppearsInCalendar() {
        // Arrange
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Integration Test Stamp"
        stampCreationViewModel.note = "Testing the full flow"
        let testDate = Date()
        stampCreationViewModel.selectedDate = testDate
        
        // Act - Create stamp
        let createSuccess = stampCreationViewModel.createStamp()
        
        // Reload calendar
        calendarViewModel.loadStamps()
        
        // Assert
        XCTAssertTrue(createSuccess)
        XCTAssertEqual(calendarViewModel.stamps.count, 1)
        XCTAssertEqual(calendarViewModel.stamps[0].title, "Integration Test Stamp")
        XCTAssertEqual(calendarViewModel.stamps[0].note, "Testing the full flow")
        
        // Verify we can fetch it by date
        let fetchedStamp = calendarViewModel.stamp(for: testDate)
        XCTAssertNotNil(fetchedStamp)
        XCTAssertEqual(fetchedStamp?.title, "Integration Test Stamp")
    }
    
    func testCreateMultipleStamps_AllAppearInCalendarSorted() {
        // Arrange
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        let dates = [yesterday, today, twoDaysAgo] // Create in non-sorted order
        let titles = ["Yesterday", "Today", "Two Days Ago"]
        
        // Act - Create stamps in random order
        for (index, date) in dates.enumerated() {
            stampCreationViewModel.selectedImage = createTestImage()
            stampCreationViewModel.title = titles[index]
            stampCreationViewModel.selectedDate = date
            _ = stampCreationViewModel.createStamp()
        }
        
        calendarViewModel.loadStamps()
        
        // Assert - Should be sorted by date descending (newest first)
        XCTAssertEqual(calendarViewModel.stamps.count, 3)
        XCTAssertEqual(calendarViewModel.stamps[0].title, "Today")
        XCTAssertEqual(calendarViewModel.stamps[1].title, "Yesterday")
        XCTAssertEqual(calendarViewModel.stamps[2].title, "Two Days Ago")
    }
    
    // MARK: - Delete Flow
    
    func testDeleteStampFlow_StampRemovedFromCalendar() {
        // Arrange - Create a stamp
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "To Be Deleted"
        _ = stampCreationViewModel.createStamp()
        
        calendarViewModel.loadStamps()
        XCTAssertEqual(calendarViewModel.stamps.count, 1)
        
        let stampToDelete = calendarViewModel.stamps[0]
        
        // Act - Delete the stamp
        calendarViewModel.deleteStamp(stampToDelete)
        
        // Assert
        XCTAssertTrue(calendarViewModel.stamps.isEmpty)
        
        // Verify it's also gone from persistence
        let allStamps = persistenceController.fetchAllStamps()
        XCTAssertTrue(allStamps.isEmpty)
    }
    
    func testDeleteOneOfMultipleStamps_OnlyDeletedStampRemoved() {
        // Arrange - Create multiple stamps
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Keep This"
        stampCreationViewModel.selectedDate = today
        _ = stampCreationViewModel.createStamp()
        
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Delete This"
        stampCreationViewModel.selectedDate = yesterday
        _ = stampCreationViewModel.createStamp()
        
        calendarViewModel.loadStamps()
        XCTAssertEqual(calendarViewModel.stamps.count, 2)
        
        // Find the stamp to delete
        let stampToDelete = calendarViewModel.stamps.first { $0.title == "Delete This" }!
        
        // Act
        calendarViewModel.deleteStamp(stampToDelete)
        
        // Assert
        XCTAssertEqual(calendarViewModel.stamps.count, 1)
        XCTAssertEqual(calendarViewModel.stamps[0].title, "Keep This")
    }
    
    // MARK: - Update Flow
    
    func testUpdateStampFlow_ChangesReflectedInCalendar() {
        // Arrange - Create a stamp
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Original Title"
        stampCreationViewModel.note = "Original Note"
        _ = stampCreationViewModel.createStamp()
        
        calendarViewModel.loadStamps()
        let stamp = calendarViewModel.stamps[0]
        
        // Act - Update the stamp directly through persistence
        persistenceController.updateStamp(stamp, title: "Updated Title", note: "Updated Note")
        
        // Reload calendar
        calendarViewModel.loadStamps()
        
        // Assert
        XCTAssertEqual(calendarViewModel.stamps[0].title, "Updated Title")
        XCTAssertEqual(calendarViewModel.stamps[0].note, "Updated Note")
    }
    
    // MARK: - Date-based Queries
    
    func testFetchStampByDate_WithMultipleStamps_ReturnsCorrectStamp() {
        // Arrange - Create stamps on different dates
        let dates = (0..<7).map { dayOffset in
            Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date())!
        }
        
        for (index, date) in dates.enumerated() {
            stampCreationViewModel.selectedImage = createTestImage()
            stampCreationViewModel.title = "Day \(index)"
            stampCreationViewModel.selectedDate = date
            _ = stampCreationViewModel.createStamp()
        }
        
        // Act - Fetch stamp for specific date
        let targetDate = dates[3]
        let fetchedStamp = calendarViewModel.stamp(for: targetDate)
        
        // Assert
        XCTAssertNotNil(fetchedStamp)
        XCTAssertEqual(fetchedStamp?.title, "Day 3")
    }
    
    func testFetchStampByDate_SameDayDifferentTime_ReturnsStamp() {
        // Arrange - Create stamp at specific time
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 9
        components.minute = 0
        let morningDate = calendar.date(from: components)!
        
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Morning Stamp"
        stampCreationViewModel.selectedDate = morningDate
        _ = stampCreationViewModel.createStamp()
        
        // Act - Fetch with different time on same day
        components.hour = 18
        components.minute = 30
        let eveningDate = calendar.date(from: components)!
        let fetchedStamp = calendarViewModel.stamp(for: eveningDate)
        
        // Assert - Should find the stamp because it's the same day
        XCTAssertNotNil(fetchedStamp)
        XCTAssertEqual(fetchedStamp?.title, "Morning Stamp")
    }
    
    // MARK: - Data Persistence
    
    func testDataPersistence_StampsPersistedAcrossViewModelInstances() {
        // Arrange - Create stamps with first view model
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Persisted Stamp"
        _ = stampCreationViewModel.createStamp()
        
        // Act - Create new view model instances
        let newCalendarViewModel = CalendarViewModel(persistenceController: persistenceController)
        
        // Assert - New view model should see the stamp
        XCTAssertEqual(newCalendarViewModel.stamps.count, 1)
        XCTAssertEqual(newCalendarViewModel.stamps[0].title, "Persisted Stamp")
    }
    
    func testDataPersistence_DeletedStampsNotVisibleInNewViewModels() {
        // Arrange - Create and delete a stamp
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Temporary Stamp"
        _ = stampCreationViewModel.createStamp()
        
        calendarViewModel.loadStamps()
        let stamp = calendarViewModel.stamps[0]
        calendarViewModel.deleteStamp(stamp)
        
        // Act - Create new view model
        let newCalendarViewModel = CalendarViewModel(persistenceController: persistenceController)
        
        // Assert
        XCTAssertTrue(newCalendarViewModel.stamps.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    func testCreateStampOnSameDate_BothStampsExist() {
        // Arrange
        let date = Date()
        
        // Act - Create two stamps on the same date
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "First Stamp"
        stampCreationViewModel.selectedDate = date
        _ = stampCreationViewModel.createStamp()
        
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Second Stamp"
        stampCreationViewModel.selectedDate = date
        _ = stampCreationViewModel.createStamp()
        
        calendarViewModel.loadStamps()
        
        // Assert - Both stamps should exist
        XCTAssertEqual(calendarViewModel.stamps.count, 2)
        
        // Note: fetchStamp(for:) returns only one stamp per date (first match)
        // This documents current behavior - app may want to enforce one stamp per day
        let fetchedStamp = calendarViewModel.stamp(for: date)
        XCTAssertNotNil(fetchedStamp)
    }
    
    func testEmptyDatabase_CalendarViewModelHandlesGracefully() {
        // Arrange - Empty database (no stamps created)
        
        // Act
        calendarViewModel.loadStamps()
        
        // Assert
        XCTAssertTrue(calendarViewModel.stamps.isEmpty)
        XCTAssertNil(calendarViewModel.stamp(for: Date()))
    }
    
    func testLargeDataSet_PerformanceIsAcceptable() {
        // Arrange - Create many stamps
        let numberOfStamps = 100
        
        // Act
        measure {
            for i in 0..<numberOfStamps {
                let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                stampCreationViewModel.selectedImage = createTestImage()
                stampCreationViewModel.title = "Stamp \(i)"
                stampCreationViewModel.selectedDate = date
                _ = stampCreationViewModel.createStamp()
            }
            
            calendarViewModel.loadStamps()
        }
        
        // Assert
        XCTAssertEqual(calendarViewModel.stamps.count, numberOfStamps)
    }
    
    // MARK: - Reactive Updates
    
    func testPublishedProperties_UpdatesReflectedInSubscribers() {
        // Arrange
        let expectation = XCTestExpectation(description: "Calendar stamps updated")
        
        calendarViewModel.$stamps
            .dropFirst() // Skip initial empty value
            .sink { stamps in
                if stamps.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        stampCreationViewModel.selectedImage = createTestImage()
        stampCreationViewModel.title = "Reactive Test"
        _ = stampCreationViewModel.createStamp()
        calendarViewModel.loadStamps()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
