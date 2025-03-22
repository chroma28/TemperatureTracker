import SwiftUI

// UserDefaults keys for app settings
enum UserDefaultsKeys {
    static let useFahrenheit = "useFahrenheit"
    static let selectedTimeRange = "selectedTimeRange"
}

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject private var temperatureDataManager = TemperatureDataManager()
    
    // State properties with UserDefaults persistence
    @AppStorage(UserDefaultsKeys.useFahrenheit) private var useFahrenheit: Bool = false
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showSettings: Bool = false
    @State private var isLoading: Bool = true
    
    // Computed property to get the current temperature unit
    private var temperatureUnit: TemperatureUnit {
        return useFahrenheit ? .fahrenheit : .celsius
    }
    
    // Initialize with saved time range from UserDefaults if available
    init() {
        if let savedTimeRangeValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedTimeRange),
           let timeRange = TimeRange(rawValue: savedTimeRangeValue) {
            _selectedTimeRange = State(initialValue: timeRange)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if healthKitManager.authorizationStatus == .notDetermined {
                    requestAccessView
                } else if healthKitManager.authorizationStatus == .denied {
                    ErrorView(
                        message: "Health data access was denied. Please enable access in Settings app.",
                        actionTitle: "Open Settings",
                        action: openSettings
                    )
                } else if isLoading {
                    loadingView
                } else if temperatureDataManager.temperatureData.isEmpty {
                    EmptyStateView(
                        title: "No Temperature Data",
                        message: "No temperature data available for the selected time range. Try changing the time range or make sure your Apple Watch is synced.",
                        systemImage: "thermometer"
                    )
                } else {
                    mainContentView
                }
            }
            .navigationTitle("Temperature Tracker")
            .navigationBarItems(
                leading: temperatureUnitButton,
                trailing: settingsButton
            )
            .sheet(isPresented: $showSettings) {
                SettingsView(useFahrenheit: $useFahrenheit)
            }
            .onAppear {
                if healthKitManager.authorizationStatus == .authorized {
                    loadData()
                } else if healthKitManager.authorizationStatus == .notDetermined {
                    healthKitManager.requestAuthorization { success in
                        if success {
                            loadData()
                        }
                    }
                }
            }
            // Refresh data when returning from settings (in case unit changed)
            .onChange(of: useFahrenheit) { _ in
                // No need to reload data, just refresh UI
                // Data is stored in Celsius and converted on-the-fly
            }
        }
    }
    
    private var requestAccessView: some View {
        VStack(spacing: 20) {
            Image(systemName: "thermometer")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Temperature Tracker needs access to your Health data")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("This app uses HealthKit to access your body temperature data from Apple Watch.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                healthKitManager.requestAuthorization { success in
                    if success {
                        loadData()
                    }
                }
            }) {
                Text("Authorize HealthKit Access")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading temperature data...")
                .padding(.top)
        }
    }
    
    private var mainContentView: some View {
        VStack {
            timeRangeSelector
            
            TemperatureChartView(
                temperatureData: temperatureDataManager.temperatureData,
                useFahrenheit: useFahrenheit
            )
            .padding()
        }
    }
    
    private var timeRangeSelector: some View {
        VStack(spacing: 8) {
            // Enhanced segmented picker with icons
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases) { timeRange in
                    HStack {
                        Image(systemName: timeRange.systemIcon)
                        Text(timeRange.rawValue)
                    }.tag(timeRange)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedTimeRange) { newValue in
                // Save selected time range to UserDefaults
                UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.selectedTimeRange)
                loadData()
            }
            
            // Display description of the selected time range
            Text(selectedTimeRange.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
        }
    }
    
    // Quick toggle for temperature unit in the navigation bar
    private var temperatureUnitButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                useFahrenheit.toggle()
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: "thermometer")
                Text(temperatureUnit.shortName)
                    .fontWeight(.semibold)
                    // Add a small up/down indicator
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10))
                        .opacity(0.7)
            }
            .padding(8)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.15))
                    .shadow(color: .blue.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            // Add a rotation animation based on the unit
            .rotation3DEffect(
                useFahrenheit ? .degrees(0) : .degrees(360),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.spring(response: 0.4), value: useFahrenheit)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Toggle temperature unit")
        .accessibilityHint("Switches between Celsius and Fahrenheit")
    }
    
    private var settingsButton: some View {
        Button(action: {
            showSettings = true
        }) {
            Image(systemName: "gear")
        }
    }
    
    private func loadData() {
        isLoading = true
        
        // Get the date range using the TimeRange method
        let dateRange = selectedTimeRange.dateRange()
        
        // Fetch temperature data from HealthKit
        healthKitManager.fetchTemperatureData(from: dateRange.start, to: dateRange.end) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let data):
                    temperatureDataManager.temperatureData = data
                case .failure(let error):
                    print("Error fetching temperature data: \(error)")
                    // Show error to user or handle it appropriately
                    temperatureDataManager.temperatureData = []
                }
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HealthKitManager())
    }
}
