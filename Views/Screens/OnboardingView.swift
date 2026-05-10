//
//  OnboardingView.swift
//  AdPulse
//
//  Three-step intro shown on first launch. Sets `hasCompletedOnboarding`
//  via @AppStorage when the user finishes, so subsequent launches skip it.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage: Int = 0

    private let pages: [OnboardingPage] = [
        .init(
            symbol: "chart.line.uptrend.xyaxis",
            title: "Du brief à l'App Store",
            body: "AdPulse est un tableau de bord d'analytics créatives, conçu pour iOS 17 — Symbol Effects, Live Activities, et Swift Charts intégrés."
        ),
        .init(
            symbol: "magnifyingglass.circle",
            title: "Trouve les gagnants en un balayage",
            body: "Filtre par produit, mois, statut. Cherche par créateur ou angle. La détection d'anomalies en Z-score remonte les outliers automatiquement."
        ),
        .init(
            symbol: "bolt.heart",
            title: "Live Activities en pression",
            body: "Active le suivi en direct depuis les Réglages — la cohorte filtrée s'affiche dans la Dynamic Island et sur l'écran verrouillé."
        )
    ]

    var body: some View {
        ZStack {
            AppTheme.Colors.cream.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                bottomBar
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button("Passer") {
                finish()
            }
            .foregroundStyle(AppTheme.Colors.textSecondary)
            .disabled(currentPage == pages.count - 1)
            .opacity(currentPage == pages.count - 1 ? 0 : 1)

            Spacer()

            Button {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                    HapticsManager.selection()
                } else {
                    finish()
                }
            } label: {
                HStack(spacing: 8) {
                    Text(currentPage == pages.count - 1 ? "Commencer" : "Suivant")
                        .fontWeight(.semibold)
                    Image(systemName: currentPage == pages.count - 1 ? "checkmark" : "arrow.right")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppTheme.Colors.acid)
                .foregroundStyle(AppTheme.Colors.ink)
                .clipShape(Capsule())
            }
        }
        .padding()
    }

    private func finish() {
        HapticsManager.notification(.success)
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

// MARK: - Page model

private struct OnboardingPage {
    let symbol: String
    let title: String
    let body: String
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(AppTheme.Colors.acid)
                    .frame(width: 180, height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .strokeBorder(AppTheme.Colors.ink, lineWidth: 4)
                    )

                Image(systemName: page.symbol)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.ink)
                    .symbolEffect(.bounce, options: .repeating)
            }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text(page.body)
                    .font(.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer()
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(page.title). \(page.body)")
    }
}

#Preview {
    OnboardingView()
}
