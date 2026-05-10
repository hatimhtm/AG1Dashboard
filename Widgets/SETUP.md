# Widget Extension

The Widget Extension target is **already wired up** by `project.yml` / `AdPulse.xcodeproj`. You don't need to add anything in Xcode — just build and run.

The Live Activity surface lives here:

- `AdPulseWidgetBundle.swift` — `@main` for the `AdPulseWidgets` extension
- `CampaignLiveActivity.swift` — Lock Screen + Dynamic Island regions
- `Info.plist` — `NSExtensionPointIdentifier = com.apple.widgetkit-extension`

`Shared/CampaignActivityAttributes.swift` is included in **both** the App and the Widget targets so they compile against the same activity type.

## Running it

1. Select the `AdPulse` scheme in Xcode (it builds both targets).
2. Run on iOS 17+ simulator or device.
3. Open Settings inside the app → toggle "Suivre la cohorte filtrée".
4. The Live Activity appears on the Lock Screen and (on devices with Dynamic Island) in the island.

If the activity doesn't appear, check that `NSSupportsLiveActivities = YES` is set in the App target's Info.plist (it is, via `INFOPLIST_KEY_NSSupportsLiveActivities` in `project.yml`).
