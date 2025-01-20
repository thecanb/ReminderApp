import SwiftUI
import VisionKit

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var periods: [ExpensePeriod]
    
    @State private var title = ""
    @State private var amount = ""
    @State private var notes = ""
    @State private var selectedCategory = ExpenseCategory.market
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Başlık", text: $title)
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .foregroundColor(category.color)
                                .tag(category)
                        }
                    }
                    
                    DatePicker("Tarih", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Harcama")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amountDouble = Double(amount), !title.isEmpty {
                        let expense = Expense(
                            title: title,
                            amount: amountDouble,
                            category: selectedCategory,
                            date: date,
                            notes: notes.isEmpty ? nil : notes
                        )
                        
                        if var currentPeriod = periods.first {
                            currentPeriod.expenses.append(expense)
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
