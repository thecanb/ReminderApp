import SwiftUI
import Charts

struct FinancialAnalyticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        List {
            // Birikim Hedefleri Grafiği
            Section("Birikim Hedefleri") {
                SavingsChart(goals: dataManager.goals)
                    .frame(height: 200)
            }
            
            // Yatırım Analizi
            Section("Yatırım Analizi") {
                InvestmentChart(investments: dataManager.investments)
                    .frame(height: 200)
            }
        }
        .navigationTitle("Finansal Analiz")
    }
}

struct SavingsChart: View {
    let goals: [SavingsGoal]
    
    var body: some View {
        if goals.isEmpty {
            EmptyChartView(message: "Henüz birikim hedefi eklenmemiş")
        } else {
            Chart(goals) { goal in
                BarMark(
                    x: .value("Hedef", goal.title),
                    y: .value("İlerleme", goal.progress * 100)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(0.6), .blue],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(8)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.2), radius: 5)
            )
        }
    }
}

struct EmptyChartView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text(message)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
    }
}

struct InvestmentChart: View {
    let investments: [Investment]
    
    var body: some View {
        if investments.isEmpty {
            Text("Henüz yatırım eklenmemiş")
                .foregroundColor(.secondary)
        } else {
            Chart(investments) { investment in
                let profit = investment.currentValue - investment.amount
                BarMark(
                    x: .value("Yatırım", investment.title),
                    y: .value("Kâr/Zarar", profit)
                )
                .foregroundStyle(
                    (profit >= 0 ? Color.green : Color.red)
                    .gradient
                )
            }
        }
    }
} 
