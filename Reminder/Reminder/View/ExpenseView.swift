import SwiftUI

struct ExpenseView: View {
    @Binding var expense: Expense
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Başlık")
                    Spacer()
                    Text(expense.title)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Tutar")
                    Spacer()
                    Text(expense.amount.formatted(.currency(code: "TRY")))
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("Kategori")
                    Spacer()
                    Label(expense.category.rawValue, systemImage: expense.category.icon)
                        .foregroundColor(expense.category.color)
                }
                
                HStack {
                    Text("Tarih")
                    Spacer()
                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                        .foregroundColor(.secondary)
                }
                
                if let notes = expense.notes {
                    HStack {
                        Text("Notlar")
                        Spacer()
                        Text(notes)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Harcama Detayı")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ExpenseView(expense: .constant(
            Expense(
                title: "Market Alışverişi",
                amount: 250.50,
                category: .market,
                notes: "Haftalık market alışverişi"
            )
        ))
    }
} 
