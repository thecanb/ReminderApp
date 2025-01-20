import Foundation

// Döviz modeli
struct Currency: Identifiable, Codable {
    var id: UUID
    let symbol: String
    let name: String
    let rate: Double
    let change24h: Double
    
    var isIncreasing: Bool { change24h > 0 }
    
    init(id: UUID = UUID(), symbol: String, name: String, rate: Double, change24h: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.rate = rate
        self.change24h = change24h
    }
}

// Kripto para modeli
struct Crypto: Identifiable, Codable {
    var id: UUID
    let symbol: String
    let name: String
    let price: Double
    let change24h: Double
    let marketCap: Double
    let volume24h: Double
    
    var isIncreasing: Bool { change24h > 0 }
    
    init(id: UUID = UUID(), symbol: String, name: String, price: Double, change24h: Double, marketCap: Double, volume24h: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change24h = change24h
        self.marketCap = marketCap
        self.volume24h = volume24h
    }
}

// Portföy varlığı modeli
struct PortfolioAsset: Identifiable {
    var id: UUID
    var type: AssetType
    var symbol: String
    var amount: Double
    var buyPrice: Double
    
    enum AssetType {
        case currency
        case crypto
    }
    
    init(id: UUID = UUID(), type: AssetType, symbol: String, amount: Double, buyPrice: Double) {
        self.id = id
        self.type = type
        self.symbol = symbol
        self.amount = amount
        self.buyPrice = buyPrice
    }
    
    var currentValue: Double {
        // Bu değer MarketViewModel'den alınacak
        return amount * buyPrice
    }
    
    var profit: Double {
        // Bu değer MarketViewModel'den alınacak
        return 0.0
    }
}

// Fiyat alarmı modeli
struct PriceAlert: Identifiable {
    var id: UUID
    var type: AssetType
    var symbol: String
    var targetPrice: Double
    var isAbove: Bool
    var isActive: Bool
    
    enum AssetType {
        case currency
        case crypto
    }
    
    init(id: UUID = UUID(), type: AssetType, symbol: String, targetPrice: Double, isAbove: Bool, isActive: Bool) {
        self.id = id
        self.type = type
        self.symbol = symbol
        self.targetPrice = targetPrice
        self.isAbove = isAbove
        self.isActive = isActive
    }
} 
