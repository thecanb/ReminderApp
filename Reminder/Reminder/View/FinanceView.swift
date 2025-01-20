import SwiftUI

struct FinanceView: View {
    @StateObject var dataManager = FinanceDataManager()
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Özet Kartı
                    FinanceSummaryCard(dataManager: dataManager)
                        .padding(.horizontal)
                    
                    // Ana Menü
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        NavigationLink {
                            InvestmentView(investments: $dataManager.investments)
                        } label: {
                            MenuCard(
                                title: "Yatırımlar",
                                icon: "chart.pie.fill",
                                color: .blue,
                                amount: dataManager.totalInvestmentValue
                            )
                        }
                        
                        NavigationLink {
                            SavingsGoalView(goals: $dataManager.savingsGoals)
                        } label: {
                            MenuCard(
                                title: "Birikim Hedefleri",
                                icon: "target",
                                color: .green,
                                amount: dataManager.totalSavingsAmount
                            )
                        }
                        
                        NavigationLink {
                            LoanView(loans: $dataManager.loans)
                        } label: {
                            MenuCard(
                                title: "Krediler",
                                icon: "banknote",
                                color: .orange,
                                amount: dataManager.totalLoanAmount
                            )
                        }
                        
                        NavigationLink {
                            MarketView()
                        } label: {
                            MenuCard(
                                title: "Piyasalar",
                                icon: "chart.line.uptrend.xyaxis",
                                color: .purple
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Ayarlar
                    VStack(spacing: 5) {
                        Text(settings.translate("Ayarlar"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        SettingsCard {
                            VStack(spacing: 16) {
                                HStack {
                                    Label(settings.translate("Para Birimi"), systemImage: "creditcard")
                                    Spacer()
                                    Picker(settings.translate("Para Birimi"), selection: $settings.currency) {
                                        ForEach(AppSettings.Currency.allCases, id: \.self) { currency in
                                            Text(currency.rawValue).tag(currency)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Label(settings.translate("Tema"), systemImage: "moon.circle.fill")
                                    Spacer()
                                    Picker(settings.translate("Tema"), selection: $settings.theme) {
                                        ForEach(AppSettings.AppTheme.allCases, id: \.self) { theme in
                                            Text(theme.displayName).tag(theme)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle(settings.translate("Finans"))
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Özet Kartı
struct FinanceSummaryCard: View {
    @ObservedObject var dataManager: FinanceDataManager
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 15) {
            Text(settings.translate("Net Varlık"))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(dataManager.netWorth.formatted(.currency(code: settings.currency.rawValue)))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(dataManager.netWorth >= 0 ? .green : .red)
            
            HStack(spacing: 20) {
                StatView(title: settings.translate("Yatırımlar"), value: dataManager.totalInvestmentValue)
                StatView(title: settings.translate("Birikimler"), value: dataManager.totalSavingsAmount)
                StatView(title: settings.translate("Krediler"), value: dataManager.totalLoanAmount)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 10)
        )
    }
}

// Menü Kartı
struct MenuCard: View {
    let title: String
    let icon: String
    let color: Color
    var amount: Double?
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            Text(settings.translate(title))
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if let amount = amount {
                Text(amount.formatted(.currency(code: settings.currency.rawValue)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Color.clear
                    .frame(height: 20)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.1), radius: 5)
        )
    }
}

// İstatistik Görünümü
struct StatView: View {
    let title: String
    let value: Double
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 4) {
            Text(settings.translate(title))
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value.formatted(.currency(code: settings.currency.rawValue)))
                .font(.subheadline)
                .bold()
        }
    }
}

// Ayarlar Kartı
struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.1), radius: 5)
            )
            .padding(.horizontal)
    }
}

class FinanceDataManager: ObservableObject {
    @Published var investments: [Investment] = [] {
        didSet { updateTotalValues() }
    }
    @Published var savingsGoals: [SavingsGoal] = [] {
        didSet { updateTotalValues() }
    }
    @Published var loans: [Loan] = [] {
        didSet { updateTotalValues() }
    }
    
    @Published private(set) var totalInvestmentValue: Double = 0
    @Published private(set) var totalSavingsAmount: Double = 0
    @Published private(set) var totalLoanAmount: Double = 0
    @Published private(set) var netWorth: Double = 0
    
    private func updateTotalValues() {
        totalInvestmentValue = investments.reduce(0) { $0 + $1.currentValue }
        totalSavingsAmount = savingsGoals.reduce(0) { $0 + $1.currentAmount }
        totalLoanAmount = loans.reduce(0) { $0 + $1.remainingAmount }
        netWorth = totalInvestmentValue + totalSavingsAmount - totalLoanAmount
    }
    
    init() {
        // Örnek veriler
        investments = [
            Investment(title: "Apple Hisse", amount: 1000, currentValue: 1200, type: .stock),
            Investment(title: "Bitcoin", amount: 2000, currentValue: 2500, type: .crypto),
            Investment(title: "Gram Altın", amount: 1500, currentValue: 1600, type: .gold)
        ]
        
        savingsGoals = [
            SavingsGoal(title: "Araba", targetAmount: 500000, currentAmount: 150000),
            SavingsGoal(title: "Tatil", targetAmount: 50000, currentAmount: 30000),
            SavingsGoal(title: "Acil Durum", targetAmount: 100000, currentAmount: 80000)
        ]
        
        loans = [
            Loan(title: "Konut Kredisi", amount: 1000000, remainingAmount: 800000, interestRate: 1.89, endDate: Date().addingTimeInterval(31536000 * 10), type: .home),
            Loan(title: "İhtiyaç Kredisi", amount: 50000, remainingAmount: 30000, interestRate: 2.45, endDate: Date().addingTimeInterval(31536000), type: .personal)
        ]
        
        updateTotalValues() // İlk değerleri hesapla
    }
}

#Preview {
    NavigationStack {
        FinanceView()
            .environmentObject(AppSettings())
    }
} 
