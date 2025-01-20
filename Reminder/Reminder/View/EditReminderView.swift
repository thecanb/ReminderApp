import SwiftUI

struct EditReminderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var reminder: Reminder
    
    @State private var title: String
    @State private var notes: String
    @State private var dueDate: Date
    @State private var hasDate: Bool
    @State private var priority: Reminder.Priority
    
    init(reminder: Binding<Reminder>) {
        self._reminder = reminder
        _title = State(initialValue: reminder.wrappedValue.title)
        _notes = State(initialValue: reminder.wrappedValue.notes ?? "")
        _dueDate = State(initialValue: reminder.wrappedValue.dueDate ?? Date())
        _hasDate = State(initialValue: reminder.wrappedValue.dueDate != nil)
        _priority = State(initialValue: reminder.wrappedValue.priority)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Başlık", text: $title)
                    TextField("Notlar", text: $notes)
                }
                
                Section {
                    Toggle("Tarih Ekle", isOn: $hasDate)
                    if hasDate {
                        DatePicker("Tarih", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
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
            .navigationTitle("Düzenle")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    reminder.title = title
                    reminder.notes = notes.isEmpty ? nil : notes
                    reminder.dueDate = hasDate ? dueDate : nil
                    reminder.priority = priority
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
} 
