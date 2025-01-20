import Foundation

// Yatırım modeli
struct Investment: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var currentValue: Double
    var date: Date
    var type: InvestmentType
    var notes: String?
    
    init(id: UUID = UUID(),
         title: String,
         amount: Double,
         currentValue: Double? = nil,
         date: Date = Date(),
         notes: String? = nil,
         type: InvestmentType = .stock) {
        self.id = id
        self.title = title
        self.amount = amount
        self.currentValue = currentValue ?? amount
        self.date = date
        self.notes = notes
        self.type = type
    }
    
    enum InvestmentType: String, Codable, CaseIterable {
        case stock = "Hisse Senedi"
        case crypto = "Kripto Para"
        case gold = "Altın"
        case forex = "Döviz"
        case fund = "Fon"
        case bond = "Tahvil"
        case other = "Diğer"
    }
}

// Kredi modeli
struct Loan: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var remainingAmount: Double
    var interestRate: Double
    var startDate: Date
    var endDate: Date
    var type: LoanType
    var notes: String?
    
    init(id: UUID = UUID(),
         title: String,
         amount: Double,
         remainingAmount: Double? = nil,
         interestRate: Double,
         startDate: Date = Date(),
         endDate: Date,
         notes: String? = nil,
         type: LoanType = .personal) {
        self.id = id
        self.title = title
        self.amount = amount
        self.remainingAmount = remainingAmount ?? amount
        self.interestRate = interestRate
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.type = type
    }
    
    enum LoanType: String, Codable, CaseIterable {
        case personal = "İhtiyaç Kredisi"
        case home = "Konut Kredisi"
        case vehicle = "Taşıt Kredisi"
        case student = "Öğrenim Kredisi"
        case business = "İşletme Kredisi"
        case other = "Diğer"
    }
    
    var progress: Double {
        guard amount > 0 else { return 0 }
        return 1 - (remainingAmount / amount)
    }
    
    var monthlyPayment: Double {
        let months = Calendar.current.dateComponents([.month], from: startDate, to: endDate).month ?? 0
        guard months > 0 else { return 0 }
        
        let monthlyRate = interestRate / 1200 // Yıllık faiz oranını aylığa çevir
        let denominator = pow(1 + monthlyRate, Double(months)) - 1
        let numerator = monthlyRate * pow(1 + monthlyRate, Double(months))
        
        return amount * (numerator / denominator)
    }
}
