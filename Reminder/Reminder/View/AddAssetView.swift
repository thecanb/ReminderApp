import SwiftUI

struct AddAssetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MarketViewModel
    
    @State private var type: PortfolioAsset.AssetType = .currency
    @State private var symbol = ""
    @State private var amount = ""
    @State private var buyPrice = ""
    
    let currencySymbols = ["USD", "EUR", "GBP", "JPY", "CHF"]
    let cryptoSymbols = ["BTC", "ETH", "BNB", "SOL", "ADA"]
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Tip", selection: $type) {
                    Text("Döviz").tag(PortfolioAsset.AssetType.currency)
                    Text("Kripto").tag(PortfolioAsset.AssetType.crypto)
                }
                
                Picker("Sembol", selection: $symbol) {
                    ForEach(type == .currency ? currencySymbols : cryptoSymbols, id: \.self) { symbol in
                        Text(symbol).tag(symbol)
                    }
                }
                
                TextField("Miktar", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Alış Fiyatı", text: $buyPrice)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Varlık Ekle")
            .navigationBarItems(
                leading: Button("İptal") { dismiss() },
                trailing: Button("Ekle") {
                    if let amount = Double(amount),
                       let buyPrice = Double(buyPrice) {
                        let asset = PortfolioAsset(
                            type: type,
                            symbol: symbol,
                            amount: amount,
                            buyPrice: buyPrice
                        )
                        viewModel.addAsset(asset)
                        dismiss()
                    }
                }
                .disabled(symbol.isEmpty || amount.isEmpty || buyPrice.isEmpty)
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
