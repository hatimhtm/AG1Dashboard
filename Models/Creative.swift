//
//  Creative.swift
//  AG1Dashboard
//
//  Data model representing a single advertising creative from Meta Ads
//

import Foundation

/// Represents one creative (ad) from the AG1-Data.csv file
/// All properties match the CSV columns exactly
struct Creative: Identifiable, Codable, Hashable {
    
    // MARK: - Identifier
    let id: UUID
    
    // MARK: - Basic Information
    let adName: String              // "Nom de l'annonce"
    let product: String             // "Produit"
    let creator: String             // "Créateur"
    let contentType: String         // "Type de contenu"
    let marketingAngle: String      // "Angle marketing"
    let hook: String                // "Hook"
    let month: String               // "Mois"
    let status: String              // "Statut" (En ligne, Arrêtée, En pause, Archivée)
    let launchDate: Date?           // "Date de lancement"
    
    // MARK: - Performance Metrics
    let budget: Double              // "Budget dépensé (€)"
    let conversions: Int            // "Conversions (achats)"
    let revenue: Double             // "Revenu estimé (€)"
    let roas: Double                // "ROAS" (Return on Ad Spend)
    let costPerConversion: Double   // "Coût par conversion (€)"
    let impressions: Int            // "Impressions"
    let clicks: Int                 // "Clics"
    let clickRate: Double           // "Taux de clic (%)"
    
    // MARK: - Initialization
    init(
        id: UUID = UUID(),
        adName: String,
        product: String,
        creator: String,
        contentType: String,
        marketingAngle: String,
        hook: String,
        month: String,
        status: String,
        launchDate: Date?,
        budget: Double,
        conversions: Int,
        revenue: Double,
        roas: Double,
        costPerConversion: Double,
        impressions: Int,
        clicks: Int,
        clickRate: Double
    ) {
        self.id = id
        self.adName = adName
        self.product = product
        self.creator = creator
        self.contentType = contentType
        self.marketingAngle = marketingAngle
        self.hook = hook
        self.month = month
        self.status = status
        self.launchDate = launchDate
        self.budget = budget
        self.conversions = conversions
        self.revenue = revenue
        self.roas = roas
        self.costPerConversion = costPerConversion
        self.impressions = impressions
        self.clicks = clicks
        self.clickRate = clickRate
    }
}

// MARK: - Computed Properties
extension Creative {
    
    /// Returns true if the creative is currently active
    var isActive: Bool {
        status.lowercased() == "en ligne"
    }
    
    /// Formatted budget string
    var budgetFormatted: String {
        formatCurrency(budget)
    }
    
    /// Formatted revenue string
    var revenueFormatted: String {
        formatCurrency(revenue)
    }
    
    /// Formatted cost per conversion
    var costPerConversionFormatted: String {
        formatCurrency(costPerConversion)
    }
    
    /// Helper to format currency
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "€0"
    }
}

// MARK: - Sample Data for Development & Previews
extension Creative {
    
    /// Single sample creative for previews
    static let sample = Creative(
        adName: "AG1_UGC_Emma_Energie_V1",
        product: "AG1 Powder",
        creator: "Emma Laurent",
        contentType: "UGC",
        marketingAngle: "Énergie quotidienne",
        hook: "Ce qui a changé ma vie...",
        month: "Octobre 2025",
        status: "En ligne",
        launchDate: Date(),
        budget: 2500.00,
        conversions: 85,
        revenue: 7650.00,
        roas: 3.06,
        costPerConversion: 29.41,
        impressions: 125000,
        clicks: 3750,
        clickRate: 3.0
    )
    
    /// Array of sample creatives for list previews
    static let samples: [Creative] = [
        sample,
        Creative(
            adName: "AG1_Podcast_Marc_Routine_V2",
            product: "Bundle Complet",
            creator: "Marc Dupont",
            contentType: "Podcast",
            marketingAngle: "Routine matinale",
            hook: "Mon secret de productivité",
            month: "Novembre 2025",
            status: "En ligne",
            launchDate: Date(),
            budget: 4200.00,
            conversions: 142,
            revenue: 14200.00,
            roas: 3.38,
            costPerConversion: 29.58,
            impressions: 280000,
            clicks: 8400,
            clickRate: 3.0
        ),
        Creative(
            adName: "AG1_Static_Travel_V1",
            product: "AG1 Travel Packs",
            creator: "Studio Interne",
            contentType: "Image statique",
            marketingAngle: "Voyage et santé",
            hook: "Gardez vos habitudes en voyage",
            month: "Septembre 2025",
            status: "Arrêtée",
            launchDate: Date(),
            budget: 1200.00,
            conversions: 28,
            revenue: 1960.00,
            roas: 1.63,
            costPerConversion: 42.86,
            impressions: 85000,
            clicks: 1700,
            clickRate: 2.0
        ),
        Creative(
            adName: "AG1_Video_Sophie_Wellness_V1",
            product: "AG1 Powder",
            creator: "Sophie Martin",
            contentType: "Motion/Vidéo",
            marketingAngle: "Bien-être global",
            hook: "3 mois plus tard...",
            month: "Octobre 2025",
            status: "En ligne",
            launchDate: Date(),
            budget: 3800.00,
            conversions: 156,
            revenue: 14040.00,
            roas: 3.69,
            costPerConversion: 24.36,
            impressions: 320000,
            clicks: 11200,
            clickRate: 3.5
        ),
        Creative(
            adName: "AG1_UGC_Thomas_Sport_V3",
            product: "Bundle Complet",
            creator: "Thomas Bernard",
            contentType: "UGC",
            marketingAngle: "Performance sportive",
            hook: "Avant chaque entraînement...",
            month: "Novembre 2025",
            status: "En ligne",
            launchDate: Date(),
            budget: 5200.00,
            conversions: 198,
            revenue: 21780.00,
            roas: 4.19,
            costPerConversion: 26.26,
            impressions: 420000,
            clicks: 14700,
            clickRate: 3.5
        )
    ]
}
