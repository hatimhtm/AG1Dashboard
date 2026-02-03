//
//  LiveActivityManager.swift
//  AG1Dashboard
//
//  Live Activities Support for Dynamic Island (iOS 16.1+)
//  Shows real-time campaign performance on lock screen and Dynamic Island
//

import Foundation
import ActivityKit
import SwiftUI

// MARK: - Live Activity Attributes
struct CampaignActivityAttributes: ActivityAttributes {
    
    // Static content that doesn't change
    public struct ContentState: Codable, Hashable {
        var totalConversions: Int
        var currentROAS: Double
        var budgetSpent: Double
        var lastUpdated: Date
    }
    
    // Fixed data
    var campaignName: String
    var productName: String
}

// MARK: - Live Activity Manager
@MainActor
class LiveActivityManager: ObservableObject {
    
    static let shared = LiveActivityManager()
    
    @Published var currentActivity: Activity<CampaignActivityAttributes>?
    @Published var isLiveActivitySupported: Bool = false
    
    private init() {
        checkSupport()
    }
    
    // MARK: - Check Support
    private func checkSupport() {
        if #available(iOS 16.1, *) {
            isLiveActivitySupported = ActivityAuthorizationInfo().areActivitiesEnabled
        }
    }
    
    // MARK: - Start Live Activity
    func startTracking(
        campaignName: String,
        productName: String,
        conversions: Int,
        roas: Double,
        budget: Double
    ) {
        guard isLiveActivitySupported else { return }
        
        // End any existing activity
        Task {
            await endCurrentActivity()
            
            let attributes = CampaignActivityAttributes(
                campaignName: campaignName,
                productName: productName
            )
            
            let state = CampaignActivityAttributes.ContentState(
                totalConversions: conversions,
                currentROAS: roas,
                budgetSpent: budget,
                lastUpdated: Date()
            )
            
            do {
                let activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil),
                    pushType: nil
                )
                currentActivity = activity
            } catch {
                print("Failed to start Live Activity: \(error)")
            }
        }
    }
    
    // MARK: - Update Live Activity
    func updateActivity(
        conversions: Int,
        roas: Double,
        budget: Double
    ) {
        guard let activity = currentActivity else { return }
        
        Task {
            let state = CampaignActivityAttributes.ContentState(
                totalConversions: conversions,
                currentROAS: roas,
                budgetSpent: budget,
                lastUpdated: Date()
            )
            
            await activity.update(
                ActivityContent(state: state, staleDate: nil)
            )
        }
    }
    
    // MARK: - End Live Activity
    func endCurrentActivity() async {
        guard let activity = currentActivity else { return }
        
        let state = activity.content.state
        await activity.end(
            ActivityContent(state: state, staleDate: nil),
            dismissalPolicy: .immediate
        )
        currentActivity = nil
    }
}

// MARK: - Live Activity Widget View (for Widget Extension)
/*
 Add this to a Widget Extension target:
 
 struct CampaignLiveActivity: Widget {
     var body: some WidgetConfiguration {
         ActivityConfiguration(for: CampaignActivityAttributes.self) { context in
             // Lock Screen View
             LockScreenView(context: context)
         } dynamicIsland: { context in
             DynamicIsland {
                 // Expanded regions
                 DynamicIslandExpandedRegion(.leading) {
                     Label {
                         Text("\(context.state.totalConversions)")
                             .fontWeight(.bold)
                     } icon: {
                         Image(systemName: "cart.fill")
                     }
                 }
                 DynamicIslandExpandedRegion(.trailing) {
                     Label {
                         Text(String(format: "%.2f", context.state.currentROAS))
                             .fontWeight(.bold)
                     } icon: {
                         Image(systemName: "chart.line.uptrend.xyaxis")
                     }
                 }
                 DynamicIslandExpandedRegion(.center) {
                     Text(context.attributes.campaignName)
                         .font(.headline)
                 }
                 DynamicIslandExpandedRegion(.bottom) {
                     ProgressView(value: min(context.state.budgetSpent / 10000, 1.0))
                         .tint(.green)
                 }
             } compactLeading: {
                 Image(systemName: "chart.bar.fill")
                     .foregroundStyle(.green)
             } compactTrailing: {
                 Text("\(context.state.totalConversions)")
                     .fontWeight(.bold)
             } minimal: {
                 Image(systemName: "chart.bar.fill")
                     .foregroundStyle(.green)
             }
         }
     }
 }
 
 struct LockScreenView: View {
     let context: ActivityViewContext<CampaignActivityAttributes>
     
     var body: some View {
         VStack(spacing: 12) {
             HStack {
                 VStack(alignment: .leading) {
                     Text(context.attributes.campaignName)
                         .font(.headline)
                     Text(context.attributes.productName)
                         .font(.caption)
                         .foregroundStyle(.secondary)
                 }
                 Spacer()
                 Image(systemName: "chart.bar.fill")
                     .font(.title)
                     .foregroundStyle(.green)
             }
             
             HStack(spacing: 24) {
                 VStack {
                     Text("\(context.state.totalConversions)")
                         .font(.title2)
                         .fontWeight(.bold)
                     Text("Conversions")
                         .font(.caption2)
                         .foregroundStyle(.secondary)
                 }
                 
                 VStack {
                     Text(String(format: "%.2f", context.state.currentROAS))
                         .font(.title2)
                         .fontWeight(.bold)
                         .foregroundStyle(.green)
                     Text("ROAS")
                         .font(.caption2)
                         .foregroundStyle(.secondary)
                 }
                 
                 VStack {
                     Text("€\(Int(context.state.budgetSpent))")
                         .font(.title2)
                         .fontWeight(.bold)
                     Text("Budget")
                         .font(.caption2)
                         .foregroundStyle(.secondary)
                 }
             }
         }
         .padding()
     }
 }
*/

// MARK: - Integration Helper for Dashboard
extension DashboardViewModel {
    
    /// Starts a Live Activity to track campaign performance
    func startLiveActivityTracking() {
        guard !filteredCreatives.isEmpty else { return }
        
        LiveActivityManager.shared.startTracking(
            campaignName: "AG1 Campaigns",
            productName: "\(creativeCount) créas actives",
            conversions: totalConversions,
            roas: averageROAS,
            budget: totalBudget
        )
    }
    
    /// Updates the Live Activity with current data
    func updateLiveActivity() {
        LiveActivityManager.shared.updateActivity(
            conversions: totalConversions,
            roas: averageROAS,
            budget: totalBudget
        )
    }
}
