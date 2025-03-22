import SwiftUI

struct SettingsView: View {
    @Binding var useFahrenheit: Bool
    @State private var selectedUnit: TemperatureUnit
    @Environment(\.presentationMode) var presentationMode
    
    init(useFahrenheit: Binding<Bool>) {
        self._useFahrenheit = useFahrenheit
        self._selectedUnit = State(initialValue: useFahrenheit.wrappedValue ? .fahrenheit : .celsius)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Temperature Unit")) {
                    // Option 1: Toggle switch
                    Toggle("Use Fahrenheit (°F)", isOn: $useFahrenheit)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .onChange(of: useFahrenheit) { newValue in
                            selectedUnit = newValue ? .fahrenheit : .celsius
                        }
                    
                    // Option 2: Segmented control
                    Picker("Display Temperature In", selection: $selectedUnit) {
                        ForEach(TemperatureUnit.allCases) { unit in
                            Text("\(unit.rawValue) (\(unit.symbol))").tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedUnit) { newValue in
                        useFahrenheit = (newValue == .fahrenheit)
                    }
                    
                    // Example temperatures
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Examples")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Normal body temp:")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(useFahrenheit ? "98.6°F" : "37.0°C")
                                .font(.footnote)
                                .bold()
                        }
                        
                        HStack {
                            Text("Fever:")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(useFahrenheit ? "100.4°F" : "38.0°C")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Temperature Tracker")
                            .font(.headline)
                        
                        Text("This app reads temperature data from your Apple Watch and displays it graphically on your iPhone.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider()
                        
                        Text("Health Data Access")
                            .font(.headline)
                            .padding(.top, 5)
                        
                        Text("The app uses HealthKit to access your body temperature data. No data is shared with external services or stored outside of your device.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(useFahrenheit: .constant(false))
    }
}
