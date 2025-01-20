import Foundation
import SwiftUI

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var url: URL
    var notes: String?
    var price: String?
    var quantity: Int
    var isCompleted: Bool
    var isArchived: Bool
    var archivedDate: Date?
    var imageData: Data?
    var addedDate: Date
    
    init(id: UUID = UUID(),
         title: String,
         url: URL,
         notes: String? = nil,
         price: String? = nil,
         quantity: Int = 1,
         isCompleted: Bool = false,
         isArchived: Bool = false,
         archivedDate: Date? = nil,
         imageData: Data? = nil,
         addedDate: Date = Date()) {
        self.id = id
        self.title = title
        self.url = url
        self.notes = notes
        self.price = price
        self.quantity = quantity
        self.isCompleted = isCompleted
        self.isArchived = isArchived
        self.archivedDate = archivedDate
        self.imageData = imageData
        self.addedDate = addedDate
    }
}
