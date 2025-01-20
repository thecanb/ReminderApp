import Foundation

struct MarketData: Codable, Identifiable {
    var id: UUID
    let symbol: String
    let price: Double
    let change24h: Double
    let lastUpdated: Date
    
    init(symbol: String, price: Double, change24h: Double, lastUpdated: Date) {
        self.id = UUID()
        self.symbol = symbol
        self.price = price
        self.change24h = change24h
        self.lastUpdated = lastUpdated
    }
    
    enum MarketType: String, Codable, CaseIterable {
        case currency = "Döviz"
        case crypto = "Kripto"
        
        var symbols: [String] {
            switch self {
            case .currency:
                return [
                    "USD/TRY", // Amerikan Doları
                    "EUR/TRY", // Euro
                    "GBP/TRY", // İngiliz Sterlini
                    "JPY/TRY", // Japon Yeni
                    "CHF/TRY", // İsviçre Frangı
                    "AUD/TRY", // Avustralya Doları
                    "CAD/TRY", // Kanada Doları
                    "CNY/TRY", // Çin Yuanı
                    "RUB/TRY", // Rus Rublesi
                    "AED/TRY", // BAE Dirhemi
                    "SAR/TRY", // Suudi Riyali
                    "KWD/TRY", // Kuveyt Dinarı
                    "QAR/TRY", // Katar Riyali
                    "SEK/TRY", // İsveç Kronu
                    "NOK/TRY"  // Norveç Kronu
                ]
            case .crypto:
                return [
                    // Ana Kripto Paralar
                    "BTC/USDT",  // Bitcoin
                    "ETH/USDT",  // Ethereum
                    "BNB/USDT",  // Binance Coin
                    "XRP/USDT",  // Ripple
                    "ADA/USDT",  // Cardano
                    "SOL/USDT",  // Solana
                    "DOGE/USDT", // Dogecoin
                    "DOT/USDT",  // Polkadot
                    
                    // DeFi Tokenları
                    "UNI/USDT",  // Uniswap
                    "AAVE/USDT", // Aave
                    "LINK/USDT", // Chainlink
                    
                    
                    // Metaverse & Gaming
                    "MANA/USDT", // Decentraland
                    "SAND/USDT", // The Sandbox
                    "AXS/USDT",  // Axie Infinity
                    
                    // Stablecoin'ler
                    "USDC/USDT"  // USD Coin
                ]
            }
        }
        
        var displayNames: [String: String] {
            switch self {
            case .currency:
                return [
                    "USD/TRY": "Amerikan Doları",
                    "EUR/TRY": "Euro",
                    "GBP/TRY": "İngiliz Sterlini",
                    "JPY/TRY": "Japon Yeni",
                    "CHF/TRY": "İsviçre Frangı",
                    "AUD/TRY": "Avustralya Doları",
                    "CAD/TRY": "Kanada Doları",
                    "CNY/TRY": "Çin Yuanı",
                    "RUB/TRY": "Rus Rublesi",
                    "AED/TRY": "BAE Dirhemi",
                    "SAR/TRY": "Suudi Riyali",
                    "KWD/TRY": "Kuveyt Dinarı",
                    "QAR/TRY": "Katar Riyali",
                    "SEK/TRY": "İsveç Kronu",
                    "NOK/TRY": "Norveç Kronu"
                ]
            case .crypto:
                return [
                    "BTC/USDT": "Bitcoin",
                    "ETH/USDT": "Ethereum",
                    "BNB/USDT": "Binance Coin",
                    "XRP/USDT": "Ripple",
                    "ADA/USDT": "Cardano",
                    "SOL/USDT": "Solana",
                    "DOGE/USDT": "Dogecoin",
                    "DOT/USDT": "Polkadot",
                    "UNI/USDT": "Uniswap",
                    "AAVE/USDT": "Aave",
                    "LINK/USDT": "Chainlink",
                    "MATIC/USDT": "Polygon",
                    "MANA/USDT": "Decentraland",
                    "SAND/USDT": "The Sandbox",
                    "AXS/USDT": "Axie Infinity",
                    "BUSD/USDT": "Binance USD",
                    "USDC/USDT": "USD Coin"
                ]
            }
        }
    }
}

// API Yanıt Modelleri
struct SimpleExchangeResponse: Codable {
    let result: String
    let rates: [String: Double]
}

struct BinanceTickerResponse: Codable {
    let symbol: String
    let lastPrice: String
    let priceChangePercent: String
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case lastPrice
        case priceChangePercent
    }
} 
