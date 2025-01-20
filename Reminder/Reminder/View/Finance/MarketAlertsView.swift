import SwiftUI

struct MarketAlertsView: View {
    @State private var alerts: [MarketAlert] = []
    @State private var showingAddAlert = false
    
    var body: some View {
        List {
            ForEach(alerts) { alert in
                MarketAlertRow(alert: alert)
            }
            .onDelete(perform: deleteAlert)
        }
        .navigationTitle("Piyasa Alarmları")
        .toolbar {
            Button {
                showingAddAlert = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddAlert) {
            AddMarketAlertView(alerts: $alerts)
        }
    }
    
    private func deleteAlert(at offsets: IndexSet) {
        alerts.remove(atOffsets: offsets)
    }
}

struct MarketAlert: Identifiable {
    let id = UUID()
    var symbol: String
    var targetPrice: Double
    var isAboveTarget: Bool
    var isActive: Bool
}

struct MarketAlertRow: View {
    let alert: MarketAlert
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(alert.symbol)
                    .font(.headline)
                Text(alert.isAboveTarget ? "Üstünde" : "Altında")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(alert.targetPrice.formatted(.currency(code: "USD")))
                .foregroundColor(alert.isActive ? .blue : .gray)
        }
    }
}

struct AddMarketAlertView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var alerts: [MarketAlert]
    
    @State private var symbol = ""
    @State private var targetPrice = ""
    @State private var isAboveTarget = true
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Sembol", text: $symbol)
                TextField("Hedef Fiyat", text: $targetPrice)
                    .keyboardType(.decimalPad)
                Toggle("Fiyat Üstünde", isOn: $isAboveTarget)
            }
            .navigationTitle("Yeni Alarm")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let price = Double(targetPrice) {
                        let alert = MarketAlert(
                            symbol: symbol,
                            targetPrice: price,
                            isAboveTarget: isAboveTarget,
                            isActive: true
                        )
                        alerts.append(alert)
                        dismiss()
                    }
                }
                .disabled(symbol.isEmpty || targetPrice.isEmpty)
            )
        }
    }
} 
