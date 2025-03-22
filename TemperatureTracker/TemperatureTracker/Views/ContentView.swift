import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject private var temperatureDataManager = TemperatureDataManager()
    @State private var selectedTimeRange: TimeRange = .week
    @State private var useFahrenheit: Bool = false
    @State private var showSettings: Bool = false
    @State private var isLoading: Bool = true
    
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
            .navigationBarItems(trailing: settingsButton)
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
        Picker("Time Range", selection: $selectedTimeRange) {
            Text("Day").tag(TimeRange.day)
            Text("Week").tag(TimeRange.week)
            Text("Month").tag(TimeRange.month)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .onChange(of: selectedTimeRange) { _ in
            loadData()
        }
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
        
        // Get the date range based on selected time range
        let endDate = Date()
        let startDate: Date
        
        switch selectedTimeRange {
        case .day:
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        case .week:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        }
        
        // Fetch temperature data from HealthKit
        healthKitManager.fetchTemperatureData(from: startDate, to: endDate) { result in
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
