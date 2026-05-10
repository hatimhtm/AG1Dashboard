//
//  AdPulseWidgetBundle.swift
//  AdPulseWidgets — main entry for the Widget Extension target
//
//  Add this file to the Widget Extension target only. Future home-screen
//  widgets (e.g. a top-KPIs widget) can be appended to the body below.
//

import SwiftUI
import WidgetKit

@main
struct AdPulseWidgetBundle: WidgetBundle {
    var body: some Widget {
        CampaignLiveActivity()
    }
}
