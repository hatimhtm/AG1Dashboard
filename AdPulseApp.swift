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
    
    // Main ViewModel shared across all views
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
