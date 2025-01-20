import SwiftUI

@main
struct ReminderApp: App {
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms = false
    @StateObject private var dataManager = DataManager()
    @StateObject private var appSettings = AppSettings()
    
    init() {
        // Bildirim izinlerini iste
        NotificationManager.shared.requestAuthorization()
        
        // Badge'i sıfırla
        Task {
            await NotificationManager.shared.resetBadgeCount()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if hasAcceptedTerms {
                ContentView()
                    .environmentObject(dataManager)
                    .environmentObject(appSettings)
                    .environment(\.locale, appSettings.language.locale)
            } else {
                OnboardingView()
                    .environmentObject(dataManager)
                    .environmentObject(appSettings)
                    .environment(\.locale, appSettings.language.locale)
            }
        }
    }
}

// AppTheme için colorScheme özelliği ekleyelim
extension AppSettings.AppTheme {
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
