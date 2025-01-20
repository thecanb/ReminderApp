import SwiftUI

struct InvestmentView: View {
    @Binding var investments: [Investment]
    @State private var showingAddInvestment = false
    @State private var showingUpdateValue = false
    @State private var selectedInvestment: Investment?
    @EnvironmentObject var settings: AppSettings
    
    var totalInvestment: Double {
        investments.reduce(0) { $0 + $1.amount }
    }
    
    var totalValue: Double {
        investments.reduce(0) { $0 + $1.currentValue }
    }
    
    var totalProfit: Double {
        totalValue - totalInvestment
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                PortfolioSummaryCard(
                    totalInvestment: totalInvestment,
                    totalValue: totalValue,
                    totalProfit: totalProfit
                )
                .padding(.horizontal)
                
                LazyVStack(spacing: 15) {
                    ForEach(investments) { investment in
                        InvestmentCard(investment: investment)
                            .padding(.horizontal)
                            .contextMenu {
                                Button {
                                    selectedInvestment = investment
                                    showingUpdateValue = true
                                } label: {
                                    Label("Değer Güncelle", systemImage: "arrow.up.right")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        investments.removeAll { $0.id == investment.id }
                                    }
                                } label: {
                                    Label("Sil", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedInvestment = investment
                                showingUpdateValue = true
                            }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Yatırımlar")
        .toolbar {
            Button {
                showingAddInvestment = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showingAddInvestment) {
            AddInvestmentView(investments: $investments)
        }
        .sheet(item: $selectedInvestment) { investment in
            UpdateInvestmentView(investment: investment, investments: $investments)
        }
    }
}

struct PortfolioSummaryCard: View {
    let totalInvestment: Double
    let totalValue: Double
    let totalProfit: Double
    @EnvironmentObject var settings: AppSettings
    
    var profitPercentage: Double {
        guard totalInvestment > 0 else { return 0 }
        return (totalValue - totalInvestment) / totalInvestment * 100
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Toplam Değer
            VStack(spacing: 8) {
                Text("Portföy Değeri")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(totalValue.formatted(.currency(code: settings.currency.rawValue)))
                    .font(.title)
                    .bold()
            }
            
            Divider()
            
            // Detaylar
            HStack(spacing: 30) {
                // Yatırım
                VStack(spacing: 4) {
                    Text("Yatırım")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(totalInvestment.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .bold()
                }
                
                // Kâr/Zarar
                VStack(spacing: 4) {
                    Text("Kâr/Zarar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 4) {
                        Text(totalProfit.formatted(.currency(code: settings.currency.rawValue)))
                            .font(.subheadline)
                            .bold()
                        Text("(\(String(format: "%.1f", profitPercentage))%)")
                            .font(.caption2)
                    }
                    .foregroundColor(totalProfit >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
    }
}

struct InvestmentCard: View {
    let investment: Investment
    @EnvironmentObject var settings: AppSettings
    
    var profit: Double {
        investment.currentValue - investment.amount
    }
    
    var profitPercentage: Double {
        guard investment.amount > 0 else { return 0 }
        return profit / investment.amount * 100
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Başlık ve Değer
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(investment.title)
                        .font(.headline)
                    Text(investment.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(investment.currentValue.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.headline)
                    HStack(spacing: 2) {
                        Image(systemName: profit >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(String(format: "%.1f", abs(profitPercentage)))%")
                    }
                    .font(.caption)
                    .foregroundColor(profit >= 0 ? .green : .red)
                }
            }
            
            Divider()
            
            // Detaylar
            HStack {
                // Yatırım
                VStack(alignment: .leading) {
                    Text("Yatırım")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(investment.amount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Kâr/Zarar
                VStack(alignment: .trailing) {
                    Text("Kâr/Zarar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(profit.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .foregroundColor(profit >= 0 ? .green : .red)
                }
            }
            
            if let notes = investment.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
    }
}

struct UpdateInvestmentView: View {
    @Environment(\.dismiss) var dismiss
    let investment: Investment
    @Binding var investments: [Investment]
    @EnvironmentObject var settings: AppSettings
    
    @State private var currentValue = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Güncel Değer", text: $currentValue)
                        .keyboardType(.decimalPad)
                    TextField("Not", text: $notes)
                }
                
                Section {
                    HStack {
                        Text("Yatırım Tutarı")
                        Spacer()
                        Text(investment.amount.formatted(.currency(code: settings.currency.rawValue)))
                    }
                    
                    HStack {
                        Text("Önceki Değer")
                        Spacer()
                        Text(investment.currentValue.formatted(.currency(code: settings.currency.rawValue)))
                    }
                    
                    if let profit = Double(currentValue).map({ $0 - investment.amount }) {
                        HStack {
                            Text("Kâr/Zarar")
                            Spacer()
                            Text(profit.formatted(.currency(code: settings.currency.rawValue)))
                                .foregroundColor(profit >= 0 ? .green : .red)
                        }
                    }
                }
            }
            .navigationTitle("Değer Güncelle")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Güncelle") {
                    if let newValue = Double(currentValue) {
                        if let index = investments.firstIndex(where: { $0.id == investment.id }) {
                            var updatedInvestment = investment
                            updatedInvestment.currentValue = newValue
                            if !notes.isEmpty {
                                updatedInvestment.notes = notes
                            }
                            investments[index] = updatedInvestment
                        }
                        dismiss()
                    }
                }
                .disabled(currentValue.isEmpty)
            )
            .onAppear {
                currentValue = String(format: "%.2f", investment.currentValue)
                notes = investment.notes ?? ""
            }
        }
    }
} 
