import SwiftUI

struct AddIncomeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var periods: [ExpensePeriod]
    
    @State private var title = ""
    @State private var amount = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Başlık", text: $title)
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Tarih", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Gelir")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amountDouble = Double(amount), !title.isEmpty {
                        let income = Income(
                            title: title,
                            amount: amountDouble,
                            date: date,
                            notes: notes.isEmpty ? nil : notes
                        )
                        
                        // Mevcut döneme gelir ekle
                        if var currentPeriod = periods.first {
                            currentPeriod.incomes.append(income)
                            if let index = periods.firstIndex(where: { $0.id == currentPeriod.id }) {
                                periods[index] = currentPeriod
                            }
                        }
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || amount.isEmpty)
            )
        }
    }
}

#Preview {
    AddIncomeView(periods: .constant([ExpensePeriod.preview]))
} 
