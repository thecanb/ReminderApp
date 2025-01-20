import SwiftUI

struct ExpenseManagerView: View {
    @Binding var periods: [ExpensePeriod]
    @StateObject private var settings = AppSettings()
    @State private var showingAddExpense = false
    @State private var showingAddIncome = false
    @State private var showingSettings = false
    @State private var showingTransactions = false
    
    // Eğer dönem yoksa, yeni bir dönem oluştur
    private func ensureCurrentPeriod() {
        if periods.isEmpty {
            let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
            let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) ?? Date()
            
            let newPeriod = ExpensePeriod(
                startDate: startDate,
                endDate: endDate
            )
            periods.append(newPeriod)
        }
    }
    
    // Para birimi formatı için
    private func formatCurrency(_ amount: Double) -> String {
        amount.formatted(.currency(code: settings.currency.rawValue))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let period = periods.first {
                        // Özet Kartı
                        VStack(spacing: 16) {
                            Text("\(period.startDate.formatted(date: .abbreviated, time: .omitted)) - \(period.endDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            // Gelir kartı
                            ModernCardView(
                                title: "Gelir",
                                subtitle: period.income.formatted(.currency(code: settings.currency.rawValue)),
                                date: "",
                                icon: "arrow.down.circle.fill",
                                color: .green,
                                status: "Toplam"
                            )
                            
                            // Gider kartı
                            ModernCardView(
                                title: "Gider",
                                subtitle: period.totalExpense.formatted(.currency(code: settings.currency.rawValue)),
                                date: "",
                                icon: "arrow.up.circle.fill",
                                color: .red,
                                status: "Toplam"
                            )
                            
                            // Kalan kartı
                            ModernCardView(
                                title: "Kalan",
                                subtitle: period.balance.formatted(.currency(code: settings.currency.rawValue)),
                                date: "",
                                icon: "equal.circle.fill",
                                color: period.balance >= 0 ? .blue : .red,
                                status: "Net"
                            )
                        }
                        .padding(.horizontal)
                        
                        // Kategorilere göre harcamalar
                        if !period.expenses.isEmpty {
                            Section(header: SectionHeaderView(title: "Kategoriler")) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible())
                                ], spacing: 16) {
                                    ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                        let expenses = period.expenses.filter { $0.category == category }
                                        if !expenses.isEmpty {
                                            ModernCardView(
                                                title: category.rawValue,
                                                subtitle: expenses.reduce(0) { $0 + $1.amount }
                                                    .formatted(.currency(code: settings.currency.rawValue)),
                                                date: "",
                                                icon: category.icon,
                                                color: category.color,
                                                status: "\(expenses.count) harcama"
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        // Hiç dönem yoksa bir mesaj göster
                        ContentUnavailableView("Henüz bir dönem yok",
                                             systemImage: "calendar.badge.exclamationmark")
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Masraflar")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingAddExpense = true
                        } label: {
                            Label("Harcama Ekle", systemImage: "arrow.up.circle.fill")
                        }
                        
                        Button {
                            showingAddIncome = true
                        } label: {
                            Label("Gelir Ekle", systemImage: "arrow.down.circle.fill")
                        }
                        
                        Button {
                            showingTransactions = true
                        } label: {
                            Label("Hesap Hareketleri", systemImage: "list.bullet.rectangle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                ensureCurrentPeriod() // Görünüm yüklendiğinde dönem kontrolü
            }
            .sheet(isPresented: $showingAddExpense) {
                if let _ = periods.first {
                    AddExpenseView(periods: $periods)
                }
            }
            .sheet(isPresented: $showingAddIncome) {
                if let _ = periods.first {
                    AddIncomeView(periods: $periods)
                }
            }
            .sheet(isPresented: $showingSettings) {
                ExpenseSettingsView()
            }
            .sheet(isPresented: $showingTransactions) {
                if let index = periods.firstIndex(where: { $0.id == periods[0].id }) {
                    NavigationView {
                        ExpenseListView(period: $periods[index])
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseManagerView(periods: .constant([]))
}
