import SwiftUI
import LocalAuthentication

struct BiometricLockView: View {
    @Binding var isUnlocked: Bool
    @State private var error: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.fill")
                .font(.system(size: 50))
                .foregroundColor(.purple)
            
            Text("Uygulamayı Kilidi Aç")
                .font(.title2)
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Kimlik Doğrula") {
                authenticate()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            authenticate()
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                 localizedReason: "Uygulamaya erişmek için kimlik doğrulama gerekli") { success, error in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else if let error = error {
                        self.error = error.localizedDescription
                    }
                }
            }
        } else {
            self.error = "Biyometrik kimlik doğrulama kullanılamıyor"
        }
    }
}
