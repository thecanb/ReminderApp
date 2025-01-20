import SwiftUI

struct ArchivedItemsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var items: [ShoppingItem]
    
    var archivedItems: [ShoppingItem] {
        items.filter { $0.isArchived }
            .sorted { ($0.archivedDate ?? Date()) > ($1.archivedDate ?? Date()) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach($items.filter { $0.isArchived.wrappedValue }) { $item in
                    ShoppingItemRow(item: $item)
                        .swipeActions(edge: .leading) {
                            Button {
                                withAnimation {
                                    item.isArchived = false
                                    item.archivedDate = nil
                                }
                            } label: {
                                Label("Arşivden Çıkar", systemImage: "arrow.uturn.backward")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = items.firstIndex(where: { $0.id == item.id }) {
                                    items.remove(at: index)
                                }
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Arşiv")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !archivedItems.isEmpty {
                        Button(role: .destructive) {
                            withAnimation {
                                items.removeAll { $0.isArchived }
                            }
                        } label: {
                            Text("Tümünü Sil")
                        }
                    }
                }
            }
            .overlay {
                if archivedItems.isEmpty {
                    ContentUnavailableView(
                        "Arşivlenmiş Ürün Yok",
                        systemImage: "archivebox",
                        description: Text("Arşivlediğiniz alışveriş öğeleri burada görünecek")
                    )
                }
            }
        }
    }
} 
