//
//  CreativesListView.swift
//  AG1Dashboard
//
//  Screen 2: Searchable List with iOS 17 Features
//  Showcases search suggestions, swipe actions, and modern list design
//

import SwiftUI

struct CreativesListView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var showFilters = false
    @State private var selectedCreative: Creative?
    
    // iOS 17 search suggestions
    @State private var recentSearches: [String] = ["UGC", "Podcast", "Emma", "AG1 Powder"]
    
    var body: some View {
        VStack(spacing: 0) {
            controlsBar
            
            if showFilters {
                filtersPanel
            }
            
            // Content
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.filteredCreatives.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "Aucun résultat",
                    message: "Essayez d'ajuster vos filtres ou votre recherche"
                )
            } else {
                creativesList
            }
        }
        .gradientBackground()
        .navigationTitle("Créas")
        .searchable(
            text: $viewModel.filterState.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Rechercher une créa, créateur, produit..."
        ) {
            // iOS 17 Search Suggestions
            if viewModel.filterState.searchText.isEmpty {
                ForEach(recentSearches, id: \.self) { suggestion in
                    Label(suggestion, systemImage: "clock.arrow.circlepath")
                        .searchCompletion(suggestion)
                }
                .searchSuggestionVisiblity(.visible)
            }
        }
        .sheet(item: $selectedCreative) { creative in
            CreativeQuickView(creative: creative)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Controls Bar
    private var controlsBar: some View {
        HStack {
            // Sort picker
            Menu {
                ForEach(SortOption.allCases) { option in
                    Button {
                        withAnimation(AppTheme.Animations.snappy) {
                            viewModel.filterState.sortOption = option
                        }
                        HapticsManager.selection()
                    } label: {
                        if viewModel.filterState.sortOption == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down")
                    Text(viewModel.filterState.sortOption.rawValue)
                }
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.regularMaterial)
                .clipShape(Capsule())
            }
            
            Spacer()
            
            // Filter toggle
            Button {
                withAnimation(AppTheme.Animations.spring) {
                    showFilters.toggle()
                }
                HapticsManager.impact(.light)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .symbolEffect(.bounce, value: showFilters)
                    Text("Filtres")
                    
                    if viewModel.filterState.hasActiveFilters {
                        Text("\(activeFilterCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 18, height: 18)
                            .background(AppTheme.Colors.accentBlue)
                            .clipShape(Circle())
                    }
                }
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(viewModel.filterState.hasActiveFilters ? AppTheme.Colors.accentBlue.opacity(0.15) : .regularMaterial)
                .foregroundStyle(viewModel.filterState.hasActiveFilters ? AppTheme.Colors.accentBlue : AppTheme.Colors.textPrimary)
                .clipShape(Capsule())
            }
            
            // Count
            Text("\(viewModel.filteredCreatives.count)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .contentTransition(.numericText())
                .padding(.leading, 8)
        }
        .padding()
    }
    
    private var activeFilterCount: Int {
        var count = 0
        if viewModel.filterState.productFilter != .all { count += 1 }
        if viewModel.filterState.monthFilter != .all { count += 1 }
        if viewModel.filterState.statusFilter != .all { count += 1 }
        if viewModel.filterState.contentTypeFilter != .all { count += 1 }
        return count
    }
    
    // MARK: - Filters Panel
    private var filtersPanel: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                FilterDropdown(title: "Produit", selection: $viewModel.filterState.productFilter)
                FilterDropdown(title: "Type", selection: $viewModel.filterState.contentTypeFilter)
            }
            
            HStack(spacing: 16) {
                FilterDropdown(title: "Mois", selection: $viewModel.filterState.monthFilter)
                FilterDropdown(title: "Statut", selection: $viewModel.filterState.statusFilter)
            }
            
            if viewModel.filterState.hasActiveFilters {
                Button {
                    withAnimation(AppTheme.Animations.bouncy) {
                        viewModel.filterState.resetFilters()
                    }
                    HapticsManager.notification(.warning)
                } label: {
                    Label("Réinitialiser tous les filtres", systemImage: "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // MARK: - List with Swipe Actions (iOS 17)
    private var creativesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredCreatives) { creative in
                    NavigationLink(destination: CreativeDetailView(creative: creative)) {
                        CreativeRow(creative: creative)
                    }
                    .buttonStyle(PressEffectButtonStyle())
                    .contextMenu {
                        // iOS Context Menu
                        Button {
                            selectedCreative = creative
                        } label: {
                            Label("Aperçu rapide", systemImage: "eye")
                        }
                        
                        Button {
                            // Share action
                            HapticsManager.notification(.success)
                        } label: {
                            Label("Partager", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            // Archive action
                        } label: {
                            Label("Archiver", systemImage: "archivebox")
                        }
                    } preview: {
                        // iOS 17 Context Menu Preview
                        CreativePreviewCard(creative: creative)
                    }
                }
            }
            .padding()
        }
        .refreshable {
            HapticsManager.notification(.success)
            viewModel.loadData()
        }
    }
}

// MARK: - Filter Dropdown
struct FilterDropdown<T: CaseIterable & Identifiable & RawRepresentable & Hashable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)
            
            Picker(title, selection: $selection) {
                ForEach(Array(T.allCases) as! [T], id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.Colors.textPrimary)
            .sensoryFeedback(.selection, trigger: selection)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Quick View Sheet (iOS 17 presentationDetents)
struct CreativeQuickView: View {
    let creative: Creative
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Status
                    StatusBadge(status: creative.status)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text(creative.adName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("\(creative.product) • \(creative.creator)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Quick KPIs
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        QuickKPI(title: "ROAS", value: String(format: "%.2f", creative.roas), color: .green)
                        QuickKPI(title: "Conversions", value: "\(creative.conversions)", color: .blue)
                        QuickKPI(title: "Budget", value: creative.budgetFormatted, color: .purple)
                        QuickKPI(title: "Revenu", value: creative.revenueFormatted, color: .orange)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Aperçu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QuickKPI: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Context Menu Preview Card
struct CreativePreviewCard: View {
    let creative: Creative
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(creative.adName)
                        .font(.headline)
                    Text(creative.product)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusBadge(status: creative.status)
            }
            
            HStack(spacing: 24) {
                VStack {
                    Text(String(format: "%.2f", creative.roas))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    Text("ROAS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(creative.conversions)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    Text("Conversions")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text(creative.budgetFormatted)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Budget")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(width: 320)
        .background(.regularMaterial)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CreativesListView()
    }
    .environmentObject(DashboardViewModel())
}
