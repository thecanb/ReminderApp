import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var dataManager: DataManager
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfService = false
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Tema ve Görünüm
                Section("Görünüm ve Dil") {
                    Picker("Tema", selection: $settings.theme) {
                        Label("Açık", systemImage: "sun.max.fill")
                            .tag(AppSettings.AppTheme.light)
                        
                        Label("Koyu", systemImage: "moon.fill")
                            .tag(AppSettings.AppTheme.dark)
                        
                        Label("Sistem", systemImage: "circle.lefthalf.filled")
                            .tag(AppSettings.AppTheme.system)
                    }
                    
                }
                
                // Para Birimi
                Section("Para Birimi") {
                    Picker("Para Birimi", selection: $settings.currency) {
                        ForEach(AppSettings.Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                }
                
                // Bildirimler
                Section("Bildirimler") {
                    Toggle("Bildirimlere İzin Ver", isOn: $settings.notificationsEnabled)
                    
                    if settings.notificationsEnabled {
                        Picker("Erken Bildirim", selection: $settings.earlyNotificationTime) {
                            Text("15 dakika önce").tag(15)
                            Text("30 dakika önce").tag(30)
                            Text("1 saat önce").tag(60)
                        }
                    }
                }
                
                // Veri Yönetimi
                Section("Veri Yönetimi") {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Tüm Verileri Sıfırla", systemImage: "trash.fill")
                    }
                    
                    // iCloud ayarını şimdilik gizliyoruz
                    /* if settings.iCloudSyncEnabled {
                        Toggle("iCloud Senkronizasyonu", isOn: $settings.iCloudSyncEnabled)
                    } */
                }
                
                // Yasal
                Section("Yasal") {
                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        Label("Gizlilik Politikası", systemImage: "hand.raised.fill")
                    }
                    
                    Button {
                        showTermsOfService = true
                    } label: {
                        Label("Kullanıcı Sözleşmesi", systemImage: "doc.text.fill")
                    }
                }
                
                // Uygulama Bilgileri
                Section("Uygulama Bilgileri") {
                    HStack {
                        Label("Versiyon", systemImage: "info.circle.fill")
                        Spacer()
                        Text(Bundle.main.appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Geliştirici", systemImage: "person.fill")
                        Spacer()
                        Text("Mert Canbaz")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://apps.apple.com/app/idXXXXXXXXXX")!) {
                        Label("Uygulamayı Değerlendir", systemImage: "star.bubble.fill")
                    }
                }
                
                // İletişim ve Destek
                Section("İletişim") {
                    Link(destination: URL(string: "mailto:ismertcanbaz@gmail.com")!) {
                        Label("E-posta", systemImage: "envelope.fill")
                    }
                    
                    Link(destination: URL(string: "https://twitter.com/mertvecanbaz")!) {
                        Label("Twitter", systemImage: "bird.fill")
                    }
                }
            }
            .navigationTitle("Ayarlar")

            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showTermsOfService) {
                TermsOfServiceView()
            }
            .alert("Tüm Verileri Sıfırla", isPresented: $showResetAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sıfırla", role: .destructive) {
                    withAnimation {
                        dataManager.resetAllData()
                    }
                }
            } message: {
                Text("Tüm verileriniz kalıcı olarak silinecek. Bu işlem geri alınamaz.")
            }
        }
    }
}
