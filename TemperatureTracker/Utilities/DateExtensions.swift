import Foundation

extension Date {
    func formatForAxis() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // If within last 24 hours, show time only
        if calendar.isDateInToday(self) || calendar.isDateInYesterday(self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
        
        // If within last week, show day name
        if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now), self >= weekAgo {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter.string(from: self)
        }
        
        // If within last month, show day and month
        if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now), self >= monthAgo {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter.string(from: self)
        }
        
        // Otherwise, show day and month
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: self)
    }
    
    func formatFull() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
