import SwiftUI
import Charts

struct TemperatureChartView: View {
    let temperatureData: [TemperatureData]
    let useFahrenheit: Bool
    
    // Calculate y-axis range
    private var minTemperature: Double {
        temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }.min() ?? 35.0
    }
    
    private var maxTemperature: Double {
        temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }.max() ?? 40.0
    }
    
    // Add a small range buffer for better visualization
    private var yAxisLowerBound: Double {
        minTemperature - 0.5
    }
    
    private var yAxisUpperBound: Double {
        maxTemperature + 0.5
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Body Temperature")
                .font(.headline)
                .padding(.bottom, 4)
            
            Text("Recorded from Apple Watch")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            chartView
                .frame(height: 300)
            
            temperatureStatsView
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
    
    private var chartView: some View {
        Chart {
            ForEach(temperatureData) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Temperature", useFahrenheit ? dataPoint.temperatureFahrenheit : dataPoint.temperatureCelsius)
                )
                .foregroundStyle(Color.blue)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Temperature", useFahrenheit ? dataPoint.temperatureFahrenheit : dataPoint.temperatureCelsius)
                )
                .foregroundStyle(Color.blue)
            }
        }
        .chartYScale(domain: yAxisLowerBound...yAxisUpperBound)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date.formatForAxis())
                    }
                }
            }
        }
    }
    
    private var temperatureStatsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Average")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(averageTemperature)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Unit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(useFahrenheit ? "°F" : "°C")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(minTemperatureFormatted)
                        .font(.body)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Max")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(maxTemperatureFormatted)
                        .font(.body)
                }
            }
        }
        .padding(.top, 10)
    }
    
    // Calculate statistics
    private var averageTemperature: String {
        let temps = temperatureData.map { useFahrenheit ? $0.temperatureFahrenheit : $0.temperatureCelsius }
        let average = temps.reduce(0, +) / Double(temps.count)
        return TemperatureFormatter.formatTemperature(average, useFahrenheit: useFahrenheit)
    }
    
    private var minTemperatureFormatted: String {
        TemperatureFormatter.formatTemperature(minTemperature, useFahrenheit: useFahrenheit)
    }
    
    private var maxTemperatureFormatted: String {
        TemperatureFormatter.formatTemperature(maxTemperature, useFahrenheit: useFahrenheit)
    }
}

struct TemperatureChartView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureChartView(
            temperatureData: [
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 24), temperatureCelsius: 36.5),
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 20), temperatureCelsius: 36.7),
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 16), temperatureCelsius: 37.1),
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 12), temperatureCelsius: 36.9),
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 8), temperatureCelsius: 36.6),
                TemperatureData(id: UUID(), timestamp: Date().addingTimeInterval(-3600 * 4), temperatureCelsius: 36.4)
            ],
            useFahrenheit: false
        )
        .padding()
    }
}
