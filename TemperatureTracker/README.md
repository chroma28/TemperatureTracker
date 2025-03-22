# Temperature Tracker iOS App

An iOS application that reads temperature data from Apple Watch and displays it graphically on iPhone.

## Features

- Integration with HealthKit to access body temperature data from Apple Watch
- Interactive temperature graphs with time-based filtering (day, week, month)
- Temperature unit conversion (Celsius/Fahrenheit)
- Statistics display (min, max, average temperature)
- Clean and modern SwiftUI interface

## Project Structure

```
TemperatureTracker/
├── TemperatureTracker.xcodeproj/
│   └── project.pbxproj
├── TemperatureTracker/
│   ├── TemperatureTrackerApp.swift (Main app entry point)
│   ├── Views/
│   │   ├── ContentView.swift (Main container view)
│   │   ├── TemperatureChartView.swift (Graph visualization)
│   │   ├── EmptyStateView.swift (Shown when no data available)
│   │   ├── ErrorView.swift (Error handling UI)
│   │   └── SettingsView.swift (User preferences)
│   ├── Models/
│   │   ├── TemperatureData.swift (Core data model)
│   │   └── TimeRange.swift (Time filtering options)
│   ├── Services/
│   │   ├── HealthKitManager.swift (HealthKit integration)
│   │   └── TemperatureDataManager.swift (Data processing)
│   └── Utilities/
│       ├── DateExtensions.swift (Date formatting helpers)
│       └── TemperatureFormatter.swift (Temperature display utilities)
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Apple Watch with temperature sensing capability paired with iPhone

## Development Process

1. Initialize the project
2. Set up HealthKit integration
3. Implement data models and services
4. Create UI components using SwiftUI
5. Add temperature visualization with Charts
6. Implement time-based filtering
7. Add unit conversion functionality
8. Polish UI and user experience

## Future Enhancements

- Custom temperature input for manual tracking
- Notifications for abnormal temperature readings
- Correlation with other health metrics
- Data export functionality
- Cloud backup and sync