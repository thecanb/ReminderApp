import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @Published var useBiometrics: Bool = false
    @Published var theme: AppTheme = .system
    @Published var currency: Currency = .tl
    @AppStorage("selectedLanguage") var language: Language = .system {
        didSet {
            // Dil değiştiğinde Bundle'ı yenile
            Bundle.setLanguage(language.rawValue)
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    @Published var notificationsEnabled: Bool = true
    @Published var exportFormat: ExportFormat = .pdf
    @Published var periodStartDay: Int = 1
    @Published var earlyNotificationTime: Int = 30
    @Published var iCloudSyncEnabled: Bool = false
    
    enum AppTheme: String, CaseIterable {
        case light, dark, system
        
        var displayName: String {
            switch self {
            case .light: return "Açık"
            case .dark: return "Koyu"
            case .system: return "Sistem"
            }
        }
    }
    
    enum ExportFormat: String, CaseIterable {
        case pdf, excel, csv
    }
    
    enum Currency: String, Codable, CaseIterable {
        case tl = "TRY"
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        
        var symbol: String {
            switch self {
            case .tl: return "₺"
            case .usd: return "$"
            case .eur: return "€"
            case .gbp: return "£"
            }
        }
    }
    
    enum Language: String, CaseIterable {
        case system = "system"
        case tr = "tr"
        case en = "en"
        
        var displayName: String {
            switch self {
            case .system: return "Sistem"
            case .tr: return "Türkçe"
            case .en: return "English"
            }
        }
        
        var locale: Locale {
            switch self {
            case .system: return .current
            case .tr: return Locale(identifier: "tr")
            case .en: return Locale(identifier: "en")
            }
        }
    }
    
    func translate(_ text: String) -> String {
        // Bundle'dan ilgili dile ait Localizable.strings dosyasını otomatik kullanır
        return NSLocalizedString(text, bundle: .main, comment: "")
    }
}

// Bundle extension ekleyelim
extension Bundle {
    private static var bundle: Bundle?
    
    static func setLanguage(_ language: String) {
        let languageCode = language == "system" ? Locale.current.language.languageCode?.identifier ?? "en" : language
        
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            self.bundle = Bundle.main
            return
        }
        
        self.bundle = bundle
    }
    
    static func localizedBundle() -> Bundle {
        return bundle ?? Bundle.main
    }
}
