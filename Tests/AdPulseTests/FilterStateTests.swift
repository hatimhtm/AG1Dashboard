//
//  FilterStateTests.swift
//  AdPulseTests
//

import XCTest
@testable import AdPulse

@MainActor
final class FilterStateTests: XCTestCase {

    func testHasActiveFiltersFalseWhenAllDefault() {
        let state = FilterState()
        XCTAssertFalse(state.hasActiveFilters)
    }

    func testHasActiveFiltersTrueAfterSettingProduct() {
        let state = FilterState()
        state.productFilter = .vitalPowder
        XCTAssertTrue(state.hasActiveFilters)
    }

    func testHasActiveFiltersTrueOnSearchText() {
        let state = FilterState()
        state.searchText = "emma"
        XCTAssertTrue(state.hasActiveFilters)
    }

    func testResetFiltersReturnsToDefaults() {
        let state = FilterState()
        state.productFilter = .vitalPowder
        state.monthFilter = .octobre2025
        state.searchText = "emma"
        state.sortOption = .budgetAsc

        state.resetFilters()

        XCTAssertEqual(state.productFilter, .all)
        XCTAssertEqual(state.monthFilter, .all)
        XCTAssertEqual(state.searchText, "")
        XCTAssertEqual(state.sortOption, .roasDesc)
        XCTAssertFalse(state.hasActiveFilters)
    }
}
