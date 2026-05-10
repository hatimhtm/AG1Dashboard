//
//  LiveActivityManager.swift
//  AdPulse
//
//  ActivityKit driver — starts / updates / ends a campaign Live Activity. The
//  attributes type lives in `Shared/CampaignActivityAttributes.swift` so the
//  Widget Extension target can compile against the same definition.
//

import ActivityKit
import Foundation
import OSLog

private let logger = Logger(subsystem: "com.hatim.adpulse", category: "LiveActivity")

// MARK: - Live Activity Manager
@MainActor
@Observable
final class LiveActivityManager {

    static let shared = LiveActivityManager()

    var currentActivity: Activity<CampaignActivityAttributes>?
    var isLiveActivitySupported: Bool = false

    private init() {
        refreshSupport()
    }

    // MARK: - Support detection
    private func refreshSupport() {
        if #available(iOS 16.1, *) {
            isLiveActivitySupported = ActivityAuthorizationInfo().areActivitiesEnabled
        }
    }

    // MARK: - Start
    func startTracking(
        campaignName: String,
        productName: String,
        conversions: Int,
        roas: Double,
        budget: Double
    ) {
        guard isLiveActivitySupported else { return }

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
                logger.error("Failed to start Live Activity: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    // MARK: - Update
    func updateActivity(conversions: Int, roas: Double, budget: Double) {
        guard let activity = currentActivity else { return }

        Task {
            let state = CampaignActivityAttributes.ContentState(
                totalConversions: conversions,
                currentROAS: roas,
                budgetSpent: budget,
                lastUpdated: Date()
            )
            await activity.update(ActivityContent(state: state, staleDate: nil))
        }
    }

    // MARK: - End
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

// MARK: - Integration helper on the dashboard
extension DashboardViewModel {

    /// Starts a Live Activity bound to the currently-filtered campaign cohort.
    func startLiveActivityTracking() {
        guard !filteredCreatives.isEmpty else { return }
        LiveActivityManager.shared.startTracking(
            campaignName: "Vital Campaigns",
            productName: "\(creativeCount) créas actives",
            conversions: totalConversions,
            roas: averageROAS,
            budget: totalBudget
        )
    }

    /// Pushes the latest aggregate metrics into the running activity.
    func updateLiveActivity() {
        LiveActivityManager.shared.updateActivity(
            conversions: totalConversions,
            roas: averageROAS,
            budget: totalBudget
        )
    }
}
