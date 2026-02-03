//
//  FilterState.swift
//  AG1Dashboard
//
//  Observable filter state for the dashboard
//

import Foundation
import SwiftUI

// MARK: - Product Filter Options
enum ProductFilter: String, CaseIterable, Identifiable {
    case all = "Tous"
    case ag1Powder = "AG1 Powder"
    case ag1TravelPacks = "AG1 Travel Packs"
    case vitamineD3K2 = "Vitamine D3+K2"
    case omega3 = "Omega-3"
    case shaker = "Shaker"
    case bundleComplet = "Bundle Complet"
    case abonnement = "Abonnement"
    
    var id: String { rawValue }
}

// MARK: - Month Filter Options
enum MonthFilter: String, CaseIterable, Identifiable {
    case all = "Tous"
    case juillet2025 = "Juillet 2025"
    case aout2025 = "Août 2025"
    case septembre2025 = "Septembre 2025"
    case octobre2025 = "Octobre 2025"
    case novembre2025 = "Novembre 2025"
    
    var id: String { rawValue }
}

// MARK: - Status Filter Options
enum StatusFilter: String, CaseIterable, Identifiable {
    case all = "Tous"
    case enLigne = "En ligne"
    case arretee = "Arrêtée"
    case enPause = "En pause"
    case archivee = "Archivée"
    
    var id: String { rawValue }
}

// MARK: - Content Type Filter Options
enum ContentTypeFilter: String, CaseIterable, Identifiable {
    case all = "Tous"
    case ugc = "UGC"
    case podcast = "Podcast"
    case imageStatique = "Image statique"
    case motionVideo = "Motion/Vidéo"
    case temoignage = "Témoignage"
    
    var id: String { rawValue }
}

// MARK: - Sort Options
enum SortOption: String, CaseIterable, Identifiable {
    case roasDesc = "ROAS ↓"
    case roasAsc = "ROAS ↑"
    case budgetDesc = "Budget ↓"
    case budgetAsc = "Budget ↑"
    case conversionsDesc = "Conversions ↓"
    case conversionsAsc = "Conversions ↑"
    case dateDesc = "Date ↓"
    case dateAsc = "Date ↑"
    
    var id: String { rawValue }
}

// MARK: - Filter State (Observable)
@MainActor
class FilterState: ObservableObject {
    
    // Current filter selections
    @Published var productFilter: ProductFilter = .all
    @Published var monthFilter: MonthFilter = .all
    @Published var statusFilter: StatusFilter = .all
    @Published var contentTypeFilter: ContentTypeFilter = .all
    @Published var creatorFilter: String = ""
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .roasDesc
    
    /// Resets all filters to default values
    func resetFilters() {
        productFilter = .all
        monthFilter = .all
        statusFilter = .all
        contentTypeFilter = .all
        creatorFilter = ""
        searchText = ""
        sortOption = .roasDesc
    }
    
    /// Returns true if any filter is currently active
    var hasActiveFilters: Bool {
        productFilter != .all ||
        monthFilter != .all ||
        statusFilter != .all ||
        contentTypeFilter != .all ||
        !creatorFilter.isEmpty ||
        !searchText.isEmpty
    }
}
