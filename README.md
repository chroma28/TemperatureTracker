# Temperature Tracker

An iOS app that reads temperature data from Apple Watch and displays it graphically on iPhone.

## Features

- Connects to HealthKit to fetch body temperature data from Apple Watch
- Visualizes temperature data in an interactive chart
- Filters data by different time ranges (day, week, month)
- Supports both Celsius and Fahrenheit temperature units
- Provides statistical information (minimum, maximum, average temperature)
- Clean, user-friendly interface with proper error handling

## Requirements

- iOS 16.0+ / watchOS 9.0+
- Xcode 14.0+
- Swift 5.7+
- Apple Watch with temperature sensing capabilities

## Getting Started

1. Clone this repository
2. Open the project in Xcode
3. Ensure your Apple Developer account is set up with HealthKit capabilities
4. Build and run on an iPhone connected to Apple Watch

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define data structures for temperature readings and time ranges
- **Views**: SwiftUI views for displaying the app UI and charts
- **Services**: Managers for HealthKit integration and temperature data processing
- **Utilities**: Helper extensions and formatters for dates and temperatures

## Privacy

The app only reads body temperature data from HealthKit and does not modify or share any health data. All processing is done on-device, and no data is sent to external servers.

## License

[Your chosen license]

## Contact

[Your contact information]