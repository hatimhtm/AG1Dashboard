//
//  ContentView.swift
//  AG1Dashboard
//
//  Main navigation container
//  Adapts automatically: NavigationSplitView (iPad) or TabView (iPhone)
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var selectedTab: Tab = .overview
    @Environment(\.horizontalSizeClass) var sizeClass
    
    // Tab definition
    enum Tab: String, CaseIterable {
        case overview = "Overview"
        case creatives = "Créas"
        
        var icon: String {
            switch self {
            case .overview: return "chart.bar.fill"
            case .creatives: return "rectangle.grid.1x2.fill"
            }
        }
    }
    
    var body: some View {
        Group {
            if sizeClass == .regular {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - iPad: Sidebar navigation
    private var iPadLayout: some View {
        NavigationSplitView {
            List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
                Label(tab.rawValue, systemImage: tab.icon)
                    .tag(tab)
            }
            .navigationTitle("AG1 Dashboard")
        } detail: {
            switch selectedTab {
            case .overview:
                OverviewView()
            case .creatives:
                CreativesListView()
            }
        }
    }
    
    // MARK: - iPhone: Tab bar navigation
    private var iPhoneLayout: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                OverviewView()
            }
            .tabItem {
                Label(Tab.overview.rawValue, systemImage: Tab.overview.icon)
            }
            .tag(Tab.overview)
            
            NavigationStack {
                CreativesListView()
            }
            .tabItem {
                Label(Tab.creatives.rawValue, systemImage: Tab.creatives.icon)
            }
            .tag(Tab.creatives)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(DashboardViewModel())
}
