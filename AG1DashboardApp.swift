//
//  AG1DashboardApp.swift
//  AG1Dashboard
//
//  Entry point for the AG1 Dashboard iOS app
//  A Meta Ads analytics dashboard for tracking creative performance
//

import SwiftUI

@main
struct AG1DashboardApp: App {
    
    // Main ViewModel shared across all views
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
