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
    
    static func formatTemperatureValue(_ temperature: Double, useFahrenheit: Bool, includeUnit: Bool = true) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        
        guard let formattedValue = numberFormatter.string(from: NSNumber(value: temperature)) else {
            if includeUnit {
                return "\(temperature)\(useFahrenheit ? "°F" : "°C")"
            } else {
                return "\(temperature)"
            }
        }
        
        if includeUnit {
            return "\(formattedValue)\(useFahrenheit ? "°F" : "°C")"
        } else {
            return formattedValue
        }
    }
    
    static func temperatureUnit(useFahrenheit: Bool) -> String {
        return useFahrenheit ? "°F" : "°C"
    }
    
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return celsius * 9 / 5 + 32
    }
    
    static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }
    
    static func convertTemperature(temperature: Double, from fromUnit: TemperatureUnit, to toUnit: TemperatureUnit) -> Double {
        if fromUnit == toUnit {
            return temperature
        }
        
        switch (fromUnit, toUnit) {
        case (.celsius, .fahrenheit):
            return celsiusToFahrenheit(temperature)
        case (.fahrenheit, .celsius):
            return fahrenheitToCelsius(temperature)
        }
    }
}

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
    
    var shortName: String {
        switch self {
        case .celsius:
            return "C"
        case .fahrenheit:
            return "F"
        }
    }
}
