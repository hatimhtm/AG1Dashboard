//
//  CreativeDetailView.swift
//  AG1Dashboard
//
//  Screen 3: Detailed View with iOS 17 Features
//  Showcases advanced layouts, animations, and modern interactions
//

import SwiftUI

struct CreativeDetailView: View {
    let creative: Creative
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss
    
    @State private var showShareSheet = false
    @State private var selectedMetric: String?
    @State private var isAnimated = false
    
    // Adaptive grid
    private var kpiColumns: [GridItem] {
        if sizeClass == .regular {
            return Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        } else {
            return Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerCard
                performanceSection
                metadataSection
                creativeInfoSection
                actionsSection
            }
            .padding()
        }
        .gradientBackground()
        .navigationTitle(creative.adName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showShareSheet = true
                        HapticsManager.notification(.success)
                    } label: {
                        Label("Partager", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        HapticsManager.impact(.medium)
                    } label: {
                        Label("Dupliquer", systemImage: "plus.square.on.square")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        HapticsManager.notification(.warning)
                    } label: {
                        Label("Archiver", systemImage: "archivebox")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .onAppear {
            withAnimation(AppTheme.Animations.smooth.delay(0.2)) {
                isAnimated = true
            }
        }
    }
    
    // MARK: - Header Card with Status Animation
    private var headerCard: some View {
        VStack(spacing: 16) {
            // Creative thumbnail placeholder with gradient
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                creative.status.statusColor.opacity(0.3),
                                creative.status.statusColor.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                
                VStack(spacing: 8) {
                    Image(systemName: contentTypeIcon)
                        .font(.system(size: 40))
                        .foregroundStyle(creative.status.statusColor)
                        .symbolEffect(.bounce, value: isAnimated)
                    
                    Text(creative.contentType)
                        .font(.caption)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
            
            // Title and meta
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(creative.adName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        
                        HStack(spacing: 12) {
                            Label(creative.product, systemImage: "tag.fill")
                            Label(creative.creator, systemImage: "person.fill")
                        }
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: creative.status)
                }
            }
        }
        .cardStyle()
    }
    
    private var contentTypeIcon: String {
        switch creative.contentType.lowercased() {
        case "ugc": return "person.crop.rectangle.stack.fill"
        case "podcast": return "mic.fill"
        case "motion/vidéo": return "play.rectangle.fill"
        case "image statique": return "photo.fill"
        case "témoignage": return "quote.bubble.fill"
        default: return "rectangle.stack.fill"
        }
    }
    
    // MARK: - Performance Section with Animated KPIs
    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Performance")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                // ROAS indicator
                HStack(spacing: 4) {
                    Image(systemName: creative.roas >= 2 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                    Text(creative.roas >= 2 ? "Rentable" : "À optimiser")
                        .font(.caption)
                }
                .foregroundStyle(creative.roas >= 2 ? AppTheme.Colors.accentGreen : AppTheme.Colors.accentOrange)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background((creative.roas >= 2 ? AppTheme.Colors.accentGreen : AppTheme.Colors.accentOrange).opacity(0.15))
                .clipShape(Capsule())
            }
            
