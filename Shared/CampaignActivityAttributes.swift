//
//  CampaignActivityAttributes.swift
//  AdPulse — Shared between App and Widget Extension targets
//
//  ActivityKit attributes describing a campaign Live Activity. This file is
//  intentionally placed in `Shared/` because both the App target and the
//  Widget Extension target need to compile against the same definition.
//
//  When you create the Widget Extension target in Xcode, add this file to
//  BOTH targets via File Inspector → Target Membership.
//

import ActivityKit
import Foundation

public struct CampaignActivityAttributes: ActivityAttributes {

    /// Mutable state — updated as the campaign accumulates conversions, ROAS, spend.
    public struct ContentState: Codable, Hashable {
        public var totalConversions: Int
        public var currentROAS: Double
        public var budgetSpent: Double
        public var lastUpdated: Date

        public init(totalConversions: Int, currentROAS: Double, budgetSpent: Double, lastUpdated: Date) {
            self.totalConversions = totalConversions
            self.currentROAS = currentROAS
            self.budgetSpent = budgetSpent
            self.lastUpdated = lastUpdated
        }
    }

    /// Immutable identity of the activity.
    public var campaignName: String
    public var productName: String

    public init(campaignName: String, productName: String) {
        self.campaignName = campaignName
        self.productName = productName
    }
}
