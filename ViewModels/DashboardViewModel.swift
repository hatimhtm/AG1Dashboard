//
//  DashboardViewModel.swift
//  AG1Dashboard
//
//  Main ViewModel handling data, filtering, and computed KPIs
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var creatives: [Creative] = []
    @Published var filteredCreatives: [Creative] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var filterState = FilterState()
    
    // MARK: - Computed KPIs
    var totalBudget: Double {
        filteredCreatives.reduce(0) { $0 + $1.budget }
    }
    
    var totalConversions: Int {
        filteredCreatives.reduce(0) { $0 + $1.conversions }
    }
    
    var averageROAS: Double {
        guard !filteredCreatives.isEmpty else { return 0 }
        return filteredCreatives.reduce(0) { $0 + $1.roas } / Double(filteredCreatives.count)
    }
    
    var averageCostPerConversion: Double {
        let valid = filteredCreatives.filter { $0.costPerConversion > 0 }
        guard !valid.isEmpty else { return 0 }
        return valid.reduce(0) { $0 + $1.costPerConversion } / Double(valid.count)
    }
    
    var totalRevenue: Double {
        filteredCreatives.reduce(0) { $0 + $1.revenue }
    }
    
    var creativeCount: Int {
        filteredCreatives.count
    }
    
    // MARK: - Chart Data
    var roasByMonth: [(month: String, roas: Double)] {
        let grouped = Dictionary(grouping: filteredCreatives) { $0.month }
        let monthOrder = ["Juillet 2025", "Août 2025", "Septembre 2025", "Octobre 2025", "Novembre 2025"]
        return grouped
            .map { (month: $0.key, roas: $0.value.reduce(0) { $0 + $1.roas } / Double($0.value.count)) }
            .sorted { monthOrder.firstIndex(of: $0.month) ?? 99 < monthOrder.firstIndex(of: $1.month) ?? 99 }
    }
    
    var budgetByProduct: [(product: String, budget: Double)] {
        let grouped = Dictionary(grouping: filteredCreatives) { $0.product }
        return grouped
            .map { (product: $0.key, budget: $0.value.reduce(0) { $0 + $1.budget }) }
            .sorted { $0.budget > $1.budget }
    }
    
    var top5ByROAS: [Creative] {
        Array(filteredCreatives.sorted { $0.roas > $1.roas }.prefix(5))
    }
    
    var top5CreatorsByConversions: [(creator: String, conversions: Int)] {
        let grouped = Dictionary(grouping: filteredCreatives) { $0.creator }
        return grouped
            .map { (creator: $0.key, conversions: $0.value.reduce(0) { $0 + $1.conversions }) }
            .sorted { $0.conversions > $1.conversions }
            .prefix(5)
            .map { $0 }
    }
    
    // MARK: - Subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFilterSubscription()
    }
    
    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let loaded = try CSVParser.parseCreatives(from: "AG1-Data")
                self.creatives = loaded
                self.applyFilters()
                self.isLoading = false
            } catch {
                // Fallback to sample data for development/preview
                self.errorMessage = error.localizedDescription
                self.creatives = Creative.samples
                self.applyFilters()
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Filtering
    private func setupFilterSubscription() {
        filterState.objectWillChange
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func applyFilters() {
        var result = creatives
        
        // Apply each filter
        if filterState.productFilter != .all {
            result = result.filter { $0.product == filterState.productFilter.rawValue }
        }
        if filterState.monthFilter != .all {
            result = result.filter { $0.month == filterState.monthFilter.rawValue }
        }
        if filterState.statusFilter != .all {
            result = result.filter { $0.status == filterState.statusFilter.rawValue }
        }
        if filterState.contentTypeFilter != .all {
            result = result.filter { $0.contentType == filterState.contentTypeFilter.rawValue }
        }
        if !filterState.searchText.isEmpty {
            let search = filterState.searchText.lowercased()
            result = result.filter {
                $0.adName.lowercased().contains(search) ||
                $0.creator.lowercased().contains(search) ||
                $0.product.lowercased().contains(search)
            }
        }
        
        // Apply sorting
        filteredCreatives = applySorting(to: result)
    }
    
    private func applySorting(to creatives: [Creative]) -> [Creative] {
        switch filterState.sortOption {
        case .roasDesc: return creatives.sorted { $0.roas > $1.roas }
        case .roasAsc: return creatives.sorted { $0.roas < $1.roas }
        case .budgetDesc: return creatives.sorted { $0.budget > $1.budget }
        case .budgetAsc: return creatives.sorted { $0.budget < $1.budget }
        case .conversionsDesc: return creatives.sorted { $0.conversions > $1.conversions }
        case .conversionsAsc: return creatives.sorted { $0.conversions < $1.conversions }
        case .dateDesc: return creatives.sorted { ($0.launchDate ?? .distantPast) > ($1.launchDate ?? .distantPast) }
        case .dateAsc: return creatives.sorted { ($0.launchDate ?? .distantPast) < ($1.launchDate ?? .distantPast) }
        }
    }
}
