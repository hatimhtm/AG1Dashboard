# Widget Extension setup

The Live Activity is implemented but needs a Widget Extension target in Xcode.

## Steps (one-time)

1. Open the project in Xcode.
2. **File → New → Target → Widget Extension** (under iOS).
3. Name: `AdPulseWidgets` · uncheck "Include Live Activity" (we already have the code).
4. **Delete** the auto-generated `AdPulseWidgets.swift` and `AdPulseWidgetsLiveActivity.swift` files inside the new target — we'll wire ours in.
5. Add the following files to the `AdPulseWidgets` target via *File Inspector → Target Membership*:
   - `Widgets/AdPulseWidgetBundle.swift`
   - `Widgets/CampaignLiveActivity.swift`
   - `Shared/CampaignActivityAttributes.swift` (must be in **both** App and Widget targets)
6. In the App target's `Info.plist`, ensure `NSSupportsLiveActivities = YES`.
7. Set the Widget Extension's deployment target to **iOS 17.0+** (matches the App).
8. Build & run on a device or simulator (Live Activities work in the simulator from iOS 16.2).

## Triggering the activity from the app

`DashboardViewModel.startLiveActivityTracking()` starts a Live Activity bound to the currently-filtered campaign cohort. Wire it to a button in the Settings or Overview screen, or have the anomaly detector fire it automatically (see `Services/AnomalyDetector.swift`).