            // KPI Grid
            LazyVGrid(columns: kpiColumns, spacing: 12) {
                DetailKPI(
                    icon: "eurosign.circle.fill",
                    value: creative.budgetFormatted,
                    label: "Budget",
                    color: AppTheme.Colors.accentBlue,
                    isSelected: selectedMetric == "budget",
                    delay: 0
                )
                .onTapGesture {
                    withAnimation(AppTheme.Animations.snappy) {
                        selectedMetric = selectedMetric == "budget" ? nil : "budget"
                    }
                    HapticsManager.selection()
                }
                
                DetailKPI(
                    icon: "cart.fill",
                    value: "\(creative.conversions)",
                    label: "Conversions",
                    color: AppTheme.Colors.accentGreen,
                    isSelected: selectedMetric == "conversions",
                    delay: 0.05
                )
                .onTapGesture {
                    withAnimation(AppTheme.Animations.snappy) {
                        selectedMetric = selectedMetric == "conversions" ? nil : "conversions"
                    }
                    HapticsManager.selection()
                }
                
                DetailKPI(
                    icon: "arrow.up.right.circle.fill",
                    value: String(format: "%.2f", creative.roas),
                    label: "ROAS",
                    color: creative.roas >= 2 ? AppTheme.Colors.accentGreen : AppTheme.Colors.accentOrange,
                    isSelected: selectedMetric == "roas",
                    delay: 0.1
                )
                .onTapGesture {
                    withAnimation(AppTheme.Animations.snappy) {
                        selectedMetric = selectedMetric == "roas" ? nil : "roas"
                    }
                    HapticsManager.selection()
                }
                
                DetailKPI(
                    icon: "creditcard.fill",
                    value: creative.costPerConversionFormatted,
                    label: "Coût/Conv.",
                    color: AppTheme.Colors.accentPurple,
                    isSelected: selectedMetric == "cpc",
                    delay: 0.15
                )
                .onTapGesture {
                    withAnimation(AppTheme.Animations.snappy) {
                        selectedMetric = selectedMetric == "cpc" ? nil : "cpc"
                    }
                    HapticsManager.selection()
                }
                
                DetailKPI(
                    icon: "banknote.fill",
                    value: creative.revenueFormatted,
                    label: "Revenu",
                    color: AppTheme.Colors.accentCyan,
                    isSelected: selectedMetric == "revenue",
                    delay: 0.2
                )
                
                DetailKPI(
                    icon: "eye.fill",
                    value: formatNumber(creative.impressions),
                    label: "Impressions",
                    color: AppTheme.Colors.accentBlue,
                    isSelected: selectedMetric == "impressions",
                    delay: 0.25
                )
                
                DetailKPI(
                    icon: "hand.tap.fill",
                    value: formatNumber(creative.clicks),
                    label: "Clics",
                    color: AppTheme.Colors.accentYellow,
                    isSelected: selectedMetric == "clicks",
                    delay: 0.3
                )
                
                DetailKPI(
                    icon: "percent",
                    value: String(format: "%.2f%%", creative.clickRate),
                    label: "Taux de clic",
                    color: AppTheme.Colors.accentOrange,
                    isSelected: selectedMetric == "ctr",
                    delay: 0.35
                )
            }
        }
        .cardStyle()
    }
    
    // MARK: - Metadata Section
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informations")
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            
            VStack(spacing: 0) {
                MetadataRow(icon: "calendar", label: "Mois", value: creative.month)
                Divider().padding(.vertical, 10)
                MetadataRow(icon: "target", label: "Angle marketing", value: creative.marketingAngle)
                Divider().padding(.vertical, 10)
                MetadataRow(icon: "quote.bubble", label: "Hook", value: creative.hook)
                
                if let date = creative.launchDate {
                    Divider().padding(.vertical, 10)
                    MetadataRow(
                        icon: "clock",
                        label: "Date de lancement",
                        value: date.formatted(date: .abbreviated, time: .omitted)
                    )
                }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Creative Info Section
    private var creativeInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Détails de la créa")
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            
            // Tags
            FlowLayout(spacing: 8) {
                InfoTag(text: creative.contentType, color: AppTheme.Colors.accentBlue)
                InfoTag(text: creative.product, color: AppTheme.Colors.accentPurple)
                InfoTag(text: creative.creator, color: AppTheme.Colors.accentGreen)
                InfoTag(text: creative.status, color: creative.status.statusColor)
            }
        }
        .cardStyle()
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        HStack(spacing: 12) {
            ActionButton(title: "Éditer", icon: "pencil", color: AppTheme.Colors.accentBlue)
            ActionButton(title: "Dupliquer", icon: "plus.square.on.square", color: AppTheme.Colors.accentPurple)
            ActionButton(title: "Partager", icon: "square.and.arrow.up", color: AppTheme.Colors.accentGreen)
        }
    }
    
    // MARK: - Helpers
    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}

// MARK: - Detail KPI with Animation
struct DetailKPI: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    var isSelected: Bool = false
    var delay: Double = 0
    
    @State private var isAppeared = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .symbolEffect(.bounce, value: isSelected)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .contentTransition(.numericText())
            
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(color.opacity(isSelected ? 0.2 : 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(isSelected ? color : .clear, lineWidth: 2)
                )
        )
        .scaleEffect(isAppeared ? 1 : 0.8)
        .opacity(isAppeared ? 1 : 0)
        .onAppear {
            withAnimation(AppTheme.Animations.bouncy.delay(delay)) {
                isAppeared = true
            }
        }
    }
}

// MARK: - Metadata Row
struct MetadataRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Info Tag
struct InfoTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button {
            HapticsManager.impact(.medium)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(color)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(PressEffectButtonStyle())
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .init(frame.size))
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var frames: [CGRect] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        
        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CreativeDetailView(creative: .sample)
    }
}
