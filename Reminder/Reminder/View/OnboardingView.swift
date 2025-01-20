import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var hasReadTerms = false
    @State private var hasReadPrivacy = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hoş Geldiniz")
                .font(.largeTitle)
                .bold()
            
            Text("Başlamadan önce lütfen kullanıcı sözleşmesi ve gizlilik politikasını okuyup onaylayın.")
                .multilineTextAlignment(.center)                .padding()
            
            Button {
                showTerms = true
            } label: {
                Label("Kullanıcı Sözleşmesi", systemImage: "doc.text.fill")
            }
            .sheet(isPresented: $showTerms) {
                TermsOfServiceView()
                    .onDisappear {
                        hasReadTerms = true
                    }
            }
            
            Button {
                showPrivacy = true
            } label: {
                Label("Gizlilik Politikası", systemImage: "hand.raised.fill")
            }
            .sheet(isPresented: $showPrivacy) {
                PrivacyPolicyView()
                    .onDisappear {
                        hasReadPrivacy = true
                    }
            }
            
            Button("Kabul Et ve Devam Et") {
                hasAcceptedTerms = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(!(hasReadTerms && hasReadPrivacy))
            
            Text("Devam ederek tüm şartları kabul etmiş olursunuz.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
