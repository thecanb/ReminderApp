import SwiftUI

struct MarketView: View {
    @StateObject private var marketManager = MarketDataManager()
    @State private var selectedType: MarketData.MarketType = .currency
    
    var body: some View {
        List {
            Picker("Piyasa", selection: $selectedType) {
                ForEach(MarketData.MarketType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            
            if selectedType == .currency {
                ForEach(marketManager.currencyData) { data in
                    MarketRow(data: data)
                }
            } else {
                ForEach(marketManager.cryptoData) { data in
                    MarketRow(data: data)
                }
            }
        }
        .navigationTitle("Piyasalar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    marketManager.fetchData()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .refreshable {
            marketManager.fetchData()
        }
        .onAppear {
            marketManager.fetchData()
        }
    }
}

struct MarketRow: View {
    let data: MarketData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.symbol)
                    .font(.headline)
                Text(data.lastUpdated.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(data.price.formatted(.number.precision(.fractionLength(2))))
                    .font(.headline)
                
                Text(data.change24h.formatted(.percent.precision(.fractionLength(2))))
                    .font(.subheadline)
                    .foregroundColor(data.change24h >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        MarketView()
    }
} 
