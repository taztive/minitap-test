# Nooka Test Suite

This directory contains comprehensive unit and integration tests for the Nooka stamp diary app.

## Test Structure

### Unit Tests

Unit tests verify individual components in isolation:

#### 1. PersistenceControllerTests.swift
Tests Core Data persistence layer operations:
- **Create operations**: Creating stamps with valid/invalid data, random rotation/offset
- **Fetch operations**: Fetching stamps by date, fetching all stamps, sorting
- **Update operations**: Updating title, note, photo data, and combinations
- **Delete operations**: Deleting single/multiple stamps
- **Save context**: Handling changes and no-change scenarios

**Coverage**: 23 test cases covering all CRUD operations

#### 2. DateExtensionsTests.swift
Tests Date utility extensions:
- **startOfDay**: Midnight calculation, edge cases
- **endOfDay**: Last second of day calculation
- **isSameDay**: Same day comparison across different times
- **monthYearString**: Date formatting for month/year display
- **dayString**: Day number formatting
- **weekdayString**: Weekday abbreviation formatting

**Coverage**: 15 test cases covering all date utilities

#### 3. CalendarViewModelTests.swift
Tests calendar view model logic:
- **Initialization**: Default values, auto-loading stamps
- **loadStamps**: Loading multiple stamps, reactive updates
- **stamp(for:)**: Fetching stamps by date with multiple scenarios
- **deleteStamp**: Deletion with list updates
- **Published properties**: Combine publisher behavior

**Coverage**: 14 test cases covering all view model operations

#### 4. StampCreationViewModelTests.swift
Tests stamp creation view model:
- **Initialization**: Default values, custom persistence controller
- **createStamp**: Valid/invalid data, image compression, field validation
- **reset**: Clearing all fields
- **Published properties**: Reactive updates for all fields
- **Integration**: Multiple stamp creation, same-date handling

**Coverage**: 20 test cases covering creation workflow

### Integration Tests

Integration tests verify component interactions:

#### IntegrationTests.swift
Tests end-to-end workflows:
- **Create and View Flow**: Creating stamps and viewing in calendar
- **Delete Flow**: Deleting stamps and verifying removal
- **Update Flow**: Updating stamps and seeing changes
- **Date-based Queries**: Fetching stamps by date across different scenarios
- **Data Persistence**: Verifying data persists across view model instances
- **Edge Cases**: Same-date stamps, empty database, large datasets
- **Reactive Updates**: Publisher behavior across components

**Coverage**: 14 test cases covering complete user workflows

## Test Execution

### Requirements
- macOS with Xcode 15.0 or later
- iOS 16.0+ SDK

### Running Tests

#### Via Xcode
1. Open `Nooka.xcodeproj` in Xcode
2. Select the `NookaTests` scheme
3. Press `Cmd+U` to run all tests
4. Or use Test Navigator (`Cmd+6`) to run individual tests

#### Via Command Line
```bash
xcodebuild test \
  -project Nooka.xcodeproj \
  -scheme Nooka \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0'
```

#### With Coverage
```bash
xcodebuild test \
  -project Nooka.xcodeproj \
  -scheme Nooka \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -enableCodeCoverage YES
```

View coverage report:
```bash
xcrun xccov view --report \
  ~/Library/Developer/Xcode/DerivedData/Nooka-*/Logs/Test/*.xcresult
```

## Test Coverage Summary

### Files Tested
- ✅ `PersistenceController.swift` - Full coverage of all CRUD operations
- ✅ `Date+Extensions.swift` - All extension methods tested
- ✅ `CalendarViewModel.swift` - All public methods and properties tested
- ✅ `StampCreationViewModel.swift` - Complete creation workflow tested
- ✅ Integration between ViewModels and Core Data

### Coverage Metrics (Estimated)
- **PersistenceController**: ~95% line coverage
- **Date Extensions**: 100% line coverage
- **CalendarViewModel**: ~90% line coverage
- **StampCreationViewModel**: ~95% line coverage
- **Overall Feature Coverage**: ~90%

### Not Tested (UI Layer)
The following are not covered by unit/integration tests (require UI tests):
- SwiftUI Views (`CalendarView`, `CreateStampView`, `ContentView`, etc.)
- Design system components (`NookaCard`, `NookaButton`)
- Navigation flow
- User interactions

These would require XCUITest for UI testing, which is beyond the scope of unit/integration tests.

## Test Patterns

### In-Memory Core Data
All tests use in-memory Core Data stores for isolation:
```swift
persistenceController = PersistenceController(inMemory: true)
```

### Test Helpers
Common helper methods for creating test data:
- `createTestImage()` - Creates UIImage for testing
- `createTestImageData()` - Creates compressed image data

### Combine Testing
Tests use `XCTestExpectation` to verify published property updates:
```swift
viewModel.$stamps
    .dropFirst()
    .sink { stamps in
        expectation.fulfill()
    }
    .store(in: &cancellables)
```

## Continuous Integration

To integrate with CI/CD:

### GitHub Actions Example
```yaml
- name: Run Tests
  run: |
    xcodebuild test \
      -project Nooka.xcodeproj \
      -scheme Nooka \
      -destination 'platform=iOS Simulator,name=iPhone 15' \
      -enableCodeCoverage YES
```

### Test Reports
Generate JUnit-style reports for CI:
```bash
xcrun xcresulttool get --format json \
  --path ~/Library/Developer/Xcode/DerivedData/Nooka-*/Logs/Test/*.xcresult
```

## Adding New Tests

When adding new features:

1. **Unit Tests**: Test the component in isolation
   - Create test file: `[ComponentName]Tests.swift`
   - Test all public methods and edge cases
   - Use in-memory persistence for data layer tests

2. **Integration Tests**: Test component interactions
   - Add test cases to `IntegrationTests.swift`
   - Test complete user workflows
   - Verify data flows correctly between layers

3. **Naming Convention**:
   - Test methods: `test[MethodName]_[Scenario]_[ExpectedResult]`
   - Example: `testCreateStamp_WithValidData_ReturnsTrue`

## Known Limitations

1. **Platform Dependency**: Tests require macOS with Xcode (cannot run on Linux)
2. **UI Testing**: SwiftUI views are not covered by these tests
3. **Performance Tests**: Limited performance testing (only one `measure` block)
4. **Async Operations**: Current implementation is synchronous; async tests would need different patterns

## Test Maintenance

- **Run tests before committing**: Ensure all tests pass
- **Update tests when changing APIs**: Keep tests in sync with implementation
- **Add tests for bug fixes**: Prevent regressions
- **Review coverage regularly**: Aim for >80% coverage on business logic

## Questions?

For questions about the test suite, refer to:
- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Testing SwiftUI Apps](https://developer.apple.com/documentation/swiftui/testing-swiftui-apps)
- [Core Data Testing](https://developer.apple.com/documentation/coredata/testing_core_data)
