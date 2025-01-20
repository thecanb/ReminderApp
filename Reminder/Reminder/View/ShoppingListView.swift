import SwiftUI

struct ShoppingListView: View {
    @Binding var items: [ShoppingItem]
    @State private var showingAddItem = false
    @State private var showingArchived = false
    
    var activeItems: [ShoppingItem] {
        items.filter { !$0.isArchived }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach($items.filter { !$0.isArchived.wrappedValue }) { $item in
                    NavigationLink(destination: ShoppingItemDetailView(item: $item)) {
                        ShoppingItemRow(item: $item)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation {
                                item.isArchived = true
                                item.archivedDate = Date()
                            }
                        } label: {
                            Label("Arşivle", systemImage: "archivebox")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("Alışveriş Listesi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingArchived = true
                    } label: {
                        Image(systemName: "archivebox")
                    }
                    .disabled(items.filter { $0.isArchived }.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddShoppingItemView(items: $items)
            }
            .sheet(isPresented: $showingArchived) {
                ArchivedItemsView(items: $items)
            }
            .overlay {
                if activeItems.isEmpty {
                    ContentUnavailableView(
                        "Alışveriş Listesi Boş",
                        systemImage: "cart",
                        description: Text("Yeni öğe eklemek için + butonuna dokunun")
                    )
                }
            }
        }
    }
} 
