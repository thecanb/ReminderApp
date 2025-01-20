import SwiftUI

struct ReminderListView: View {
    @Binding var reminders: [Reminder]
    @Binding var groups: [ReminderGroup]
    @State private var showingAddSheet = false
    @State private var showingCompleted = false
    @State private var editingReminder: Reminder?
    @State private var selectedGroupId: UUID?
    @State private var addSheetType: AddSheetType?
    @State private var editingGroup: ReminderGroup?
    
    enum AddSheetType: Identifiable {
        case reminder, group
        var id: Int { hashValue }
    }
    
    private var filteredReminders: [Reminder] {
        let uncompleted = reminders.filter { !$0.isCompleted }
        if let groupId = selectedGroupId {
            return uncompleted.filter { $0.groupId == groupId }
        }
        return uncompleted
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // İstatistik kartları
                    HStack(spacing: 15) {
                        StatCard(
                            title: "Bekleyen",
                            value: "\(reminders.filter { !$0.isCompleted }.count)",
                            subtitle: "",
                            icon: "clock.fill",
                            color: .blue,
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)])
                        )
                        
                        StatCard(
                            title: "Tamamlanan",
                            value: "\(reminders.filter { $0.isCompleted }.count)",
                            subtitle: "",
                            icon: "checkmark.circle.fill",
                            color: .green,
                            gradient: Gradient(colors: [.green, .green.opacity(0.8)])
                        )
                        .onTapGesture {
                            showingCompleted = true
                        }
                    }
                    .padding(.horizontal)
                    
                    // Gruplar
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gruplar")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(groups) { group in
                                    NavigationLink(destination: GroupDetailView(group: group, reminders: $reminders)) {
                                        GroupCardView(
                                            group: group,
                                            count: reminders.filter { $0.groupId == group.id && !$0.isCompleted }.count
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contextMenu {
                                        Button {
                                            editingGroup = group
                                        } label: {
                                            Label("Düzenle", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive) {
                                            withAnimation {
                                                groups.removeAll { $0.id == group.id }
                                                reminders.removeAll { $0.groupId == group.id }
                                            }
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Anımsatıcılar
                    VStack(alignment: .leading, spacing: 12) {
                        Text(selectedGroupId == nil ? "Anımsatıcılar" : (groups.first(where: { $0.id == selectedGroupId })?.title ?? ""))
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(filteredReminders) { reminder in
                                ReminderCardView(
                                    reminder: reminder,
                                    group: groups.first(where: { $0.id == reminder.groupId }),
                                    reminders: $reminders
                                )
                                .contextMenu {
                                    Button {
                                        editingReminder = reminder
                                    } label: {
                                        Label("Düzenle", systemImage: "pencil")
                                    }
                                    
                                    Button {
                                        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                                            withAnimation {
                                                reminders[index].isCompleted.toggle()
                                                reminders[index].completedDate = reminders[index].isCompleted ? Date() : nil
                                            }
                                        }
                                    } label: {
                                        Label(
                                            reminder.isCompleted ? "Tamamlanmadı" : "Tamamlandı",
                                            systemImage: reminder.isCompleted ? "circle" : "checkmark.circle"
                                        )
                                    }
                                    
                                    Button(role: .destructive) {
                                        withAnimation {
                                            reminders.removeAll { $0.id == reminder.id }
                                        }
                                    } label: {
                                        Label("Sil", systemImage: "trash")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Anımsatıcılar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            addSheetType = .reminder
                        } label: {
                            Label("Anımsatıcı Ekle", systemImage: "bell.badge.plus")
                        }
                        
                        Button {
                            addSheetType = .group
                        } label: {
                            Label("Grup Ekle", systemImage: "folder.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $addSheetType) { type in
                switch type {
                case .reminder:
                    AddReminderView(reminders: $reminders, groupId: selectedGroupId)
                case .group:
                    AddGroupView(groups: $groups)
                }
            }
            .sheet(isPresented: $showingCompleted) {
                CompletedRemindersView(reminders: $reminders)
            }
            .sheet(item: $editingGroup) { group in
                if let index = groups.firstIndex(where: { $0.id == group.id }) {
                    EditGroupView(group: $groups[index])
                }
            }
            .sheet(item: $editingReminder) { reminder in
                if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                    EditReminderView(reminder: $reminders[index])
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct GroupCardView: View {
    let group: ReminderGroup
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // İkon ve arka plan dairesi
                Image(systemName: group.icon)
                    .font(.title2)
                    .foregroundColor(group.color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(group.color.opacity(0.15))
                    )
                
                Spacer()
                
                // Anımsatıcı sayısı
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(group.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(group.color.opacity(0.15))
                    )
            }
            
            Text(group.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding()
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: group.color.opacity(0.1), radius: 8)
        )
    }
}

struct ReminderCardView: View {
    let reminder: Reminder
    let group: ReminderGroup?
    @Binding var reminders: [Reminder]
    
    var body: some View {
        HStack(spacing: 15) {
            // Tamamlanma durumu butonu
            Button {
                if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                    withAnimation {
                        reminders[index].isCompleted.toggle()
                        reminders[index].completedDate = reminders[index].isCompleted ? Date() : nil
                    }
                }
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            
            Circle()
                .fill(group?.color.opacity(0.2) ?? Color.gray.opacity(0.2))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                if let dueDate = reminder.dueDate {
                    HStack {
                        Image(systemName: "calendar")
                        Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let group = group {
                Image(systemName: group.icon)
                    .foregroundColor(group.color)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8)
        )
    }
}
