import SwiftUI

struct StatisticsCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(NSLocalizedString(title, comment: ""))
                    .foregroundColor(.primary)
            }
            Text("\(count)")
                .font(.title2)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.1), radius: 5)
        )
    }
} 
