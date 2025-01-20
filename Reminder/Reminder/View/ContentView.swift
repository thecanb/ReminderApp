//
//  ContentView.swift
//  Reminder
//
//  Created by Mert Canbaz on 9.01.2025.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var settings: AppSettings
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(dataManager)
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            ReminderListView(reminders: $dataManager.reminders, groups: $dataManager.groups)
                .tabItem {
                    Label("Anımsatıcılar", systemImage: "list.bullet.circle.fill")
                }
            
            ShoppingListView(items: $dataManager.shoppingItems)
                .tabItem {
                    Label("Alışveriş", systemImage: "cart")
                }
            
            ExpenseManagerView(periods: $dataManager.periods)
                .tabItem {
                    Label("Masraflar", systemImage: "creditcard")
                }
            
            FinanceView()
                .tabItem {
                    Label("Finans", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .environmentObject(dataManager)
        .task {
            await NotificationManager.shared.resetBadgeCount()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await NotificationManager.shared.resetBadgeCount()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
        .environmentObject(AppSettings())
}
