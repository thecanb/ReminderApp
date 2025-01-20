import SwiftUI

struct AddInvestmentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var investments: [Investment]
    @EnvironmentObject var settings: AppSettings
    
    @State private var title = ""
    @State private var amount = ""
    @State private var currentValue = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var selectedType = Investment.InvestmentType.stock
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Yatırım Adı", text: $title)
                    TextField("Yatırım Tutarı", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Güncel Değer", text: $currentValue)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Picker("Yatırım Tipi", selection: $selectedType) {
                        ForEach(Investment.InvestmentType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Yatırım")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amountValue = Double(amount) {
                        let investment = Investment(
                            title: title,
                            amount: amountValue,
                            currentValue: Double(currentValue) ?? amountValue,
                            date: date,
                            notes: notes.isEmpty ? nil : notes,
                            type: selectedType
                        )
                        investments.append(investment)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || amount.isEmpty)
            )
        }
    }
} 
