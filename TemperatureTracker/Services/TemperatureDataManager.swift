import Foundation
import Combine

class TemperatureDataManager: ObservableObject {
    @Published var temperatureData: [TemperatureData] = []
    
    // Additional methods can be added here to manipulate or process temperature data
    
    func averageTemperature(useFahrenheit: Bool = false) -> Double? {
        guard !temperatureData.isEmpty else {
            return nil
        }
        
        let temperatures = temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }
        return temperatures.reduce(0, +) / Double(temperatures.count)
    }
    
    func minTemperature(useFahrenheit: Bool = false) -> Double? {
        guard !temperatureData.isEmpty else {
            return nil
        }
        
        return temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }.min()
    }
    
    func maxTemperature(useFahrenheit: Bool = false) -> Double? {
        guard !temperatureData.isEmpty else {
            return nil
        }
        
        return temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }.max()
    }
    
    func filterByDateRange(startDate: Date, endDate: Date) -> [TemperatureData] {
        return temperatureData.filter { 
            let timestamp = $0.timestamp
            return timestamp >= startDate && timestamp <= endDate
        }
    }
}
