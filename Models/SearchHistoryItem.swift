//
//  SearchHistoryItem.swift
//  AdPulse
//
//  SwiftData model for persisted search history. Each entry tracks the
//  query string, when it was last used, and a hit count so we can rank
//  popular searches above forgotten ones.
//

import Foundation
import SwiftData

@Model
final class SearchHistoryItem {
    @Attribute(.unique) var query: String
    var lastUsed: Date
    var useCount: Int

    init(query: String, lastUsed: Date = Date(), useCount: Int = 1) {
        self.query = query
        self.lastUsed = lastUsed
        self.useCount = useCount
    }
}
