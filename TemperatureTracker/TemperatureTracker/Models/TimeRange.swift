import Foundation

enum TimeRange: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    var description: String {
        switch self {
        case .day:
            return "Last 24 Hours"
        case .week:
            return "Last 7 Days"
        case .month:
            return "Last 30 Days"
        }
    }
    
    // Return the date range for this time range, ending at the current time
    func dateRange(endingAt endDate: Date = Date()) -> (start: Date, end: Date) {
        let start: Date
        
        switch self {
        case .day:
            start = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        case .week:
            start = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            start = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        }
        
        return (start, endDate)
    }
}
