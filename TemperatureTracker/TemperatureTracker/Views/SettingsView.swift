import SwiftUI

struct SettingsView: View {
    @Binding var useFahrenheit: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Temperature Unit")) {
                    Toggle("Use Fahrenheit (°F)", isOn: $useFahrenheit)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
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
