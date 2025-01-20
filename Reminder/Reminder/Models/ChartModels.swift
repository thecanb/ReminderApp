import SwiftUI
import Charts

// Harcama verisi modeli
struct ExpenseChartData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let category: ExpenseCategory
}

// Kategori özeti modeli
struct CategorySummary: Identifiable {
    let id = UUID()
    let category: ExpenseCategory
    let amount: Double
    let percentage: Double
}

// Trend analizi modeli
struct TrendAnalysis {
    let monthlyAverage: Double
    let monthlyGrowth: Double
    let projectedNextMonth: Double
    let topCategories: [CategorySummary]
} 
