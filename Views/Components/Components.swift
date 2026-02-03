//
//  Components.swift
//  AG1Dashboard
//
//  Reusable UI Components with iOS 17 Features
//  Includes animations, haptics, and modern interactions
//

import SwiftUI

// MARK: - KPI Card (with iOS 17 symbol animation)
struct KPICard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    var trend: Double? = nil  // Optional trend indicator
    
    @State private var isAppeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Animated icon
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .symbolEffect(.bounce, value: isAppeared)
                
                Spacer()
                
                // Trend indicator (if provided)
                if let trend = trend {
                    TrendBadge(value: trend)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .contentTransition(.numericText())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        .onAppear {
            withAnimation(AppTheme.Animations.bouncy.delay(0.2)) {
                isAppeared = true
            }
        }
    }
}

// MARK: - Trend Badge
struct TrendBadge: View {
    let value: Double
    
    private var isPositive: Bool { value >= 0 }
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2)
                .fontWeight(.bold)
            
            Text("\(abs(value), specifier: "%.1f")%")
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .foregroundStyle(isPositive ? AppTheme.Colors.accentGreen : AppTheme.Colors.statusStopped)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((isPositive ? AppTheme.Colors.accentGreen : AppTheme.Colors.statusStopped).opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Filter Pill (with haptic feedback)
struct FilterPill<Content: View>: View {
    let title: String
    let value: String
    let isActive: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        Menu {
            content
        } label: {
            HStack(spacing: 6) {
                Text(isActive ? value : title)
                    .font(.subheadline)
                    .fontWeight(isActive ? .semibold : .regular)
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isActive ? AppTheme.Colors.accentBlue.opacity(0.15) : .regularMaterial)
            .foregroundStyle(isActive ? AppTheme.Colors.accentBlue : AppTheme.Colors.textPrimary)
            .clipShape(Capsule())
        }
        .sensoryFeedback(.selection, trigger: isActive)
    }
}

// MARK: - Ranking Row (with position animation)
struct RankingRow: View {
    let rank: Int
    let title: String
    let subtitle: String?
    let value: String
    let valueColor: Color
    
    @State private var isAppeared = false
    
    private var rankColor: Color {
        switch rank {
        case 1: return Color(red: 0.95, green: 0.75, blue: 0.3)
        case 2: return Color(red: 0.7, green: 0.7, blue: 0.75)
        case 3: return Color(red: 0.9, green: 0.6, blue: 0.4)
        default: return AppTheme.Colors.accentBlue.opacity(0.7)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank badge with glow for top 3
            ZStack {
                if rank <= 3 {
                    Circle()
                        .fill(rankColor.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .blur(radius: 4)
                }
                
                Text("\(rank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(rankColor)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(valueColor)
                .contentTransition(.numericText())
        }
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -20)
        .onAppear {
            withAnimation(AppTheme.Animations.smooth.delay(Double(rank) * 0.1)) {
                isAppeared = true
            }
        }
    }
}

// MARK: - Status Badge (with pulse animation for online)
struct StatusBadge: View {
    let status: String
    
    private var color: Color { status.statusColor }
    private var isOnline: Bool { status.lowercased() == "en ligne" }
    
    @State private var isPulsing = false
    
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                if isOnline {
                    Circle()
                        .fill(color.opacity(0.4))
                        .frame(width: 12, height: 12)
                        .scaleEffect(isPulsing ? 1.5 : 1.0)
                        .opacity(isPulsing ? 0 : 1)
                }
                
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
            
            Text(status)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
        .onAppear {
            if isOnline {
                withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
        }
    }
}

// MARK: - Creative Row (with press effect)
struct CreativeRow: View {
    let creative: Creative
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(creative.adName)
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                StatusBadge(status: creative.status)
            }
            
            // Metadata
            HStack(spacing: 16) {
                Label(creative.product, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                
                Label(creative.creator, systemImage: "person.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            
            Divider()
            
            // KPIs
            HStack(spacing: 0) {
                MiniKPI(label: "Budget", value: creative.budgetFormatted)
                MiniKPI(label: "Conv.", value: "\(creative.conversions)")
                MiniKPI(label: "ROAS", value: String(format: "%.2f", creative.roas), highlight: creative.roas >= 2.0)
                MiniKPI(label: "CPC", value: creative.costPerConversionFormatted)
            }
        }
        .cardStyle()
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.smooth(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
            if pressing {
                HapticsManager.impact(.light)
            }
        }, perform: {})
    }
}

// MARK: - Mini KPI
struct MiniKPI: View {
    let label: String
    let value: String
    var highlight: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(AppTheme.Colors.textSecondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(highlight ? AppTheme.Colors.accentGreen : AppTheme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .symbolEffect(.pulse)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            
            Text("Chargement...")
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Previews
#Preview("KPI Card") {
    KPICard(
        icon: "eurosign.circle.fill",
        title: "Budget dépensé",
        value: "€125,450",
        color: AppTheme.Colors.accentBlue,
        trend: 12.5
    )
    .padding()
    .gradientBackground()
}

#Preview("Creative Row") {
    CreativeRow(creative: .sample)
        .padding()
        .gradientBackground()
}

#Preview("Status Badges") {
    VStack(spacing: 12) {
        StatusBadge(status: "En ligne")
        StatusBadge(status: "Arrêtée")
        StatusBadge(status: "En pause")
        StatusBadge(status: "Archivée")
    }
    .padding()
}
