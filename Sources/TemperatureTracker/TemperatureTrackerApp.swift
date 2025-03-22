import SwiftUI

@main
struct TemperatureTrackerApp: App {
    // Initialize HealthKit manager as a state object to share across the app
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
        }
    }
}
