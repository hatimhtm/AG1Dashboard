//
//  DashboardViewModel.swift
//  AdPulse
//
//  Main ViewModel handling data, filtering, and computed KPIs.
//  Built on the iOS 17 @Observable macro — every mutation re-renders dependents
//  automatically, no Combine wiring required.
//

import Foundation

@MainActor
@Observable
final class DashboardViewModel {

    // MARK: - State
    var creatives: [Creative] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var filterState = FilterState()

    // MARK: - Filtered + sorted creatives (computed every read)
    /// Filtered + sorted view of `creatives`. Recomputes when any filter changes
    /// because `@Observable` tracks reads through `filterState`.
    var filteredCreatives: [Creative] {
        var result = creatives

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

        return sorted(result)
    }

    private func sorted(_ list: [Creative]) -> [Creative] {
        switch filterState.sortOption {
        case .roasDesc:        return list.sorted { $0.roas > $1.roas }
        case .roasAsc:         return list.sorted { $0.roas < $1.roas }
        case .budgetDesc:      return list.sorted { $0.budget > $1.budget }
        case .budgetAsc:       return list.sorted { $0.budget < $1.budget }
        case .conversionsDesc: return list.sorted { $0.conversions > $1.conversions }
        case .conversionsAsc:  return list.sorted { $0.conversions < $1.conversions }
        case .dateDesc:        return list.sorted { ($0.launchDate ?? .distantPast) > ($1.launchDate ?? .distantPast) }
        case .dateAsc:         return list.sorted { ($0.launchDate ?? .distantPast) < ($1.launchDate ?? .distantPast) }
        }
    }

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

    // MARK: - Anomalies
    /// Top anomalies for the currently-filtered cohort. Reads the user's
    /// preference + threshold straight from UserDefaults so the SettingsView
    /// AppStorage values flow through without any extra plumbing.
    var anomalies: [AnomalyDetector.Anomaly] {
        let defaults = UserDefaults.standard
        let enabled = defaults.object(forKey: "anomalyDetectionEnabled") as? Bool ?? true
        guard enabled else { return [] }
        let threshold = defaults.object(forKey: "anomalyZScoreThreshold") as? Double ?? 2.0
        return AnomalyDetector.detect(in: filteredCreatives, zThreshold: threshold)
    }

    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let loaded = try CSVParser.parseCreatives(from: "AdPulse-Data")
                self.creatives = loaded
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.creatives = Creative.samples
                self.isLoading = false
            }
        }
    }
}
