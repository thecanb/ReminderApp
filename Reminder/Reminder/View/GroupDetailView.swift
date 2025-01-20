import SwiftUI

struct GroupDetailView: View {
    let group: ReminderGroup
    @Binding var reminders: [Reminder]
    @State private var showingAddReminder = false
    @State private var editingReminder: Reminder?
    
    var groupReminders: [Reminder] {
        reminders.filter { $0.groupId == group.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Grup başlığı ve istatistikler
                VStack(spacing: 16) {
                    HStack(spacing: 15) {
                        StatisticsCard(
                            title: "Bekleyen",
                            count: groupReminders.filter { !$0.isCompleted }.count,
                            icon: "clock.fill",
                            color: group.color
                        )
                        
                        StatisticsCard(
                            title: "Tamamlanan",
                            count: groupReminders.filter { $0.isCompleted }.count,
                            icon: "checkmark.circle.fill",
                            color: group.color
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Anımsatıcı listesi
                LazyVStack(spacing: 12) {
                    ForEach($reminders.filter { $0.groupId.wrappedValue == group.id }) { $reminder in
                        ReminderCard(reminder: $reminder, groupColor: group.color)
                            .contextMenu {
                                Button {
                                    editingReminder = reminder
                                } label: {
                                    Label("Düzenle", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                                        reminders.remove(at: index)
                                    }
                                } label: {
                                    Label("Sil", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(group.title)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: group.icon)
                        .foregroundColor(group.color)
                    Text(group.title)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddReminder = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddReminder) {
            AddReminderView(reminders: $reminders, groupId: group.id)
        }
        .sheet(item: $editingReminder) { reminder in
            if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                EditReminderView(reminder: $reminders[index])
            }
        }
        .overlay {
            if groupReminders.isEmpty {
                ContentUnavailableView(
                    "Anımsatıcı Yok",
                    systemImage: "bell.slash",
                    description: Text("Bu gruba henüz anımsatıcı eklenmemiş")
                )
            }
        }
    }
}

// Anımsatıcı kartı bileşeni
struct ReminderCard: View {
    @Binding var reminder: Reminder
    let groupColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation {
                    reminder.isCompleted.toggle()
                    reminder.completedDate = reminder.isCompleted ? Date() : nil
                }
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(reminder.isCompleted)
                    .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                if let dueDate = reminder.dueDate {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(groupColor)
                        Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(groupColor)
                    }
                }
            }
            
            Spacer()
            
            // Öncelik göstergesi
            Image(systemName: getPriorityIcon(reminder.priority))
                .foregroundColor(getPriorityColor(reminder.priority))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
        case .normal: return groupColor
        case .high: return .red
        }
    }
} 
