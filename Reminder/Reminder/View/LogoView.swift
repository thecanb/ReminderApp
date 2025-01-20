import SwiftUI

struct LogoView: View {
    var body: some View {
        ZStack {
            // Arka plan
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Logo elementi
            VStack(spacing: 5) {
                Image(systemName: "bell.badge.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Y")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
} 
