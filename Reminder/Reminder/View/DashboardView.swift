import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var settings: AppSettings
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Üst başlık ve profil
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hoş Geldiniz")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text("Günlük Özetiniz")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)
                    
                    // İstatistik kartları
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        // Anımsatıcılar kartı
                        NavigationLink(destination: ReminderListView(reminders: $dataManager.reminders, groups: $dataManager.groups)) {
                            StatCard(
                                title: "Anımsatıcılar",
                                value: "\(dataManager.reminders.filter { !$0.isCompleted }.count)",
                                subtitle: "",
                                icon: "bell.fill",
                                color: .purple,
                                gradient: Gradient(colors: [.purple, .blue])
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Bugünkü görevler kartı
                        NavigationLink(destination: CalendarView(reminders: dataManager.reminders)) {
                            StatCard(
                                title: "Bugün",
                                value: "\(todayRemindersCount)",
                                subtitle: "",
                                icon: "calendar",
                                color: .blue,
                                gradient: Gradient(colors: [.blue, .cyan])
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Alışveriş kartı
                        NavigationLink(destination: ShoppingListView(items: $dataManager.shoppingItems)) {
                            StatCard(
                                title: "Alışveriş",
                                value: "\(dataManager.shoppingItems.filter { !$0.isArchived }.count)",
                                subtitle: "",
                                icon: "cart.fill",
                                color: .orange,
                                gradient: Gradient(colors: [.orange, .yellow])
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Masraflar kartı
                        NavigationLink(destination: ExpenseManagerView(periods: $dataManager.periods)) {
                            StatCard(
                                title: "Masraflar",
                                value: currentPeriodExpense,
                                subtitle: "",
                                icon: "creditcard.fill",
                                color: .green,
                                gradient: Gradient(colors: [.green, .mint])
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // Aktivite özeti
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Aktivite Özeti")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                // Yaklaşan görevler
                                ActivityCard(
                                    title: "Yaklaşan",
                                    icon: "clock.fill",
                                    color: .pink
                                ) {
                                    ForEach(upcomingReminders.prefix(3)) { reminder in
                                        HStack {
                                            Circle()
                                                .fill(Color.pink.opacity(0.2))
                                                .frame(width: 8, height: 8)
                                            Text(reminder.title)
                                                .lineLimit(1)
                                            Spacer()
                                            if let date = reminder.dueDate {
                                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                                
                                // Son alışverişler
                                ActivityCard(
                                    title: "Alışveriş",
                                    icon: "bag.fill",
                                    color: .orange
                                ) {
                                    ForEach(dataManager.shoppingItems.prefix(3)) { item in
                                        HStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 8, height: 8)
                                            Text(item.title)
                                                .lineLimit(1)
                                            Spacer()
                                            if let price = item.price {
                                                Text(price)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Ana Sayfa")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NavigationView {
                    SettingsView()
                        .navigationTitle("Ayarlar")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Tamam") {
                                    showingSettings = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    // Bugünkü görevlerin sayısı
    private var todayRemindersCount: Int {
        dataManager.reminders.filter {
            if let date = $0.dueDate {
                return Calendar.current.isDateInToday(date)
            }
            return false
        }.count
    }
    
    // Yaklaşan görevler
    private var upcomingReminders: [Reminder] {
        dataManager.reminders
            .filter { !$0.isCompleted && $0.dueDate != nil }
            .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
    }
    
    // Mevcut dönem harcaması
    private var currentPeriodExpense: String {
        if let period = dataManager.periods.first {
            return period.totalExpense.formatted(.currency(code: "TRY"))
        }
        return "0 ₺"
    }
}

// İstatistik kartı
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let gradient: Gradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // İkon
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .background(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(Circle())
            
            // Değer
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            // Başlık ve alt başlık
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// Aktivite kartı
struct ActivityCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            content()
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    DashboardView()
        .environmentObject(DataManager())
}
