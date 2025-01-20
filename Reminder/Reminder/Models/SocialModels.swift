import Foundation

struct SharedList {
    let id = UUID()
    var title: String
    var owner: User
    var participants: [User]
    var items: [SharedItem]
    var totalAmount: Double
    
    struct SharedItem {
        let id = UUID()
        var title: String
        var amount: Double
        var paidBy: User
        var splitBetween: [User]
    }
}

struct User {
    let id = UUID()
    var name: String
    var email: String
    var profileImage: Data?
    var sharedLists: [SharedList]
    var debts: [Debt]
    
    struct Debt {
        let id = UUID()
        var amount: Double
        var toUser: User
        var notes: String?
        var dueDate: Date?
    }
}
