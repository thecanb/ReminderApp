import SwiftUI

enum Tab: Int {
    case home = 0
    case reminders = 1
    case quickMenu = 2
    case shopping = 3
    case expenses = 4
    case finance = 5
}

struct MainTabView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    @State private var showingQuickMenu = false
    @State private var showingSettings = false
    @State private var showingCalendar = false
    @State private var showingFinance = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Ana içerik ve tab bar
            TabView(selection: $selectedTab) {
                // Ana Sayfa (Dashboard)
                DashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Ana Sayfa")
                    }
                    .tag(0)
                
                // Anımsatıcılar
                ReminderListView(reminders: $dataManager.reminders, groups: $dataManager.groups)
                    .tabItem {
                        Image(systemName: "list.bullet.circle.fill")
                        Text("Anımsatıcılar")
                    }
                    .tag(1)
                
                // Orta buton için boş tab
                Color.clear
                    .tabItem { Text("") }
                    .tag(2)
                
                // Alışveriş
                ShoppingListView(items: $dataManager.shoppingItems)
                    .tabItem {
                        Image(systemName: "cart.circle.fill")
                        Text("Alışveriş")
                    }
                    .tag(3)
                
                // Masraflar
                ExpenseManagerView(periods: $dataManager.periods)
                    .tabItem {
                        Image(systemName: "creditcard.circle.fill")
                        Text("Masraflar")
                    }
                    .tag(4)
            }
            
            // Karartma ve tıklama yakalama
            if showingQuickMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingQuickMenu = false
                        }
                    }
            }
            
            // Hızlı Erişim Menüsü
            if showingQuickMenu {
                VStack(spacing: 20) {
                    HStack(spacing: 30) {
                        Button {
                            showingQuickMenu = false
                            showingCalendar = true
                        } label: {
                            QuickMenuButton(
                                title: "Takvim",
                                icon: "calendar",
                                color: .blue
                            )
                        }
                        
                        Button {
                            showingQuickMenu = false
                            showingFinance = true
                        } label: {
                            QuickMenuButton(
                                title: "Finans",
                                icon: "banknote",
                                color: .purple
                            )
                        }
                        
                        Button {
                            showingSettings = true
                            showingQuickMenu = false
                        } label: {
                            QuickMenuButton(
                                title: "Ayarlar",
                                icon: "gear",
                                color: .gray
                            )
                        }
                    }
                    .padding()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                .offset(y: -60)
                .transition(.move(edge: .bottom))
            }
            
            // Orta artı butonu
            Button {
                withAnimation {
                    showingQuickMenu.toggle()
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.purple)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .offset(y: -15)
        }
        .sheet(isPresented: $showingCalendar) {
            NavigationView {
                CalendarView(reminders: dataManager.reminders)
            }
        }
        .sheet(isPresented: $showingFinance) {
            NavigationView {
                FinanceView()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch settings.theme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

// Hızlı erişim menü butonu
struct QuickMenuButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 60, height: 60)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppSettings())
        .environmentObject(DataManager())
}
