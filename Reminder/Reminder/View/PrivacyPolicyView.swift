import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Gizlilik Politikası")
                            .font(.title)
                            .bold()
                        
                        Text("Son güncelleme: \(Date.now.formatted(date: .long, time: .omitted))")
                            .foregroundColor(.secondary)
                        
                        Text("1. Toplanan Veriler")
                            .font(.headline)
                        Text("Bu uygulama, yalnızca kullanıcının cihazında saklanan verileri toplar ve işler. Toplanan veriler şunlardır:\n• Anımsatıcılar\n• Alışveriş listeleri\n• Masraf kayıtları\n• Kullanıcı tercihleri")
                        
                        Text("2. Veri Kullanımı")
                            .font(.headline)
                        Text("Toplanan veriler sadece uygulama işlevselliğini sağlamak için kullanılır ve üçüncü taraflarla paylaşılmaz. iCloud kullanımı durumunda, veriler kullanıcının kendi iCloud hesabında saklanır.")
                        
                        Text("3. Veri Güvenliği")
                            .font(.headline)
                        Text("Verileriniz cihazınızda güvenli bir şekilde saklanır ve iOS'un sağladığı güvenlik önlemleriyle korunur.")
                    }
                    
                    Group {
                        Text("4. Bildirimler")
                            .font(.headline)
                        Text("Uygulama, kullanıcının izin verdiği durumlarda anımsatıcılar için bildirimler gönderir. Bu bildirimler sadece cihaz üzerinde işlenir.")
                        
                        Text("5. İletişim")
                            .font(.headline)
                        Text("Gizlilik politikası hakkında sorularınız için:\nismertcanbaz@gmail.com")
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Kapat") {
                dismiss()
            })
        }
    }
} 
