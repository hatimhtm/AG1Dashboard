# Tests target setup

The test files live in `Tests/AdPulseTests/`. Add them to a Unit Test bundle:

1. **File → New → Target → Unit Testing Bundle** (iOS).
2. Name: `AdPulseTests`. Make sure "Target to be Tested" is the App target.
3. Delete the auto-generated `AdPulseTests.swift`.
4. Add `Tests/AdPulseTests/*.swift` to the new target via *File Inspector → Target Membership*.
5. Run tests: `⌘U`.

## Coverage at a glance

- **CSVParserTests** — parses a sample row; throws on empty input; skips malformed rows; handles euro-symbol / comma-decimal cleanup.
- **DashboardViewModelTests** — KPI math (`totalBudget`, `averageROAS`), filter predicates (product / search), sort order, top-5 clamping.
- **FilterStateTests** — `hasActiveFilters` semantics, `resetFilters` round-trip.
