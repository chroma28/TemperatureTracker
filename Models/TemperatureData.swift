import Foundation

struct TemperatureData: Identifiable {
    let id: UUID
    let timestamp: Date
    let temperatureCelsius: Double
    
    // Computed property to convert Celsius to Fahrenheit
    var temperatureFahrenheit: Double {
        return temperatureCelsius * 9 / 5 + 32
    }
    
    // Default initializer
    init(id: UUID = UUID(), timestamp: Date, temperatureCelsius: Double) {
        self.id = id
        self.timestamp = timestamp
        self.temperatureCelsius = temperatureCelsius
    }
    
    // Convenience initializer for creating from Fahrenheit
    init(id: UUID = UUID(), timestamp: Date, temperatureFahrenheit: Double) {
        let celsius = (temperatureFahrenheit - 32) * 5 / 9
        self.init(id: id, timestamp: timestamp, temperatureCelsius: celsius)
    }
}
