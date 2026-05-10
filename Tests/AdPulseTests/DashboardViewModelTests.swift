//
//  DashboardViewModelTests.swift
//  AdPulseTests
//

import XCTest
@testable import AdPulse

@MainActor
final class DashboardViewModelTests: XCTestCase {

    private func makeCreative(
        name: String = "Test",
        product: String = "Vital Powder",
        creator: String = "Alice",
        contentType: String = "UGC",
        status: String = "En ligne",
        budget: Double = 1000,
        conversions: Int = 50,
        revenue: Double = 5000,
        roas: Double = 5.0
    ) -> Creative {
        Creative(
            adName: name,
            product: product,
            creator: creator,
            contentType: contentType,
            marketingAngle: "Performance",
            hook: "Hook",
            month: "Octobre 2025",
            status: status,
            launchDate: nil,
            budget: budget,
            conversions: conversions,
            revenue: revenue,
            roas: roas,
            costPerConversion: budget / Double(conversions),
            impressions: 100_000,
            clicks: 3000,
            clickRate: 3.0
        )
    }

    func testTotalBudgetSumsAllCreatives() {
        let vm = DashboardViewModel()
        vm.creatives = [
            makeCreative(name: "A", budget: 100),
            makeCreative(name: "B", budget: 200),
            makeCreative(name: "C", budget: 300)
        ]
        XCTAssertEqual(vm.totalBudget, 600, accuracy: 0.001)
    }

    func testAverageROASIgnoresEmptyDataset() {
        let vm = DashboardViewModel()
        vm.creatives = []
        XCTAssertEqual(vm.averageROAS, 0)
    }

    func testAverageROASComputesCorrectly() {
        let vm = DashboardViewModel()
        vm.creatives = [
            makeCreative(name: "A", roas: 2.0),
            makeCreative(name: "B", roas: 4.0)
        ]
        XCTAssertEqual(vm.averageROAS, 3.0, accuracy: 0.001)
    }

    func testFilteredCreativesAppliesProductFilter() {
        let vm = DashboardViewModel()
        vm.creatives = [
            makeCreative(name: "A", product: "Vital Powder"),
            makeCreative(name: "B", product: "Vital Travel Packs"),
            makeCreative(name: "C", product: "Vital Powder")
        ]
        vm.filterState.productFilter = .vitalPowder
        XCTAssertEqual(vm.filteredCreatives.count, 2)
        XCTAssertTrue(vm.filteredCreatives.allSatisfy { $0.product == "Vital Powder" })
    }

    func testFilteredCreativesAppliesSearchText() {
        let vm = DashboardViewModel()
        vm.creatives = [
            makeCreative(name: "Alpha_UGC_Emma", creator: "Emma"),
            makeCreative(name: "Beta_Podcast_Marc", creator: "Marc")
        ]
        vm.filterState.searchText = "emma"
        XCTAssertEqual(vm.filteredCreatives.count, 1)
        XCTAssertEqual(vm.filteredCreatives.first?.creator, "Emma")
    }

    func testSortedByROASDescending() {
        let vm = DashboardViewModel()
        vm.creatives = [
            makeCreative(name: "Low", roas: 1.0),
            makeCreative(name: "High", roas: 5.0),
            makeCreative(name: "Mid", roas: 3.0)
        ]
        vm.filterState.sortOption = .roasDesc

        let sorted = vm.filteredCreatives
        XCTAssertEqual(sorted.map(\.adName), ["High", "Mid", "Low"])
    }

    func testTopFiveByROASClampsToFive() {
        let vm = DashboardViewModel()
        vm.creatives = (0..<10).map { makeCreative(name: "C\($0)", roas: Double($0)) }
        XCTAssertEqual(vm.top5ByROAS.count, 5)
        // Highest ROAS first
        XCTAssertEqual(vm.top5ByROAS.first?.adName, "C9")
    }
}
