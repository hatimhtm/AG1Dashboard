# Tests

The `AdPulseTests` target is **already wired up** in `AdPulse.xcodeproj`. Just hit `⌘U`.

## Coverage

- **CSVParserTests** — valid row, empty input, malformed rows, euro/comma cleanup
- **DashboardViewModelTests** — KPI math (`totalBudget`, `averageROAS`), filter predicates, sort order, top-5 clamp
- **FilterStateTests** — `hasActiveFilters` semantics, `resetFilters` round-trip

11 tests total. They run against the App target via `@testable import AdPulse`.
