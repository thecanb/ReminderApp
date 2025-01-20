import Foundation
import SwiftUI

struct ExpensePeriod: Identifiable, Codable {
    let id: UUID
    var startDate: Date
    var endDate: Date
    var incomes: [Income]
    var expenses: [Expense]
    
    init(id: UUID = UUID(),
         startDate: Date,
         endDate: Date,
         incomes: [Income] = [],
         expenses: [Expense] = []) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.incomes = incomes
        self.expenses = expenses
    }
    
    var income: Double {
        incomes.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        income - totalExpense
    }
    
    func expensesByCategory(_ category: ExpenseCategory) -> [Expense] {
        expenses.filter { $0.category == category }
    }
    
    func totalForCategory(_ category: ExpenseCategory) -> Double {
        expensesByCategory(category).reduce(0) { $0 + $1.amount }
    }
    
    // Preview extension
    static var preview: ExpensePeriod {
        ExpensePeriod(
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date(),
            incomes: [
                Income(title: "Maaş", amount: 20000),
                Income(title: "Ek Gelir", amount: 5000, notes: "Freelance iş")
            ],
            expenses: [
                Expense(title: "Market", amount: 1500, category: .market),
                Expense(title: "Benzin", amount: 1000, category: .ulasim),
                Expense(title: "Netflix", amount: 200, category: .eglence),
                Expense(title: "Elektrik Faturası", amount: 500, category: .faturalar)
            ]
        )
    }
}

struct Income: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var date: Date
    var notes: String?
    
    init(id: UUID = UUID(),
         title: String,
         amount: Double,
         date: Date = Date(),
         notes: String? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.notes = notes
    }
}

struct Expense: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
    var notes: String?
    var imageData: Data?
    
    init(id: UUID = UUID(),
         title: String,
         amount: Double,
         category: ExpenseCategory,
         date: Date = Date(),
         notes: String? = nil,
         imageData: Data? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.notes = notes
        self.imageData = imageData
    }
}

enum ExpenseCategory: String, Codable, CaseIterable {
    case market = "Market"
    case ulasim = "Ulaşım"
    case faturalar = "Faturalar"
    case eglence = "Eğlence"
    case saglik = "Sağlık"
    case giyim = "Giyim"
    case egitim = "Eğitim"
    case diger = "Diğer"
    case ozel = "Özel"
    
    var icon: String {
        switch self {
        case .market: return "cart.fill"
        case .ulasim: return "car.fill"
        case .faturalar: return "doc.text.fill"
        case .eglence: return "tv.fill"
        case .saglik: return "heart.fill"
        case .giyim: return "tshirt.fill"
        case .egitim: return "book.fill"
        case .diger: return "ellipsis.circle.fill"
        case .ozel: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .market: return .orange
        case .ulasim: return .blue
        case .faturalar: return .green
        case .eglence: return .pink
        case .saglik: return .red
        case .giyim: return .purple
        case .egitim: return .brown
        case .diger: return .gray
        case .ozel: return .yellow
        }
    }
}
