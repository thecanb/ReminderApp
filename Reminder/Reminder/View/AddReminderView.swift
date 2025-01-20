import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var reminders: [Reminder]
    var groupId: UUID? = nil
    
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var hasDate = false
    @State private var priority: Reminder.Priority = .normal
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Başlık", text: $title)
                    TextField("Notlar", text: $notes)
                }
                
                Section {
                    Toggle("Tarih ve Saat Ekle", isOn: $hasDate)
                    if hasDate {
                        DatePicker("Tarih ve Saat", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section {
                    Picker("Öncelik", selection: $priority) {
                        Text("Düşük").tag(Reminder.Priority.low)
                        Text("Normal").tag(Reminder.Priority.normal)
                        Text("Yüksek").tag(Reminder.Priority.high)
                    }
                }
            }
            .navigationTitle("Yeni Anımsatıcı")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    let reminder = Reminder(
                        title: title,
                        notes: notes.isEmpty ? nil : notes,
                        dueDate: hasDate ? dueDate : nil,
                        isCompleted: false,
                        priority: priority,
                        groupId: groupId
                    )
                    
                    // Bildirim planla ve kontrol et
                    if hasDate {
                        NotificationManager.shared.scheduleNotification(for: reminder)
                        NotificationManager.shared.checkPendingNotifications() // Kontrol için
                    }
                    
                    reminders.append(reminder)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}
