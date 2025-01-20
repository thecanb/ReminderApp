import Foundation
import SwiftUI

// Grafik veri modelleri
struct ExpenseAnalytics {
    // Aylık özet
    struct MonthlySummary {
        let month: Date
        let total: Double
        let byCategory: [ExpenseCategory: Double]
    }
    
    // Kategori özeti
    struct CategorySummary {
        let category: ExpenseCategory
        let amount: Double
        let percentage: Double
        let count: Int
    }
    
    // Trend analizi
    struct TrendAnalysis {
        let previousMonth: Double
        let currentMonth: Double
        let percentageChange: Double
        let trend: Trend
        
        enum Trend {
            case increasing, decreasing, stable
        }
    }
}

// Hedef modeli
struct SavingsGoal: Identifiable, Codable {
    let id: UUID
    var title: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    var notes: String?
    var transactions: [SavingsTransaction]
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return currentAmount / targetAmount
    }
    
    var remainingAmount: Double {
        targetAmount - currentAmount
    }
    
    init(id: UUID = UUID(),
         title: String,
         targetAmount: Double,
         currentAmount: Double = 0,
         deadline: Date? = nil,
         notes: String? = nil,
         transactions: [SavingsTransaction] = []) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.notes = notes
        self.transactions = transactions
    }
}

struct SavingsTransaction: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var date: Date
    var notes: String?
    
    init(id: UUID = UUID(), amount: Double, date: Date = Date(), notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.date = date
        self.notes = notes
    }
}
