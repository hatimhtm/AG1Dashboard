//
//  ContentView.swift
//  AdPulse
//
//  Main navigation container
//  Adapts automatically: NavigationSplitView (iPad) or TabView (iPhone)
//

import SwiftUI

struct ContentView: View {
    @Environment(DashboardViewModel.self) private var viewModel
    @State private var selectedTab: Tab = .overview
    @State private var showSettings = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    enum Tab: String, CaseIterable {
        case overview = "Overview"
        case creatives = "Créas"

        var icon: String {
            switch self {
            case .overview:  return "chart.bar.fill"
            case .creatives: return "rectangle.grid.1x2.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                OverviewView()
                    .adPulseSettingsToolbar(showSettings: $showSettings)
            }
            .tabItem { Label(Tab.overview.rawValue, systemImage: Tab.overview.icon) }
            .tag(Tab.overview)

            NavigationStack {
                CreativesListView()
                    .adPulseSettingsToolbar(showSettings: $showSettings)
            }
            .tabItem { Label(Tab.creatives.rawValue, systemImage: Tab.creatives.icon) }
            .tag(Tab.creatives)
        }
        .onAppear { viewModel.loadData() }
        .sheet(isPresented: $showSettings) {
            NavigationStack { SettingsView() }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasCompletedOnboarding },
            set: { hasCompletedOnboarding = !$0 }
        )) {
            OnboardingView()
        }
    }
}

// MARK: - Settings toolbar modifier

private extension View {
    /// Adds a top-trailing "gear" button that toggles the supplied binding.
    /// Defined as a View extension (not a returning ToolbarContent) because
    /// `toolbar(content:)` has multiple overloads and a function returning
    /// `some ToolbarContent` resolves ambiguously at the call site.
    func adPulseSettingsToolbar(showSettings: Binding<Bool>) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSettings.wrappedValue = true
                    HapticsManager.selection()
                } label: {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("Réglages")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environment(DashboardViewModel())
}
