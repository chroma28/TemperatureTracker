import Foundation

struct TemperatureFormatter {
    static func formatTemperature(_ temperature: Double, useFahrenheit: Bool) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        
        guard let formattedValue = numberFormatter.string(from: NSNumber(value: temperature)) else {
            return "\(temperature)\(useFahrenheit ? "°F" : "°C")"
        }
        
        return "\(formattedValue)\(useFahrenheit ? "°F" : "°C")"
    }
    
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return celsius * 9 / 5 + 32
    }
    
    static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }
}
