import SwiftUI

struct CompletedRemindersView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var reminders: [Reminder]
    
    var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
            .sorted { ($0.completedDate ?? Date()) > ($1.completedDate ?? Date()) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach($reminders.filter { $0.isCompleted.wrappedValue }) { $reminder in
                    ReminderRow(reminder: $reminder)
                        .swipeActions(edge: .leading) {
                            Button {
                                withAnimation {
                                    reminder.isCompleted = false
                                    reminder.completedDate = nil
                                }
                            } label: {
                                Label("Tekrar Aç", systemImage: "arrow.uturn.backward")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
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
            .navigationTitle("Tamamlananlar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if completedReminders.isEmpty {
                    ContentUnavailableView(
                        "Tamamlanan Anımsatıcı Yok",
                        systemImage: "checkmark.circle",
                        description: Text("Tamamladığınız anımsatıcılar burada görünecek")
                    )
                }
            }
        }
    }
} 
