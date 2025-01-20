import Foundation

class MarketDataManager: ObservableObject {
    @Published var currencyData: [MarketData] = []
    @Published var cryptoData: [MarketData] = []
    @Published var lastUpdate: Date = Date()
    @Published var isLoading = false
    
    var updateInterval: TimeInterval = 30 // saniye
    private var timer: Timer?
    
    init(updateInterval: TimeInterval = 30) {
        self.updateInterval = updateInterval
        startAutoUpdate()
    }
    
    func startAutoUpdate() {
        stopAutoUpdate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.fetchData()
        }
        fetchData() // İlk veriyi hemen al
    }
    
    func stopAutoUpdate() {
        timer?.invalidate()
        timer = nil
    }
    
    func fetchData() {
        isLoading = true
        fetchCurrencyData()
        fetchCryptoData()
    }
    
    private func fetchCurrencyData() {
        // Güncel kurlar
        guard let currentURL = URL(string: "https://open.er-api.com/v6/latest/USD") else { return }
        // 24 saat önceki kurlar
        guard let yesterdayURL = URL(string: "https://open.er-api.com/v6/latest/USD?date=\(yesterdayDateString())") else { return }
        
        let group = DispatchGroup()
        var currentRates: [String: Double]?
        var yesterdayRates: [String: Double]?
        
        group.enter()
        URLSession.shared.dataTask(with: currentURL) { data, _, _ in
            if let data = data,
               let result = try? JSONDecoder().decode(SimpleExchangeResponse.self, from: data) {
                currentRates = result.rates
            }
            group.leave()
        }.resume()
        
        group.enter()
        URLSession.shared.dataTask(with: yesterdayURL) { data, _, _ in
            if let data = data,
               let result = try? JSONDecoder().decode(SimpleExchangeResponse.self, from: data) {
                yesterdayRates = result.rates
            }
            group.leave()
        }.resume()
        
        group.notify(queue: .main) { [weak self] in
            guard let current = currentRates,
                  let yesterday = yesterdayRates else { return }
            
            var updatedCurrencyData: [MarketData] = []
            
            for symbol in MarketData.MarketType.currency.symbols {
                let baseCurrency = String(symbol.prefix(3))
                if let rate = current[baseCurrency],
                   let yesterdayRate = yesterday[baseCurrency] {
                    let tryRate = current["TRY"] ?? 1
                    let yesterdayTryRate = yesterday["TRY"] ?? 1
                    
                    let currentPrice = tryRate / rate
                    let yesterdayPrice = yesterdayTryRate / yesterdayRate
                    let change = (currentPrice - yesterdayPrice) / yesterdayPrice
                    
                    let marketData = MarketData(
                        symbol: symbol,
                        price: currentPrice,
                        change24h: change,
                        lastUpdated: Date()
                    )
                    updatedCurrencyData.append(marketData)
                }
            }
            
            self?.currencyData = updatedCurrencyData
            self?.lastUpdate = Date()
            self?.isLoading = false
        }
    }
    
    private func fetchCryptoData() {
        // Binance API'si için her sembol için ayrı istek
        for symbol in MarketData.MarketType.crypto.symbols {
            let binanceSymbol = symbol.replacingOccurrences(of: "/", with: "")
            let urlString = "https://api.binance.com/api/v3/ticker/24hr?symbol=\(binanceSymbol)"
            guard let url = URL(string: urlString) else { continue }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else {
                    print("Kripto verisi alınamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(BinanceTickerResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let marketData = MarketData(
                            symbol: symbol,
                            price: Double(result.lastPrice) ?? 0,
                            change24h: (Double(result.priceChangePercent) ?? 0) / 100,
                            lastUpdated: Date()
                        )
                        
                        // Mevcut kripto verilerini güncelle
                        var updatedCryptoData = self?.cryptoData ?? []
                        if let index = updatedCryptoData.firstIndex(where: { $0.symbol == marketData.symbol }) {
                            updatedCryptoData[index] = marketData
                        } else {
                            updatedCryptoData.append(marketData)
                        }
                        self?.cryptoData = updatedCryptoData
                        self?.lastUpdate = Date()
                        self?.isLoading = false
                    }
                } catch {
                    print("Kripto verisi işlenemedi: \(error.localizedDescription)")
                    self?.isLoading = false
                }
            }.resume()
        }
    }
    
    private func yesterdayDateString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: yesterday)
    }
    
    deinit {
        stopAutoUpdate()
    }
} 
