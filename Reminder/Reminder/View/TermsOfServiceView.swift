import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Kullanıcı Sözleşmesi")
                            .font(.title)
                            .bold()
                        
                        Text("Son güncelleme: \(Date.now.formatted(date: .long, time: .omitted))")
                            .foregroundColor(.secondary)
                        
                        Text("1. Kabul Edilen Şartlar")
                            .font(.headline)
                        Text("Bu uygulamayı kullanarak aşağıdaki şartları kabul etmiş olursunuz.")
                        
                        Text("2. Kullanım Koşulları")
                            .font(.headline)
                        Text("Uygulama sadece kişisel kullanım için tasarlanmıştır. Uygulamayı yasadışı amaçlarla kullanamazsınız.")
                        
                        Text("3. Sorumluluk Reddi")
                            .font(.headline)
                        Text("Uygulama 'olduğu gibi' sunulmaktadır. Veri kaybı veya diğer zararlardan sorumlu değiliz.")
                    }
                    
                    Group {
                        Text("4. Değişiklikler")
                            .font(.headline)
                        Text("Bu sözleşme şartları önceden haber verilmeksizin değiştirilebilir.")
                        
                        Text("5. İletişim")
                            .font(.headline)
                        Text("Sorularınız için:\nismertcanbaz@gmail.com")
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
