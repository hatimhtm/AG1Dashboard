//
//  AnomalyDetector.swift
//  AdPulse
//
//  Z-score anomaly detection on ROAS. Returns creatives whose ROAS sits at
//  least `zThreshold` standard deviations from the cohort mean — both ends
//  of the distribution (over- and under-performers) are surfaced so the
//  operator can decide what to scale and what to kill.
//

import Foundation

struct AnomalyDetector {

    struct Anomaly {
        let creative: Creative
        let zScore: Double

        /// Magnitude of the deviation, regardless of direction.
        var magnitude: Double { abs(zScore) }

        /// Convenience: positive z = outlier above the mean (winning), negative = below (losing).
        var direction: Direction { zScore >= 0 ? .above : .below }

        enum Direction { case above, below }
    }

    /// Computes z-scores against the cohort mean ROAS and returns those that
    /// exceed the threshold, sorted by absolute magnitude (most extreme first).
    /// Cohorts smaller than 5 are ignored — too noisy to be useful.
    static func detect(in creatives: [Creative], zThreshold: Double = 2.0) -> [Anomaly] {
        guard creatives.count >= 5 else { return [] }

        let roases = creatives.map(\.roas)
        let mean = roases.reduce(0, +) / Double(roases.count)
        let variance = roases.map { pow($0 - mean, 2) }.reduce(0, +) / Double(roases.count)
        let stdDev = sqrt(variance)
        guard stdDev > 0 else { return [] }

        return creatives
            .map { Anomaly(creative: $0, zScore: ($0.roas - mean) / stdDev) }
            .filter { $0.magnitude >= zThreshold }
            .sorted { $0.magnitude > $1.magnitude }
    }
}
