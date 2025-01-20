import Foundation
import SwiftUI
import UserNotifications

struct Reminder: Identifiable, Codable {
    let id: UUID
    var title: String
    var notes: String?
    var dueDate: Date?
    var isCompleted: Bool
    var priority: Priority
    var groupId: UUID?
    var completedDate: Date?
    var notificationId: String? // Bildirim için unique id
    
    init(id: UUID = UUID(),
         title: String,
         notes: String? = nil,
         dueDate: Date? = nil,
         isCompleted: Bool = false,
         priority: Priority = .normal,
         groupId: UUID? = nil,
         completedDate: Date? = nil,
         notificationId: String? = nil) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.groupId = groupId
        self.completedDate = completedDate
        self.notificationId = notificationId
    }
    
    enum Priority: Int, Codable {
        case low = 0
        case normal = 1
        case high = 2
    }
}

struct ReminderGroup: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var color: Color
    var icon: String
    
    init(id: UUID = UUID(), title: String, color: Color = .blue, icon: String = "list.bullet") {
        self.id = id
        self.title = title
        self.color = color
        self.icon = icon
    }
    
    static func == (lhs: ReminderGroup, rhs: ReminderGroup) -> Bool {
        lhs.id == rhs.id
    }
} 
