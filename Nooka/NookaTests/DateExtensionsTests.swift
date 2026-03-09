//
//  DateExtensionsTests.swift
//  NookaTests
//
//  Created by Nooka on 2024.
//

import XCTest
@testable import Nooka

final class DateExtensionsTests: XCTestCase {
    
    // MARK: - startOfDay Tests
    
    func testStartOfDay_ReturnsDateAtMidnight() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 14
        components.minute = 30
        components.second = 45
        let date = calendar.date(from: components)!
        
        // Act
        let startOfDay = date.startOfDay
        
        // Assert
        let resultComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startOfDay)
        XCTAssertEqual(resultComponents.year, 2024)
        XCTAssertEqual(resultComponents.month, 3)
        XCTAssertEqual(resultComponents.day, 15)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }
    
    func testStartOfDay_WithMidnightDate_ReturnsSameDate() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 0
        components.minute = 0
        components.second = 0
        let midnightDate = calendar.date(from: components)!
        
        // Act
        let startOfDay = midnightDate.startOfDay
        
        // Assert
        XCTAssertEqual(startOfDay, midnightDate)
    }
    
    // MARK: - endOfDay Tests
    
    func testEndOfDay_ReturnsLastSecondOfDay() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 10
        components.minute = 30
        let date = calendar.date(from: components)!
        
        // Act
        let endOfDay = date.endOfDay
        
        // Assert
        let resultComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endOfDay)
        XCTAssertEqual(resultComponents.year, 2024)
        XCTAssertEqual(resultComponents.month, 3)
        XCTAssertEqual(resultComponents.day, 15)
        XCTAssertEqual(resultComponents.hour, 23)
        XCTAssertEqual(resultComponents.minute, 59)
        XCTAssertEqual(resultComponents.second, 59)
    }
    
    func testEndOfDay_IsBeforeNextDayStart() {
        // Arrange
        let date = Date()
        
        // Act
        let endOfDay = date.endOfDay
        let nextDayStart = Calendar.current.date(byAdding: .day, value: 1, to: date.startOfDay)!
        
        // Assert
        XCTAssertLessThan(endOfDay, nextDayStart)
    }
    
    // MARK: - isSameDay Tests
    
    func testIsSameDay_WithSameDayDifferentTimes_ReturnsTrue() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        
        components.hour = 9
        components.minute = 0
        let morning = calendar.date(from: components)!
        
        components.hour = 18
        components.minute = 30
        let evening = calendar.date(from: components)!
        
        // Act & Assert
        XCTAssertTrue(morning.isSameDay(as: evening))
        XCTAssertTrue(evening.isSameDay(as: morning))
    }
    
    func testIsSameDay_WithDifferentDays_ReturnsFalse() {
        // Arrange
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        // Act & Assert
        XCTAssertFalse(today.isSameDay(as: tomorrow))
        XCTAssertFalse(tomorrow.isSameDay(as: today))
    }
    
    func testIsSameDay_WithSameDate_ReturnsTrue() {
        // Arrange
        let date = Date()
        
        // Act & Assert
        XCTAssertTrue(date.isSameDay(as: date))
    }
    
    func testIsSameDay_AcrossMonthBoundary_ReturnsFalse() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 31
        components.hour = 23
        let lastDayOfMarch = calendar.date(from: components)!
        
        components.month = 4
        components.day = 1
        components.hour = 0
        let firstDayOfApril = calendar.date(from: components)!
        
        // Act & Assert
        XCTAssertFalse(lastDayOfMarch.isSameDay(as: firstDayOfApril))
    }
    
    // MARK: - monthYearString Tests
    
    func testMonthYearString_ReturnsCorrectFormat() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        let date = calendar.date(from: components)!
        
        // Act
        let monthYearString = date.monthYearString
        
        // Assert
        XCTAssertEqual(monthYearString, "March 2024")
    }
    
    func testMonthYearString_WithDifferentMonths_ReturnsCorrectStrings() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.day = 1
        
        let months = [
            (1, "January 2024"),
            (6, "June 2024"),
            (12, "December 2024")
        ]
        
        // Act & Assert
        for (month, expected) in months {
            components.month = month
            let date = calendar.date(from: components)!
            XCTAssertEqual(date.monthYearString, expected)
        }
    }
    
    // MARK: - dayString Tests
    
    func testDayString_ReturnsDayNumber() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 5
        let date = calendar.date(from: components)!
        
        // Act
        let dayString = date.dayString
        
        // Assert
        XCTAssertEqual(dayString, "5")
    }
    
    func testDayString_WithDoubleDigitDay_ReturnsCorrectString() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 25
        let date = calendar.date(from: components)!
        
        // Act
        let dayString = date.dayString
        
        // Assert
        XCTAssertEqual(dayString, "25")
    }
    
    // MARK: - weekdayString Tests
    
    func testWeekdayString_ReturnsAbbreviatedWeekday() {
        // Arrange
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15 // This is a Friday in 2024
        let date = calendar.date(from: components)!
        
        // Act
        let weekdayString = date.weekdayString
        
        // Assert
        XCTAssertEqual(weekdayString, "Fri")
    }
    
    func testWeekdayString_WithDifferentDays_ReturnsCorrectAbbreviations() {
        // Arrange
        let calendar = Calendar.current
        
        // March 2024: 10=Sun, 11=Mon, 12=Tue, 13=Wed, 14=Thu, 15=Fri, 16=Sat
        let testCases: [(day: Int, expected: String)] = [
            (10, "Sun"),
            (11, "Mon"),
            (12, "Tue"),
            (13, "Wed"),
            (14, "Thu"),
            (15, "Fri"),
            (16, "Sat")
        ]
        
        // Act & Assert
        for testCase in testCases {
            var components = DateComponents()
            components.year = 2024
            components.month = 3
            components.day = testCase.day
            let date = calendar.date(from: components)!
            XCTAssertEqual(date.weekdayString, testCase.expected, "Failed for day \(testCase.day)")
        }
    }
}
