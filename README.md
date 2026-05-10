<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/hero-banner-dark.svg" />
    <img src="assets/hero-banner.svg" alt="AdPulse — Creative Analytics for iOS" width="100%" />
  </picture>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/STATUS-TAKE_HOME_BUILD-CCFF00?style=for-the-badge&labelColor=1A1A1A" alt="Take-home build" />
  <img src="https://img.shields.io/badge/iOS-17%2B-1A1A1A?style=for-the-badge&logo=apple&logoColor=CCFF00" alt="iOS 17+" />
  <img src="https://img.shields.io/badge/SwiftUI-1A1A1A?style=for-the-badge&logo=swift&logoColor=CCFF00" alt="SwiftUI" />
</p>

<p align="center">
  <em>Creative analytics dashboard for iOS — built as a take-home for an iOS engineer interview. Demonstrates the full iOS 17 feature surface: Symbol Effects, Sensory Feedback, Live Activities, interactive Swift Charts, presentation detents, and the <code>@Observable</code> macro.</em>
</p>

---

### `/// THE BRIEF`

Build a native iOS dashboard for monitoring Meta Ads creative performance across products, creators, content types, and campaigns. The data: **1,200 rows** of mock campaign records spanning **5 months**, **7 products**, **10 creators**, **5 content types**, and **8 marketing angles**. The constraint: ship a polished, native-feeling iOS 17 app that shows you can use the platform, not just survive it.

---

### `/// iOS 17 SURFACE`

Every screen is a deliberate showcase of an iOS 17 API.

| Feature | Where it lives |
|---|---|
| `Symbol Effects` (`.bounce`, `.pulse`, `.wiggle`) | KPI tiles on the Overview screen |
| `.sensoryFeedback` (selection / impact / success) | Every selection, refresh, and primary action |
| `.contentTransition(.numericText())` | KPI counters animate when filters change |
| Interactive `Swift Charts` selection | ROAS-by-Month and Budget-by-Product charts |
| Native search `.searchSuggestions` | Creatives list smart search |
| `.presentationDetents` (adaptive sheets) | Filter sheets resize to their content |
| `Live Activities` + Dynamic Island (`ActivityKit`) | Real-time campaign tracking |
| `.regularMaterial` / `.ultraThinMaterial` | Card backgrounds, sheet chrome |
| `@Observable` macro | All view models — no `@Published` boilerplate |

---

### `/// SCREENS`

**Overview** — six headline KPIs with bounce animations · ROAS and Budget charts with interactive selection · Top 5 creatives by ROAS · Top 5 creators by conversions · pull-to-refresh with haptic feedback.

**Creatives List** — smart search powered by iOS 17 suggestions · filter by Product / Month / Status / Type · sort by ROAS, Budget, or Conversions · context menus with preview · swipe actions for favorite and archive · adaptive presentation detents.

**Creative Detail** — eight selectable KPIs with sensory feedback · flow-layout tag stack · staggered entry animations · quick actions (edit · duplicate · share).

---

### `/// ARCHITECTURE`

```
MVVM Clean
├── Models/             data + observable filter state
├── ViewModels/         business logic + chart computation
├── Views/
│   ├── Screens/        one file per top-level screen
│   └── Components/     ~15 reusable UI pieces
├── Services/           CSVParser, LiveActivityManager
└── Theme/              design tokens, animation curves, modifiers
```

Reactive surface uses Combine + the `@Observable` macro (iOS 17). Dynamic Island state is owned by `LiveActivityManager`. All data flow goes through `DashboardViewModel`.

---

### `/// SETUP`

```bash
git clone https://github.com/hatimhtm/adpulse-ios.git
cd adpulse-ios
# Open the folder in Xcode 15+, target an iOS 17.0+ simulator or device.
```

Mock data lives in `AdPulse-Data.csv` — 1,200 rows of campaign records for a fictional wellness brand (Vital). Column headers are in French (the original brief was for a French-speaking team); the data is parsed by `Services/CSVParser.swift`.

---

### `/// TECH`

`SwiftUI` · `Swift Charts` · `ActivityKit` · `Observation` (`@Observable`) · `Combine` · `MVVM Clean`

---

<p align="center">
  <a href="https://hatimelhassak.is-a.dev"><img src="https://img.shields.io/badge/PORTFOLIO-1A1A1A?style=for-the-badge&logo=vercel&logoColor=CCFF00" alt="Portfolio" /></a>
  <a href="https://cal.com/hatimelhassak/engineering-discovery"><img src="https://img.shields.io/badge/BOOK_A_CALL-CCFF00?style=for-the-badge&logo=googlecalendar&logoColor=1A1A1A" alt="Book a call" /></a>
  <a href="https://www.linkedin.com/in/hatim-elhassak/"><img src="https://img.shields.io/badge/LINKEDIN-1A1A1A?style=for-the-badge&logo=linkedin&logoColor=CCFF00" alt="LinkedIn" /></a>
  <a href="mailto:hatimelhassak.official@gmail.com"><img src="https://img.shields.io/badge/EMAIL-1A1A1A?style=for-the-badge&logo=gmail&logoColor=CCFF00" alt="Email" /></a>
</p>

<p align="center">
  <code>///&nbsp;&nbsp;OPEN FOR NEW WORK&nbsp;&nbsp;///&nbsp;&nbsp;CONTRACT &amp; FREELANCE&nbsp;&nbsp;///&nbsp;&nbsp;REMOTE WORLDWIDE&nbsp;&nbsp;///</code>
</p>
