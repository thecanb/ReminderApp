import SwiftUI

struct ReminderRow: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        HStack {
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
                    .strikethrough(reminder.isCompleted)
                    .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let dueDate = reminder.dueDate {
                    Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(reminder.isCompleted ? .secondary : .blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ReminderRow(reminder: .constant(
            Reminder(
                title: "Test Reminder",
                notes: "This is a test note",
                dueDate: Date(),
                isCompleted: false,
                priority: .normal
            )
        ))
        ReminderRow(reminder: .constant(
            Reminder(
                title: "Completed Reminder",
                notes: "This is completed",
                dueDate: Date(),
                isCompleted: true,
                priority: .high,
                completedDate: Date()
            )
        ))
    }
} 
