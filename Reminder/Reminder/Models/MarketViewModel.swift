import Foundation

class MarketViewModel: ObservableObject {
    @Published var portfolio: [PortfolioAsset] = []
    @Published var alerts: [PriceAlert] = []
    
    // Güncel döviz verileri (28.03.2024)
    @Published var currencies: [Currency] = [
        Currency(symbol: "USD", name: "Amerikan Doları", rate: 35.45, change24h: 0.15),
        Currency(symbol: "EUR", name: "Euro", rate: 36.27, change24h: 0.22),
        Currency(symbol: "GBP", name: "İngiliz Sterlini", rate: 43.25, change24h: 0.18),
        Currency(symbol: "JPY", name: "Japon Yeni", rate: 0.22, change24h: -0.05),
        Currency(symbol: "CHF", name: "İsviçre Frangı", rate: 38.63, change24h: 0.12)
    ]
    
    // Güncel kripto verileri (28.03.2024)
    @Published var cryptos: [Crypto] = [
        Crypto(symbol: "BTC", name: "Bitcoin", price: 3337399, change24h: 2.8, marketCap: 1.38e12, volume24h: 32e9),
        Crypto(symbol: "ETH", name: "Ethereum", price: 116102, change24h: 1.5, marketCap: 430e9, volume24h: 15e9),
        Crypto(symbol: "BNB", name: "Binance Coin", price: 24680, change24h: -0.8, marketCap: 88e9, volume24h: 2.5e9),
        Crypto(symbol: "SOL", name: "Solana", price: 6660, change24h: 4.2, marketCap: 85e9, volume24h: 4.2e9),
        Crypto(symbol: "ADA", name: "Cardano", price: 33, change24h: -1.5, marketCap: 25.5e9, volume24h: 950e6)
    ]
    
    // Varlık ekleme fonksiyonu
    func addAsset(_ asset: PortfolioAsset) {
        DispatchQueue.main.async {
            self.portfolio.append(asset)
            print("Varlık eklendi: \(asset.symbol), Miktar: \(asset.amount), Fiyat: \(asset.buyPrice)")
        }
    }
    
    // Alarm ekleme fonksiyonu
    func addAlert(_ alert: PriceAlert) {
        DispatchQueue.main.async {
            self.alerts.append(alert)
            print("Alarm eklendi: \(alert.symbol), Hedef: \(alert.targetPrice)")
        }
    }
    
    // Güncel değer hesaplama
    func getCurrentValue(for asset: PortfolioAsset) -> Double {
        switch asset.type {
        case .currency:
            if let currency = currencies.first(where: { $0.symbol == asset.symbol }) {
                return asset.amount * currency.rate
            }
        case .crypto:
            if let crypto = cryptos.first(where: { $0.symbol == asset.symbol }) {
                return asset.amount * crypto.price
            }
        }
        return 0.0
    }
    
    // Kar/zarar hesaplama
    func getProfit(for asset: PortfolioAsset) -> Double {
        let currentValue = getCurrentValue(for: asset)
        let initialValue = asset.amount * asset.buyPrice
        return currentValue - initialValue
    }
} 
