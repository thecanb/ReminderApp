import SwiftUI

struct LoanView: View {
    @Binding var loans: [Loan]
    @State private var showingAddLoan = false
    @State private var showingPayment = false
    @State private var selectedLoan: Loan?
    @EnvironmentObject var settings: AppSettings
    
    var totalLoanAmount: Double {
        loans.reduce(0) { $0 + $1.amount }
    }
    
    var totalRemainingAmount: Double {
        loans.reduce(0) { $0 + $1.remainingAmount }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Kredi Özeti Kartı
                LoanSummaryCard(
                    totalAmount: totalLoanAmount,
                    remainingAmount: totalRemainingAmount
                )
                .padding(.horizontal)
                
                // Krediler Listesi
                LazyVStack(spacing: 15) {
                    ForEach(loans) { loan in
                        LoanCard(loan: loan)
                            .padding(.horizontal)
                            .contextMenu {
                                Button {
                                    selectedLoan = loan
                                    showingPayment = true
                                } label: {
                                    Label("Ödeme Yap", systemImage: "banknote")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        loans.removeAll { $0.id == loan.id }
                                    }
                                } label: {
                                    Label("Sil", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedLoan = loan
                                showingPayment = true
                            }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Krediler")
        .toolbar {
            Button {
                showingAddLoan = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showingAddLoan) {
            AddLoanView(loans: $loans)
        }
        .sheet(item: $selectedLoan) { loan in
            MakePaymentView(loan: loan, loans: $loans)
        }
    }
}

struct LoanSummaryCard: View {
    let totalAmount: Double
    let remainingAmount: Double
    @EnvironmentObject var settings: AppSettings
    
    var paidAmount: Double {
        totalAmount - remainingAmount
    }
    
    var paymentProgress: Double {
        guard totalAmount > 0 else { return 0 }
        return min(max(paidAmount / totalAmount, 0), 1)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Toplam Borç
            VStack(spacing: 8) {
                Text("Toplam Borç")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(totalAmount.formatted(.currency(code: settings.currency.rawValue)))
                    .font(.title)
                    .bold()
            }
            
            // İlerleme
            VStack(spacing: 8) {
                ProgressView(value: paymentProgress, total: 1.0)
                    .tint(.orange)
                
                HStack {
                    Text("Ödenen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(paidAmount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .bold()
                }
                
                HStack {
                    Text("Kalan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(remainingAmount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .bold()
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

struct LoanCard: View {
    let loan: Loan
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 15) {
            // Başlık ve Tutar
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(loan.title)
                        .font(.headline)
                    Text(loan.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(loan.amount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.headline)
                    Text("Faiz: %\(String(format: "%.2f", loan.interestRate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // İlerleme
            ProgressView(value: loan.progress, total: 1.0)
                .tint(.orange)
            
            // Detaylar
            HStack {
                VStack(alignment: .leading) {
                    Text("Kalan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(loan.remainingAmount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Aylık Taksit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(loan.monthlyPayment.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                }
            }
            
            if let notes = loan.notes {
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

struct MakePaymentView: View {
    @Environment(\.dismiss) var dismiss
    let loan: Loan
    @Binding var loans: [Loan]
    @EnvironmentObject var settings: AppSettings
    
    @State private var amount = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Ödeme Tutarı", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                    TextField("Not", text: $notes)
                }
                
                Section {
                    HStack {
                        Text("Kalan Borç")
                        Spacer()
                        Text(loan.remainingAmount.formatted(.currency(code: settings.currency.rawValue)))
                    }
                    
                    HStack {
                        Text("Aylık Taksit")
                        Spacer()
                        Text(loan.monthlyPayment.formatted(.currency(code: settings.currency.rawValue)))
                    }
                    
                    if let paymentAmount = Double(amount) {
                        HStack {
                            Text("Ödeme Sonrası Kalan")
                            Spacer()
                            Text((loan.remainingAmount - paymentAmount).formatted(.currency(code: settings.currency.rawValue)))
                                .foregroundColor(paymentAmount > loan.remainingAmount ? .red : .primary)
                        }
                    }
                }
            }
            .navigationTitle("Ödeme Yap")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Öde") {
                    if let paymentAmount = Double(amount),
                       paymentAmount <= loan.remainingAmount {
                        if let index = loans.firstIndex(where: { $0.id == loan.id }) {
                            var updatedLoan = loan
                            updatedLoan.remainingAmount -= paymentAmount
                            if !notes.isEmpty {
                                updatedLoan.notes = notes
                            }
                            loans[index] = updatedLoan
                        }
                        dismiss()
                    }
                }
                .disabled(amount.isEmpty || Double(amount) ?? 0 > loan.remainingAmount)
            )
        }
    }
} 
