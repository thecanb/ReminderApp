import SwiftUI

struct CalendarView: View {
    let reminders: [Reminder]
    @State private var selectedDate = Date()
    
    private var selectedDateReminders: [Reminder] {
        reminders.filter { reminder in
            guard let dueDate = reminder.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: selectedDate)
        }
        .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Takvim
            DatePicker(
                "Tarih Seçin",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Seçili günün anımsatıcıları
            VStack(alignment: .leading, spacing: 16) {
                if !selectedDateReminders.isEmpty {
                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(selectedDateReminders) { reminder in
                            DailyReminderCard(reminder: reminder)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            .background(Color(.systemGroupedBackground))
            .overlay {
                if selectedDateReminders.isEmpty {
                    ContentUnavailableView(
                        "Anımsatıcı Yok",
                        systemImage: "bell.slash",
                        description: Text("Seçili tarihte anımsatıcı bulunmuyor")
                    )
                }
            }
        }
        .navigationTitle("Takvim")
    }
}

struct DailyReminderCard: View {
    let reminder: Reminder
    
    var body: some View {
        HStack(spacing: 16) {
            // Sol taraftaki zaman çizelgesi
            VStack(spacing: 4) {
                Text(reminder.dueDate?.formatted(date: .omitted, time: .shortened) ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Circle()
                    .fill(getPriorityColor(reminder.priority))
                    .frame(width: 8, height: 8)
            }
            .frame(width: 60)
            
            // Anımsatıcı içeriği
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(reminder.title)
                        .font(.headline)
                        .strikethrough(reminder.isCompleted)
                        .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: getPriorityIcon(reminder.priority))
                        .foregroundColor(getPriorityColor(reminder.priority))
                }
                
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Grup bilgisi
                if let groupId = reminder.groupId {
                    GroupBadge(groupId: groupId)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func getPriorityIcon(_ priority: Reminder.Priority) -> String {
        switch priority {
        case .low: return "arrow.down.circle.fill"
        case .normal: return "bell.fill"
        case .high: return "exclamationmark.circle.fill"
        }
    }
    
    private func getPriorityColor(_ priority: Reminder.Priority) -> Color {
        switch priority {
        case .low: return .blue
        case .normal: return .orange
        case .high: return .red
        }
    }
}

struct GroupBadge: View {
    let groupId: UUID
    @EnvironmentObject var dataManager: DataManager
    
    var group: ReminderGroup? {
        dataManager.groups.first { $0.id == groupId }
    }
    
    var body: some View {
        if let group = group {
            HStack(spacing: 4) {
                Image(systemName: group.icon)
                    .font(.caption)
                Text(group.title)
                    .font(.caption)
            }
            .foregroundColor(group.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(group.color.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationView {
        CalendarView(reminders: [
            Reminder(
                title: "Toplantı",
                notes: "Proje değerlendirme toplantısı",
                dueDate: Date(),
                priority: .high
            ),
            Reminder(
                title: "Alışveriş",
                notes: "Market alışverişi yapılacak",
                dueDate: Date(),
                priority: .normal
            )
        ])
        .environmentObject(DataManager())
    }
} 
