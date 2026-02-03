//
//  OverviewView.swift
//  AG1Dashboard
//
//  Screen 1: Dashboard Overview with iOS 17 Features
//  Showcases Swift Charts, animations, and modern UI patterns
//

import SwiftUI
import Charts

struct OverviewView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State private var selectedMonth: String?
    @State private var selectedProduct: String?
    @State private var animateCharts = false
    
    // Adaptive grid
    private var kpiColumns: [GridItem] {
        if sizeClass == .regular {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
        } else {
            return Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Filters
                filterSection
                
                // Summary header
                summaryHeader
                
                // KPIs
                kpiSection
                
                // Charts with iOS 17 selection
                chartsSection
                
                // Rankings
                rankingsSection
            }
            .padding()
        }
        .gradientBackground()
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            // Pull to refresh with haptic
            HapticsManager.notification(.success)
            viewModel.loadData()
        }
        .onAppear {
            withAnimation(AppTheme.Animations.smooth.delay(0.3)) {
                animateCharts = true
            }
        }
    }
    
    // MARK: - Summary Header
    private var summaryHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Performance globale")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Text("\(viewModel.creativeCount) créas • \(viewModel.filteredCreatives.filter { $0.isActive }.count) en ligne")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            // Quick stats pill
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppTheme.Colors.accentGreen)
                    .symbolEffect(.pulse)
                
                Text("ROAS \(String(format: "%.2f", viewModel.averageROAS))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            .clipShape(Capsule())
        }
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterPill(
                    title: "Produit",
                    value: viewModel.filterState.productFilter.rawValue,
                    isActive: viewModel.filterState.productFilter != .all
                ) {
                    ForEach(ProductFilter.allCases) { filter in
                        Button(filter.rawValue) {
                            withAnimation(AppTheme.Animations.snappy) {
                                viewModel.filterState.productFilter = filter
                            }
                            HapticsManager.selection()
                        }
                    }
                }
                
                FilterPill(
                    title: "Mois",
                    value: viewModel.filterState.monthFilter.rawValue,
                    isActive: viewModel.filterState.monthFilter != .all
                ) {
                    ForEach(MonthFilter.allCases) { filter in
                        Button(filter.rawValue) {
                            withAnimation(AppTheme.Animations.snappy) {
                                viewModel.filterState.monthFilter = filter
                            }
                            HapticsManager.selection()
                        }
                    }
                }
                
                FilterPill(
                    title: "Statut",
                    value: viewModel.filterState.statusFilter.rawValue,
                    isActive: viewModel.filterState.statusFilter != .all
                ) {
                    ForEach(StatusFilter.allCases) { filter in
                        Button(filter.rawValue) {
                            withAnimation(AppTheme.Animations.snappy) {
                                viewModel.filterState.statusFilter = filter
                            }
                            HapticsManager.selection()
                        }
                    }
                }
                
                if viewModel.filterState.hasActiveFilters {
                    Button {
                        withAnimation(AppTheme.Animations.bouncy) {
                            viewModel.filterState.resetFilters()
                        }
                        HapticsManager.notification(.warning)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .symbolEffect(.bounce)
                    }
                }
            }
        }
    }
    
    // MARK: - KPI Section
    private var kpiSection: some View {
        LazyVGrid(columns: kpiColumns, spacing: 16) {
            KPICard(
                icon: "eurosign.circle.fill",
                title: "Budget dépensé",
                value: formatCurrency(viewModel.totalBudget),
                color: AppTheme.Colors.accentBlue,
                trend: 8.5
            )
            
            KPICard(
                icon: "cart.fill",
                title: "Conversions",
                value: formatNumber(viewModel.totalConversions),
                color: AppTheme.Colors.accentGreen,
                trend: 15.2
            )
            
            KPICard(
                icon: "arrow.up.right.circle.fill",
                title: "ROAS moyen",
                value: String(format: "%.2f", viewModel.averageROAS),
                color: AppTheme.Colors.accentPurple,
                trend: viewModel.averageROAS >= 2 ? 5.0 : -3.0
            )
            
            KPICard(
                icon: "creditcard.fill",
                title: "Coût/Conversion",
                value: formatCurrency(viewModel.averageCostPerConversion),
                color: AppTheme.Colors.accentOrange
            )
            
            KPICard(
                icon: "banknote.fill",
                title: "Revenu total",
                value: formatCurrency(viewModel.totalRevenue),
                color: AppTheme.Colors.accentCyan,
                trend: 22.1
            )
            
            KPICard(
                icon: "photo.stack.fill",
                title: "Nombre de créas",
                value: "\(viewModel.creativeCount)",
                color: AppTheme.Colors.accentYellow
            )
        }
    }
    
    // MARK: - Charts Section with iOS 17 Selection
    private var chartsSection: some View {
        VStack(spacing: 16) {
            if sizeClass == .regular {
                HStack(alignment: .top, spacing: 16) {
                    roasChart
                    budgetChart
                }
            } else {
                roasChart
                budgetChart
            }
        }
    }
    
    private var roasChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("ROAS par mois")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                if let selected = selectedMonth {
                    Text(selected)
                        .font(.caption)
                        .foregroundStyle(AppTheme.Colors.accentBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.Colors.accentBlue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Chart(viewModel.roasByMonth, id: \.month) { item in
                BarMark(
                    x: .value("Mois", String(item.month.prefix(3))),
                    y: .value("ROAS", animateCharts ? item.roas : 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: AppTheme.Colors.chartGradientGreen,
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(8)
                // iOS 17 chart selection
                .opacity(selectedMonth == nil || selectedMonth == item.month ? 1 : 0.5)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXSelection(value: $selectedMonth)
            .frame(height: 180)
            .sensoryFeedback(.selection, trigger: selectedMonth)
        }
        .cardStyle()
    }
    
    private var budgetChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Budget par produit")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                if let selected = selectedProduct {
                    Text(selected)
                        .font(.caption)
                        .foregroundStyle(AppTheme.Colors.accentPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.Colors.accentPurple.opacity(0.1))
                        .clipShape(Capsule())
                        .lineLimit(1)
                }
            }
            
            Chart(viewModel.budgetByProduct.prefix(5), id: \.product) { item in
                BarMark(
                    x: .value("Budget", animateCharts ? item.budget : 0),
                    y: .value("Produit", item.product)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: AppTheme.Colors.chartGradientPurple,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(8)
                .opacity(selectedProduct == nil || selectedProduct == item.product ? 1 : 0.5)
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let budget = value.as(Double.self) {
                            Text("€\(Int(budget / 1000))k")
                        }
                    }
                }
            }
            .chartYSelection(value: $selectedProduct)
            .frame(height: 180)
            .sensoryFeedback(.selection, trigger: selectedProduct)
        }
        .cardStyle()
    }
    
    // MARK: - Rankings Section
    private var rankingsSection: some View {
        VStack(spacing: 16) {
            if sizeClass == .regular {
                HStack(alignment: .top, spacing: 16) {
                    topROASList
                    topCreatorsList
                }
            } else {
                topROASList
                topCreatorsList
            }
        }
    }
    
    private var topROASList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Top 5 créas par ROAS")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "medal.fill")
                    .foregroundStyle(AppTheme.Colors.accentYellow)
                    .symbolEffect(.bounce)
            }
            
            ForEach(Array(viewModel.top5ByROAS.enumerated()), id: \.element.id) { index, creative in
                RankingRow(
                    rank: index + 1,
                    title: creative.adName,
                    subtitle: creative.product,
                    value: String(format: "%.2f", creative.roas),
                    valueColor: AppTheme.Colors.accentGreen
                )
                
                if index < viewModel.top5ByROAS.count - 1 {
                    Divider()
                }
            }
        }
        .cardStyle()
    }
    
    private var topCreatorsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Top 5 créateurs")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "person.fill.checkmark")
                    .foregroundStyle(AppTheme.Colors.accentBlue)
                    .symbolEffect(.pulse)
            }
            
            ForEach(Array(viewModel.top5CreatorsByConversions.enumerated()), id: \.element.creator) { index, item in
                RankingRow(
                    rank: index + 1,
                    title: item.creator,
                    subtitle: nil,
                    value: "\(item.conversions)",
                    valueColor: AppTheme.Colors.accentBlue
                )
                
                if index < viewModel.top5CreatorsByConversions.count - 1 {
                    Divider()
                }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Helpers
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "€0"
    }
    
    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        OverviewView()
    }
    .environmentObject(DashboardViewModel())
}
