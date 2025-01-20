import SwiftUI

struct AddAlertView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MarketViewModel
    
    @State private var type: PriceAlert.AssetType = .currency
    @State private var symbol = ""
    @State private var targetPrice = ""
    @State private var isAbove = true
    
    // Sembol listeleri
    let currencySymbols = ["USD", "EUR", "GBP", "JPY", "CHF"]
    let cryptoSymbols = ["BTC", "ETH", "BNB", "SOL", "ADA"]
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Tip", selection: $type) {
                    Text("Döviz").tag(PriceAlert.AssetType.currency)
                    Text("Kripto").tag(PriceAlert.AssetType.crypto)
                }
                
                Picker("Sembol", selection: $symbol) {
                    ForEach(type == .currency ? currencySymbols : cryptoSymbols, id: \.self) { symbol in
                        Text(symbol).tag(symbol)
                    }
                }
                
                TextField("Hedef Fiyat", text: $targetPrice)
                    .keyboardType(.decimalPad)
                
                Toggle("Fiyat Üstünde", isOn: $isAbove)
            }
            .navigationTitle("Alarm Ekle")
            .navigationBarItems(
                leading: Button("İptal") { dismiss() },
                trailing: Button("Ekle") {
                    if let targetPrice = Double(targetPrice) {
                        let alert = PriceAlert(
                            type: type,
                            symbol: symbol,
                            targetPrice: targetPrice,
                            isAbove: isAbove,
                            isActive: true
                        )
                        viewModel.addAlert(alert)
                        dismiss()
                    }
                }
                .disabled(symbol.isEmpty || targetPrice.isEmpty)
            )
            .onAppear {
                // Varsayılan sembol seçimi
                symbol = type == .currency ? currencySymbols.first ?? "" : cryptoSymbols.first ?? ""
            }
            .onChange(of: type) { oldValue, newValue in
                // Tip değiştiğinde sembolü güncelle
                symbol = newValue == .currency ? currencySymbols.first ?? "" : cryptoSymbols.first ?? ""
            }
        }
    }
} 
