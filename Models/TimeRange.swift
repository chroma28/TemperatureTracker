import Foundation

enum TimeRange: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    // Identifiable conformance
    var id: String { self.rawValue }
    
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
    
    var systemIcon: String {
        switch self {
        case .day:
            return "clock"
        case .week:
            return "calendar.day.timeline.left"
        case .month:
            return "calendar"
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
    
    // Format a date to represent this time range in UI
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        switch self {
        case .day:
            formatter.dateFormat = "h:mm a"
        case .week:
            formatter.dateFormat = "E"  // Day of week
        case .month:
            formatter.dateFormat = "MMM d"  // Month and day
        }
        
        return formatter.string(from: date)
    }
}
