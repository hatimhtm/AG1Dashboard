//
//  FavoriteCreative.swift
//  AdPulse
//
//  SwiftData model for persisted favorite creatives.
//  Identified by `adName` (the CSV column "Nom de l'annonce") because the
//  in-memory Creative struct generates a fresh UUID on each parse — we need
//  a stable string key that survives app launches.
//

import Foundation
import SwiftData

@Model
final class FavoriteCreative {
    @Attribute(.unique) var adName: String
    var dateAdded: Date

    init(adName: String, dateAdded: Date = Date()) {
        self.adName = adName
        self.dateAdded = dateAdded
    }
}
