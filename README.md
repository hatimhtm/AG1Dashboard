# AG1 Dashboard - iOS App 📊

> Modern SwiftUI application for Meta Ads performance analytics.
> **iOS 17+ | Swift 5.9 | SwiftUI Charts**

## ✨ iOS 17+ Features

| Feature | Description |
|---------|-------------|
| 🎯 Symbol Effects | `.bounce`, `.pulse`, `.wiggle` animations |
| 📳 Sensory Feedback | Contextual haptics (selection, impact, notification) |
| 🔢 Content Transitions | `.numericText()` for animated KPIs |
| 📊 Chart Selection | Interactive chart selection |
| 🔍 Search Suggestions | Native search suggestions |
| 📱 Dynamic Island | Live Activities support for real-time tracking |
| 🎨 Material Backgrounds | `.regularMaterial` blur effects |

## 📱 Screens

### 1. Overview (Dashboard)
- 6 KPIs with `.bounce` animations
- ROAS/Month charts with interactive selection
- Budget/Product charts
- Top 5 creatives by ROAS
- Top 5 creators by conversions
- Pull-to-refresh with haptics

### 2. Creatives List
- Smart search with iOS 17 suggestions
- Filters: Product, Month, Status, Type
- Sort: ROAS ↑↓, Budget ↑↓, Conversions ↑↓
- Context menus with preview
- Swipe actions (favorite, archive)
- Presentation detents (adaptive sheet)

### 3. Creative Detail
- 8 selectable KPIs with feedback
- Flow layout for tags
- Staggered entry animations
- Quick actions (edit, duplicate, share)

## 🗂 Project Structure

```
AG1Dashboard/
├── AG1DashboardApp.swift          # Entry point
├── AG1-Data.csv                   # 1200 rows of mock data
├── Theme/
│   └── Theme.swift                # Complete design system
├── Models/
│   ├── Creative.swift             # Data model
│   └── FilterState.swift          # Observable filter state
├── ViewModels/
│   └── DashboardViewModel.swift   # Business logic + charts
├── Services/
│   ├── CSVParser.swift            # CSV parsing
│   └── LiveActivityManager.swift  # Dynamic Island support
└── Views/
    ├── ContentView.swift          # Adaptive navigation
    ├── Components/
    │   └── Components.swift       # 15+ reusable components
    └── Screens/
        ├── OverviewView.swift     # Dashboard with charts
        ├── CreativesListView.swift # Filterable list
        └── CreativeDetailView.swift # Detail view
```

## 🎨 Design System

```swift
// Colors
AppTheme.Colors.primary          // AG1 Green
AppTheme.Colors.background       // Light gradient
AppTheme.Colors.accentBlue/Purple/Cyan...

// Animations
AppTheme.Animations.smooth       // 0.3s easeInOut
AppTheme.Animations.bouncy       // Spring with bounce
AppTheme.Animations.snappy       // Quick response

// Styles
.cardStyle()                     // Cards with shadow
.gradientBackground()            // Gradient background
```

## 📊 Mock Data

The `AG1-Data.csv` file contains 1200 entries with:
- 7 products (AG1 Powder, Travel Packs, Vitamins...)
- 10 different creators
- 5 content types (UGC, Podcast, Video, Image, Testimonial)
- 8 marketing angles
- 5 months (July - November 2025)
- Various metrics (budget, conversions, ROAS, impressions...)

## 🚀 Installation

```bash
# 1. Clone the project
git clone https://github.com/hatimhtm/AG1Dashboard.git

# 2. Open in Xcode 15+
open AG1Dashboard.xcodeproj

# 3. Build & Run
# Target: iOS 17.0+ Simulator or Device
```

## 📦 Technologies

- **SwiftUI** - Declarative UI framework
- **Swift Charts** - Native charting
- **Combine** - Reactive programming
- **ActivityKit** - Live Activities
- **Observation** - @Observable macro (iOS 17)

## 🏗 Architecture

```
MVVM Clean Architecture
├── Models (Data layer)
├── ViewModels (Business logic)
├── Views (Presentation layer)
│   ├── Screens (Pages)
│   └── Components (Reusable)
└── Services (External interfaces)
```

## 📝 CSV Columns

| Column | Description |
|--------|-------------|
| Ad Name | Creative identifier |
| Product | Product category |
| Creator | Creator name |
| Content Type | UGC/Podcast/Video... |
| Marketing Angle | Primary hook |
| Month | Broadcast period |
| Status | Live/Stopped/Paused/Archived |
| Budget Spent (€) | Amount invested |
| Conversions | Number of purchases |
| ROAS | Return on Ad Spend |
| Impressions | Number of views |
| Clicks | Interactions |
| Click Rate (%) | CTR |

---

*Developed for ViralFactory - iOS Developer Assessment*
*iOS 17 | Swift 5.9 | SwiftUI*
