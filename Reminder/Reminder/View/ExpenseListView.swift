import SwiftUI

struct ExpenseListView: View {
    @Binding var period: ExpensePeriod
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            // Gelirler
            Section(header: Text("Gelirler")) {
                ForEach(period.incomes) { income in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(income.title)
                                .font(.headline)
                            Text(income.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("+" + income.amount.formatted(.currency(code: "TRY")))
                            .foregroundColor(.green)
                    }
                }
                .onDelete { indexSet in
                    period.incomes.remove(atOffsets: indexSet)
                }
            }
            
            // Harcamalar
            Section(header: Text("Harcamalar")) {
                ForEach(period.expenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.title)
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: expense.category.icon)
                                    .foregroundColor(expense.category.color)
                                Text(expense.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("-" + expense.amount.formatted(.currency(code: "TRY")))
                                .foregroundColor(.red)
                            
                            if let notes = expense.notes {
                                Text(notes)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    period.expenses.remove(atOffsets: indexSet)
                }
            }
            
            // Özet
            Section(header: Text("Özet")) {
                HStack {
                    Text("Toplam Gelir")
                    Spacer()
                    Text("+" + period.income.formatted(.currency(code: "TRY")))
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Toplam Gider")
                    Spacer()
                    Text("-" + period.totalExpense.formatted(.currency(code: "TRY")))
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("Net Durum")
                    Spacer()
                    Text(period.balance.formatted(.currency(code: "TRY")))
                        .foregroundColor(period.balance >= 0 ? .blue : .red)
                }
            }
        }
        .navigationTitle("Hesap Hareketleri")
        .toolbar {
            Button("Kapat") {
                dismiss()
            }
        }
    }
} 
