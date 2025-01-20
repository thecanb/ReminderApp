import SwiftUI

struct EditShoppingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var item: ShoppingItem
    
    @State private var title: String
    @State private var urlString: String
    @State private var notes: String
    @State private var price: String
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    init(item: Binding<ShoppingItem>) {
        _item = item
        _title = State(initialValue: item.wrappedValue.title)
        _urlString = State(initialValue: item.wrappedValue.url.absoluteString)
        _notes = State(initialValue: item.wrappedValue.notes ?? "")
        _price = State(initialValue: item.wrappedValue.price ?? "")
        
        if let imageData = item.wrappedValue.imageData {
            _selectedImage = State(initialValue: UIImage(data: imageData))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("URL", text: $urlString)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                    TextField("Başlık", text: $title)
                    TextField("Fiyat", text: $price)
                    TextField("Notlar", text: $notes)
                }
                
                Section("Ürün Fotoğrafı") {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Button {
                        showingImagePicker = true
                    } label: {
                        Label(selectedImage == nil ? "Fotoğraf Ekle" : "Fotoğrafı Değiştir",
                              systemImage: "photo.on.rectangle.angled")
                    }
                }
            }
            .navigationTitle("Düzenle")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    if let url = URL(string: urlString) {
                        item.title = title
                        item.url = url
                        item.notes = notes.isEmpty ? nil : notes
                        item.price = price.isEmpty ? nil : price
                        item.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                        dismiss()
                    }
                }
                .disabled(urlString.isEmpty || title.isEmpty)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

#Preview {
    EditShoppingView(item: .constant(
        ShoppingItem(
            title: "Test Item",
            url: URL(string: "https://example.com")!,
            notes: "Test notes",
            price: "299₺",
            imageData: UIImage(systemName: "photo")?.pngData()
        )
    ))
} 
