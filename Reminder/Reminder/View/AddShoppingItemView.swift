import SwiftUI

struct AddShoppingItemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var items: [ShoppingItem]
    
    @State private var urlString = ""
    @State private var title = ""
    @State private var notes = ""
    @State private var price = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
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
                        Label(selectedImage == nil ? "Fotoğraf Seç" : "Fotoğrafı Değiştir",
                              systemImage: "photo.on.rectangle.angled")
                    }
                }
            }
            .navigationTitle("Yeni Ürün")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let url = URL(string: urlString) {
                        let item = ShoppingItem(
                            title: title.isEmpty ? (url.host() ?? "Yeni Ürün") : title,
                            url: url,
                            notes: notes.isEmpty ? nil : notes,
                            price: price.isEmpty ? nil : price,
                            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
                        )
                        items.append(item)
                        dismiss()
                    }
                }
                .disabled(urlString.isEmpty)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

#Preview {
    AddShoppingItemView(items: .constant([]))
} 
