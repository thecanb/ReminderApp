import SwiftUI

struct ExpenseSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var settings = AppSettings()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Para Birimi") {
                    Picker("Para Birimi", selection: $settings.currency) {
                        ForEach(AppSettings.Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                }
                
                Section("Dönem Başlangıcı") {
                    Stepper("Ayın \(settings.periodStartDay). günü", value: $settings.periodStartDay, in: 1...31)
                }
                
                Section("Bildirimler") {
                    Toggle("Bildirimler", isOn: $settings.notificationsEnabled)
                }
                
                Section("Tema") {
                    Picker("Tema", selection: $settings.theme) {
                        Text("Açık").tag(AppSettings.AppTheme.light)
                        Text("Koyu").tag(AppSettings.AppTheme.dark)
                        Text("Sistem").tag(AppSettings.AppTheme.system)
                    }
                }
                
                Section("Dışa Aktarma") {
                    Picker("Dosya Formatı", selection: $settings.exportFormat) {
                        ForEach(AppSettings.ExportFormat.allCases, id: \.self) { format in
                            Text(format.rawValue.uppercased()).tag(format)
                        }
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarItems(
                trailing: Button("Tamam") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    ExpenseSettingsView()
} 
