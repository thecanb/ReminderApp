import SwiftUI

struct AddLoanView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var loans: [Loan]
    @EnvironmentObject var settings: AppSettings
    
    @State private var title = ""
    @State private var amount = ""
    @State private var remainingAmount = ""
    @State private var interestRate = ""
    @State private var notes = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(31536000) // 1 yıl sonrası
    @State private var selectedType = Loan.LoanType.personal
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Kredi Adı", text: $title)
                    TextField("Kredi Tutarı", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Kalan Tutar", text: $remainingAmount)
                        .keyboardType(.decimalPad)
                    TextField("Faiz Oranı (%)", text: $interestRate)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Picker("Kredi Tipi", selection: $selectedType) {
                        ForEach(Loan.LoanType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    DatePicker("Başlangıç", selection: $startDate, displayedComponents: .date)
                    DatePicker("Bitiş", selection: $endDate, displayedComponents: .date)
                }
                
                Section {
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Kredi")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amountValue = Double(amount),
                       let remainingValue = Double(remainingAmount),
                       let interestValue = Double(interestRate) {
                        let loan = Loan(
                            title: title,
                            amount: amountValue,
                            remainingAmount: remainingValue,
                            interestRate: interestValue,
                            startDate: startDate,
                            endDate: endDate,
                            notes: notes.isEmpty ? nil : notes,
                            type: selectedType
                        )
                        loans.append(loan)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || amount.isEmpty || remainingAmount.isEmpty || interestRate.isEmpty)
            )
        }
    }
}

#Preview {
    AddLoanView(loans: .constant([]))
} 
