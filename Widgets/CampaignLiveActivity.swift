//
//  CampaignLiveActivity.swift
//  AdPulseWidgets
//
//  The Live Activity surface — Lock Screen card + Dynamic Island regions.
//  References `CampaignActivityAttributes` from `Shared/`. When you create
//  the Widget Extension target, add `Shared/CampaignActivityAttributes.swift`
//  to its Target Membership.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct CampaignLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CampaignActivityAttributes.self) { context in
            // Lock Screen / banner presentation
            LockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.10, green: 0.10, blue: 0.10))
                .activitySystemActionForegroundColor(Color(red: 0.80, green: 1.00, blue: 0.00))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text("\(context.state.totalConversions)")
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                    } icon: {
                        Image(systemName: "cart.fill")
                            .foregroundStyle(Color(red: 0.80, green: 1.00, blue: 0.00))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text(String(format: "%.2f", context.state.currentROAS))
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                    } icon: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundStyle(Color(red: 0.80, green: 1.00, blue: 0.00))
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.campaignName)
                        .font(.headline)
                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: min(context.state.budgetSpent / 10_000, 1.0))
                        .tint(Color(red: 0.80, green: 1.00, blue: 0.00))
                }
            } compactLeading: {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Color(red: 0.80, green: 1.00, blue: 0.00))
            } compactTrailing: {
                Text("\(context.state.totalConversions)")
                    .fontWeight(.bold)
                    .contentTransition(.numericText())
            } minimal: {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Color(red: 0.80, green: 1.00, blue: 0.00))
            }
        }
    }
}

// MARK: - Lock Screen View

struct LockScreenView: View {
    let context: ActivityViewContext<CampaignActivityAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.attributes.campaignName)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(context.attributes.productName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundStyle(Color(red: 0.80, green: 1.00, blue: 0.00))
            }

            HStack(spacing: 24) {
                metric(value: "\(context.state.totalConversions)", label: "Conversions")
                metric(
                    value: String(format: "%.2f", context.state.currentROAS),
                    label: "ROAS",
                    accent: true
                )
                metric(value: "€\(Int(context.state.budgetSpent))", label: "Budget")
            }
        }
        .padding(16)
    }

    private func metric(value: String, label: String, accent: Bool = false) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(accent ? Color(red: 0.80, green: 1.00, blue: 0.00) : .white)
                .contentTransition(.numericText())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}
