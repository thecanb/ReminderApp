import Foundation

class DataManager: ObservableObject {
    @Published var reminders: [Reminder] = [] {
        didSet {
            saveData()
        }
    }
    @Published var groups: [ReminderGroup] = [] {
        didSet {
            saveData()
        }
    }
    @Published var shoppingItems: [ShoppingItem] = [] {
        didSet {
            saveData()
        }
    }
    @Published var periods: [ExpensePeriod] = [] {
        didSet {
            saveData()
        }
    }
    @Published var goals: [SavingsGoal] = [] {
        didSet {
            saveData()
        }
    }
    @Published var investments: [Investment] = [] {
        didSet {
            saveData()
        }
    }
    @Published var loans: [Loan] = [] {
        didSet {
            saveData()
        }
    }
    @Published var expenses: [Expense] = [] {
        didSet {
            saveData()
        }
    }
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        loadData()
    }
    
    private func saveData() {
        let data = AppData(
            reminders: reminders,
            groups: groups,
            shoppingItems: shoppingItems,
            periods: periods,
            goals: goals,
            investments: investments,
            loans: loans,
            expenses: expenses
        )
        
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Veri kaydedilemedi: \(error.localizedDescription)")
        }
    }
    
    private func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode(AppData.self, from: data)
            
            reminders = decoded.reminders
            groups = decoded.groups
            shoppingItems = decoded.shoppingItems
            periods = decoded.periods
            goals = decoded.goals
            investments = decoded.investments
            loans = decoded.loans
            expenses = decoded.expenses
        } catch {
            print("Veri yüklenemedi: \(error.localizedDescription)")
            // İlk kullanımda varsayılan veriler
            reminders = []
            groups = []
            shoppingItems = []
            periods = []
            goals = []
            investments = []
            loans = []
            expenses = []
        }
    }
    
    func resetAllData() {
        // Tüm verileri sıfırla
        reminders = []
        groups = []
        shoppingItems = []
        periods = []
        goals = []
        investments = []
        loans = []
        expenses = []
        
        // Bildirimleri temizle
        NotificationManager.shared.cancelAllNotifications()
        
        // Verileri kaydet
        saveData()
    }
}

// Tüm verileri tutacak yapı
struct AppData: Codable {
    let reminders: [Reminder]
    let groups: [ReminderGroup]
    let shoppingItems: [ShoppingItem]
    let periods: [ExpensePeriod]
    let goals: [SavingsGoal]
    let investments: [Investment]
    let loans: [Loan]
    let expenses: [Expense]
}

// FileManager extension
extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
