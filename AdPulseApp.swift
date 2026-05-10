//
//  AdPulseApp.swift
//  AdPulse
//
//  Entry point for the AdPulse iOS app
//  A Meta Ads analytics dashboard for tracking creative performance
//

import SwiftUI

@main
struct AdPulseApp: App {

    // Main ViewModel shared across all views (iOS 17 @Observable + .environment)
    @State private var viewModel = DashboardViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        // SwiftData container — favorites + search history persist across launches.
        .modelContainer(for: [FavoriteCreative.self, SearchHistoryItem.self])
    }
}
