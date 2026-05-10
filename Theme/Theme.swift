//
//  Theme.swift
//  AdPulse
//
//  Design System with iOS 17+ Features
//  Uses latest SwiftUI APIs for modern, polished UI
//

import SwiftUI

// MARK: - App Theme
struct AppTheme {
    
    // MARK: - Colors (brutalist palette — see ../CLAUDE.md for the brand spec)
    struct Colors {
        // Primary brutalist tokens
        static let ink      = Color(red: 0.10, green: 0.10, blue: 0.10)   // #1A1A1A
        static let cream    = Color(red: 1.00, green: 0.99, blue: 0.96)   // #FFFDF5
        static let acid     = Color(red: 0.80, green: 1.00, blue: 0.00)   // #CCFF00
        static let electric = Color(red: 0.00, green: 0.33, blue: 1.00)   // #0055FF
        static let hotpink  = Color(red: 1.00, green: 0.20, blue: 0.60)   // #FF3399
        static let vivid    = Color(red: 1.00, green: 0.40, blue: 0.00)   // #FF6600

        // Background — flat cream, gradient endpoints both cream-toned
        static let gradientStart = cream
        static let gradientEnd   = Color(red: 0.95, green: 0.94, blue: 0.91)
        static let cardBackground = cream
        static let cardShadow    = Color.black.opacity(0.10)

        // Text
        static let textPrimary   = ink
        static let textSecondary = ink.opacity(0.6)

        // Semantic accents — repointed to brutalist palette so the dashboard reads
        // as one coherent visual system. Names preserved so the views compile.
        static let accentGreen  = Color(red: 0.30, green: 0.75, blue: 0.40) // status / "good"
        static let accentBlue   = electric
        static let accentYellow = acid
        static let accentOrange = vivid
        static let accentPurple = Color(red: 0.55, green: 0.36, blue: 0.96)
        static let accentCyan   = Color(red: 0.02, green: 0.71, blue: 0.83)
        static let accentPink   = hotpink
        static let accentMint   = Color(red: 0.20, green: 0.75, blue: 0.65)

        // Status
        static let statusOnline   = accentGreen
        static let statusStopped  = Color(red: 0.95, green: 0.30, blue: 0.30)
        static let statusPaused   = vivid
        static let statusArchived = ink.opacity(0.4)

        // Chart gradient pairs
        static let chartGradientGreen  = [accentMint, accentGreen]
        static let chartGradientBlue   = [accentCyan, accentBlue]
        static let chartGradientPurple = [accentPink, accentPurple]
    }
    
    // MARK: - Dimensions
    struct Dimensions {
        static let cornerRadius: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 12
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 16
        static let cardPadding: CGFloat = 20
    }
    
    // MARK: - Animations (iOS 17 Spring Animations)
    struct Animations {
        static let smooth = Animation.smooth(duration: 0.3)
        static let snappy = Animation.snappy(duration: 0.25)
        static let bouncy = Animation.bouncy(duration: 0.4)
        static let spring = Animation.spring(duration: 0.5, bounce: 0.3)
    }
}

// MARK: - Gradient Background Modifier (iOS 17 style)
struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [AppTheme.Colors.gradientStart, AppTheme.Colors.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackground())
    }
}

// MARK: - Card Style Modifier (iOS 17 with subtle blur)
struct CardStyle: ViewModifier {
    var padding: CGFloat = AppTheme.Dimensions.cardPadding
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cardCornerRadius, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: AppTheme.Colors.cardShadow, radius: 12, x: 0, y: 4)
            )
    }
}

extension View {
    func cardStyle(padding: CGFloat = AppTheme.Dimensions.cardPadding) -> some View {
        modifier(CardStyle(padding: padding))
    }
}

// MARK: - Haptic Feedback Helper
struct HapticsManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Status Color Helper
extension String {
    var statusColor: Color {
        switch self.lowercased() {
        case "en ligne": return AppTheme.Colors.statusOnline
        case "arrêtée": return AppTheme.Colors.statusStopped
        case "en pause": return AppTheme.Colors.statusPaused
        case "archivée": return AppTheme.Colors.statusArchived
        default: return AppTheme.Colors.statusArchived
        }
    }
}

// MARK: - iOS 17 Symbol Effect Wrapper
struct AnimatedSymbol: View {
    let systemName: String
    let color: Color
    @State private var animate = false
    
    var body: some View {
        Image(systemName: systemName)
            .symbolEffect(.bounce, value: animate)
            .foregroundStyle(color)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    animate.toggle()
                }
            }
    }
}

// MARK: - Shimmer Loading Effect (iOS 17 style)
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: -geo.size.width + phase * geo.size.width * 3)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Press Effect (iOS 17 interaction feedback)
struct PressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.smooth(duration: 0.15), value: configuration.isPressed)
    }
}
