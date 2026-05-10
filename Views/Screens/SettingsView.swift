//
//  SettingsView.swift
//  AdPulse
//
//  Settings surface — appearance, sensory feedback, Live Activity tracking,
//  anomaly-detection thresholds, and data cleanup.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(DashboardViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // App-wide preferences
    @AppStorage("appearancePreference") private var appearancePreference: AppearancePreference = .system
    @AppStorage("sensoryFeedbackEnabled") private var sensoryFeedbackEnabled: Bool = true
    @AppStorage("anomalyDetectionEnabled") private var anomalyDetectionEnabled: Bool = true
    @AppStorage("anomalyZScoreThreshold") private var anomalyZScoreThreshold: Double = 2.0

    @Query private var favorites: [FavoriteCreative]
    @Query private var searchHistory: [SearchHistoryItem]

    @State private var liveActivityRunning = false

    var body: some View {
        Form {
            appearanceSection
            liveActivitySection
            anomalySection
            dataSection
            aboutSection
        }
        .navigationTitle("Réglages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Fermer") { dismiss() }
            }
        }
        .onAppear {
            liveActivityRunning = LiveActivityManager.shared.currentActivity != nil
        }
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        Section("Apparence") {
            Picker("Thème", selection: $appearancePreference) {
                ForEach(AppearancePreference.allCases) { option in
                    Text(option.label).tag(option)
                }
            }

            Toggle("Retours haptiques", isOn: $sensoryFeedbackEnabled)
        }
    }

    // MARK: - Live Activity

    private var liveActivitySection: some View {
        Section {
            Toggle(isOn: Binding(
                get: { liveActivityRunning },
                set: { newValue in
                    if newValue {
                        viewModel.startLiveActivityTracking()
                        HapticsManager.notification(.success)
                    } else {
                        Task { await LiveActivityManager.shared.endCurrentActivity() }
                        HapticsManager.notification(.warning)
                    }
                    liveActivityRunning = newValue
                }
            )) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Suivre la cohorte filtrée")
                    Text(LiveActivityManager.shared.isLiveActivitySupported
                         ? "Affiche les KPI dans la Dynamic Island"
                         : "Live Activities non disponibles sur cet appareil")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .disabled(!LiveActivityManager.shared.isLiveActivitySupported)
        } header: {
            Text("Live Activity")
        }
    }

    // MARK: - Anomaly Detection

    private var anomalySection: some View {
        Section {
            Toggle("Détection d'anomalies", isOn: $anomalyDetectionEnabled)

            if anomalyDetectionEnabled {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Seuil (Z-score)")
                        Spacer()
                        Text(String(format: "%.1fσ", anomalyZScoreThreshold))
                            .font(.callout.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $anomalyZScoreThreshold, in: 1.0...3.5, step: 0.1)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Seuil d'anomalie")
                .accessibilityValue("\(String(format: "%.1f", anomalyZScoreThreshold)) écarts-types")
            }
        } header: {
            Text("Anomalies")
        } footer: {
            if anomalyDetectionEnabled {
                Text("Les créas dont le ROAS s'écarte du seuil par rapport à la cohorte déclenchent un signal.")
            }
        }
    }

    // MARK: - Data

    private var dataSection: some View {
        Section("Données") {
            HStack {
                Label("Favoris", systemImage: "star.fill")
                Spacer()
                Text("\(favorites.count)")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Label("Historique de recherche", systemImage: "clock.arrow.circlepath")
                Spacer()
                Text("\(searchHistory.count)")
                    .foregroundStyle(.secondary)
            }

            Button(role: .destructive) {
                clearSearchHistory()
            } label: {
                Label("Effacer l'historique de recherche", systemImage: "trash")
            }
            .disabled(searchHistory.isEmpty)

            Button(role: .destructive) {
                clearFavorites()
            } label: {
                Label("Effacer les favoris", systemImage: "trash.slash")
            }
            .disabled(favorites.isEmpty)

            Button {
                viewModel.loadData()
                HapticsManager.notification(.success)
            } label: {
                Label("Recharger les données", systemImage: "arrow.clockwise")
            }
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section("À propos") {
            HStack {
                Text("Version")
                Spacer()
                Text(appVersion)
                    .foregroundStyle(.secondary)
            }
            Link(destination: URL(string: "https://github.com/hatimhtm/adpulse-ios")!) {
                Label("Code source (GitHub)", systemImage: "chevron.left.forwardslash.chevron.right")
            }
            Link(destination: URL(string: "https://hatimelhassak.is-a.dev")!) {
                Label("Portfolio", systemImage: "person.crop.circle")
            }
        }
    }

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    // MARK: - Actions

    private func clearSearchHistory() {
        for item in searchHistory {
            modelContext.delete(item)
        }
        try? modelContext.save()
        HapticsManager.notification(.warning)
    }

    private func clearFavorites() {
        for fav in favorites {
            modelContext.delete(fav)
        }
        try? modelContext.save()
        HapticsManager.notification(.warning)
    }
}

// MARK: - Appearance Preference

enum AppearancePreference: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "Système"
        case .light:  return "Clair"
        case .dark:   return "Sombre"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(DashboardViewModel())
            .modelContainer(for: [FavoriteCreative.self, SearchHistoryItem.self], inMemory: true)
    }
}
