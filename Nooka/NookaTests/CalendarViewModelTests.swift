//
//  CalendarViewModelTests.swift
//  NookaTests
//
//  Created by Nooka on 2024.
//

import XCTest
import CoreData
import Combine
@testable import Nooka

final class CalendarViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var viewModel: CalendarViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        viewModel = CalendarViewModel(persistenceController: persistenceController)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        persistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInit_LoadsStampsAutomatically() {
        // Arrange
        let imageData = createTestImageData()
        _ = persistenceController.createStamp(
            date: Date(),
            photoData: imageData,
            title: "Test Stamp",
            note: nil
        )
        
        // Act
        let newViewModel = CalendarViewModel(persistenceController: persistenceController)
        
        // Assert
        XCTAssertEqual(newViewModel.stamps.count, 1)
        XCTAssertEqual(newViewModel.stamps[0].title, "Test Stamp")
    }
    
    func testInit_SetsSelectedDateToToday() {
        // Act
        let today = Date()
        
        // Assert
        XCTAssertTrue(Calendar.current.isDate(viewModel.selectedDate, inSameDayAs: today))
    }
    
    func testInit_WithNoStamps_LoadsEmptyArray() {
        // Assert
        XCTAssertTrue(viewModel.stamps.isEmpty)
    }
    
    // MARK: - loadStamps Tests
    
    func testLoadStamps_WithMultipleStamps_LoadsAllStamps() {
        // Arrange
        let imageData = createTestImageData()
        _ = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Stamp 1", note: nil)
        _ = persistenceController.createStamp(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            photoData: imageData,
            title: "Stamp 2",
            note: nil
        )
        _ = persistenceController.createStamp(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            photoData: imageData,
            title: "Stamp 3",
            note: nil
        )
        
        // Act
        viewModel.loadStamps()
        
        // Assert
        XCTAssertEqual(viewModel.stamps.count, 3)
    }
    
    func testLoadStamps_UpdatesPublishedProperty() {
        // Arrange
        let expectation = XCTestExpectation(description: "Stamps published")
        let imageData = createTestImageData()
        
        viewModel.$stamps
            .dropFirst() // Skip initial value
            .sink { stamps in
                if stamps.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        _ = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Test", note: nil)
        viewModel.loadStamps()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.stamps.count, 1)
    }
    
    func testLoadStamps_AfterDeletion_UpdatesStampsList() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Test", note: nil)
        viewModel.loadStamps()
        XCTAssertEqual(viewModel.stamps.count, 1)
        
        // Act
        persistenceController.deleteStamp(stamp)
        viewModel.loadStamps()
        
        // Assert
        XCTAssertTrue(viewModel.stamps.isEmpty)
    }
    
    // MARK: - stamp(for:) Tests
    
    func testStampForDate_WithExistingStamp_ReturnsStamp() {
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
        let fetchedStamp = viewModel.stamp(for: date)
        
        // Assert
        XCTAssertNotNil(fetchedStamp)
        XCTAssertEqual(fetchedStamp?.id, createdStamp.id)
        XCTAssertEqual(fetchedStamp?.title, "Test Stamp")
    }
    
    func testStampForDate_WithNonExistingStamp_ReturnsNil() {
        // Arrange
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        // Act
        let fetchedStamp = viewModel.stamp(for: futureDate)
        
        // Assert
        XCTAssertNil(fetchedStamp)
    }
    
    func testStampForDate_WithMultipleStamps_ReturnsCorrectStamp() {
        // Arrange
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let imageData = createTestImageData()
        
        let todayStamp = persistenceController.createStamp(date: today, photoData: imageData, title: "Today", note: nil)
        _ = persistenceController.createStamp(date: yesterday, photoData: imageData, title: "Yesterday", note: nil)
        
        // Act
        let fetchedStamp = viewModel.stamp(for: today)
        
        // Assert
        XCTAssertEqual(fetchedStamp?.id, todayStamp.id)
        XCTAssertEqual(fetchedStamp?.title, "Today")
    }
    
    // MARK: - deleteStamp Tests
    
    func testDeleteStamp_RemovesStampAndReloads() {
        // Arrange
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(date: Date(), photoData: imageData, title: "To Delete", note: nil)
        viewModel.loadStamps()
        XCTAssertEqual(viewModel.stamps.count, 1)
        
        // Act
        viewModel.deleteStamp(stamp)
        
        // Assert
        XCTAssertTrue(viewModel.stamps.isEmpty)
    }
    
    func testDeleteStamp_WithMultipleStamps_DeletesOnlySpecifiedStamp() {
        // Arrange
        let imageData = createTestImageData()
        let stamp1 = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Keep", note: nil)
        let stamp2 = persistenceController.createStamp(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            photoData: imageData,
            title: "Delete",
            note: nil
        )
        viewModel.loadStamps()
        XCTAssertEqual(viewModel.stamps.count, 2)
        
        // Act
        viewModel.deleteStamp(stamp2)
        
        // Assert
        XCTAssertEqual(viewModel.stamps.count, 1)
        XCTAssertEqual(viewModel.stamps[0].id, stamp1.id)
    }
    
    func testDeleteStamp_UpdatesPublishedProperty() {
        // Arrange
        let expectation = XCTestExpectation(description: "Stamps updated after deletion")
        let imageData = createTestImageData()
        let stamp = persistenceController.createStamp(date: Date(), photoData: imageData, title: "Test", note: nil)
        viewModel.loadStamps()
        
        var updateCount = 0
        viewModel.$stamps
            .dropFirst() // Skip initial value
            .sink { stamps in
                updateCount += 1
                if updateCount == 1 && stamps.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.deleteStamp(stamp)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - selectedDate Tests
    
    func testSelectedDate_CanBeUpdated() {
        // Arrange
        let newDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        
        // Act
        viewModel.selectedDate = newDate
        
        // Assert
        XCTAssertTrue(Calendar.current.isDate(viewModel.selectedDate, inSameDayAs: newDate))
    }
    
    func testSelectedDate_PublishesChanges() {
        // Arrange
        let expectation = XCTestExpectation(description: "Selected date published")
        let newDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        
        viewModel.$selectedDate
            .dropFirst() // Skip initial value
            .sink { date in
                if Calendar.current.isDate(date, inSameDayAs: newDate) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.selectedDate = newDate
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImageData() -> Data {
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image.jpegData(compressionQuality: 0.8) ?? Data()
    }
}
